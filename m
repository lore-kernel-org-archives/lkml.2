Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561Ab1FPII1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 04:08:27 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33488 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753438Ab1FPIIY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 04:08:24 -0400
Date: Thu, 16 Jun 2011 10:07:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@kernel.org>
Cc: Alexander Graf <agraf@suse.de>, Anthony Liguori <anthony@codemonkey.ws>,
        Prasad Joshi <prasadjoshi124@gmail.com>, Avi Kivity <avi@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Asias He <asias.hejun@gmail.com>,
        Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [ANNOUNCE] Native Linux KVM tool v2
Message-ID: <20110616080758.GB28449@elte.hu>
References: <1308153214.7566.6.camel@jaguar>
 <4DF8DE26.1070301@redhat.com>
 <BANLkTi=SHENDBHdtFY_7_qtfqJb_+qKJSw@mail.gmail.com>
 <BANLkTinMDz-sqaX0cyWEoLXt70dowxofvg@mail.gmail.com>
 <4DF92C80.3030106@codemonkey.ws>
 <7A30A509-47AA-4E72-ABF3-937005900F9D@suse.de>
 <BANLkTi=Jm_50m6qyfQPCF0PuwUfuDNwMtg@mail.gmail.com>
 <20110616072452.GA15366@elte.hu>
 <BANLkTikkgsZFLq-X0L2mzKucJetGyOmJNQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTikkgsZFLq-X0L2mzKucJetGyOmJNQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pekka Enberg <penberg@kernel.org> wrote:

> Hi Ingo,
> 
> On Thu, Jun 16, 2011 at 10:24 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >  - executing AIO in the vcpu thread eats up precious vcpu execution
> >   time: combined QCOW2 throughput would be limited by a single
> >   core's performance, and any time spent on QCOW2 processing would
> >   not be spent running the guest CPU. (In such a model we certainly
> >   couldnt do more intelligent, CPU-intense storage solutions like on
> >   the fly compress/decompress of QCOW2 data.)
> 
> Most image formats have optional on-the-fly 
> compression/decompression so we'd need to keep the current I/O 
> thread scheme anyway.

Yeah - although high-performance setups will probably not use that.

> > I'd only consider KAIO it if it provides some *real* measurable 
> > performance advantage of at least 10% in some important usecase. 
> > A few percent probably wouldnt be worth it.
> 
> I've only been following AIO kernel development from the sidelines 
> but I really haven't seen any reports of significant gains over 
> read()/write() from a thread pool. Are there any such reports?

I've measured such gains myself a couple of years ago, using an 
Oracle DB and a well-known OLTP benchmark, on a 64-way system.

I also profiled+tuned the kernel-side AIO implementation to be more 
scalable so i'm reasonably certain that the gains exist, and they 
were above 10%.

So the kaio gains existed back then but they needed sane userspace 
(POSIX AIO with signal notification sucks) and needed a well-tuned 
in-kernel implementation as well. (the current AIO code might have 
bitrotted)

Also, synchronous read()/write() [and scheduler() :-)] scalability 
improvements have not stopped in the past few years so the 
performance picture might have shifted in favor of a thread pool.

Thanks,

	Ingo
