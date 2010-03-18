Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539Ab0CRRoh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 13:44:37 -0400
Received: from fallback.mail.elte.hu ([157.181.151.13]:59056 "EHLO
	fallback.mail.elte.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753156Ab0CRRog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 13:44:36 -0400
Date: Thu, 18 Mar 2010 17:13:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: Avi Kivity <avi@redhat.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
Message-ID: <20100318161310.GA447@elte.hu>
References: <20100316173940.GA23859@elte.hu>
 <4BA00F1F.1090907@codemonkey.ws>
 <20100317081041.GC16374@elte.hu>
 <4BA1E24B.6090904@redhat.com>
 <20100318085607.GB2157@elte.hu>
 <4BA1FC80.2000401@redhat.com>
 <20100318105013.GB24464@elte.hu>
 <4BA20EB8.60707@redhat.com>
 <20100318114821.GB13168@elte.hu>
 <4BA23E61.4080003@codemonkey.ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA23E61.4080003@codemonkey.ws>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Anthony Liguori <anthony@codemonkey.ws> wrote:

> On 03/18/2010 06:48 AM, Ingo Molnar wrote:
> >* Avi Kivity<avi@redhat.com>  wrote:
> >
> >>On 03/18/2010 12:50 PM, Ingo Molnar wrote:
> >>>* Avi Kivity<avi@redhat.com>   wrote:
> >>>
> >>>>>The moment any change (be it as trivial as fixing a GUI detail or as
> >>>>>complex as a new feature) involves two or more packages, development speed
> >>>>>slows down to a crawl - while the complexity of the change might be very
> >>>>>low!
> >>>>Why is that?
> >>>It's very simple: because the contribution latencies and overhead compound,
> >>>almost inevitably.
> >>It's not inevitable, if the projects are badly run, you'll have high
> >>latencies, but projects don't have to be badly run.
> >So the 64K dollar question is, why does Qemu still suck?
> 
> Why does Linux AIO still suck?  Why do we not have a proper interface in 
> userspace for doing asynchronous file system operations?

Good that you mention it, i think it's an excellent example.

The suckage of kernel async IO is for similar reasons: there's an ugly package 
separation problem between the kernel and between glibc - and between the apps 
that would make use of it.

( With the separated libaio it was made worse: there were 3 libraries to
  work with, and even less applications that could make use of it ... )

So IMO klibc is an arguably good idea - eventually hpa will get around posting 
it for upstream merging again. Then we could offer both new libraries much 
faster, and could offer things like comprehensive AIO used pervasively within 
existing APIs.

> Why don't we have an interface in userspace to do zero-copy transmit and 
> receive of raw network packets?
>
> The lack of a decent userspace API for asynchronous file system operations 
> is a huge usability problem for us.  Take a look at the complexity of our 
> -drive option.  It's all because the kernel gives us sucky interfaces.

If you had your bits in tools/kvm/ you could make a strong case for a good 
kaio implementation - coupled with an actual, working use-case. ( You could 
use the raw syscall even without klibc. )

We could see the arguments on lkml turn from:

   'do we want this and it will take years to propagate this into apps'

into something like:

   ' Exactly how much faster does kvm go? and I'd get is straight away with my
     next kernel update tomorrow? Wow! '

Ok, i exaggerated a bit - but you get the idea. It's a much different picture 
when kernel developers and maintainers see an actual use-case, _right in the 
kernel repo they work with every day_.

Currently there's a wall between kernel developers and user-space developers, 
and there's somewhat of an element of fear and arrogance on both sides. For 
efficient technology such walls needs torn down and people need a bit more 
experience with each other's areas.

	Ingo
