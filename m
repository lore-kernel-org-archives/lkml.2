Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757451Ab1KJICm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 03:02:42 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53778 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752570Ab1KJICk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 03:02:40 -0500
Date: Thu, 10 Nov 2011 09:00:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Anca Emanuel <anca.emanuel@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, Jim Paris <jim@jtan.com>,
        Gerd Hoffmann <kraxel@redhat.com>, Theodore Tso <tytso@mit.edu>,
        Anthony Liguori <anthony@codemonkey.ws>,
        Pekka Enberg <penberg@kernel.org>, Vince Weaver <vince@deater.net>,
        Avi Kivity <avi@redhat.com>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        Alexander Graf <agraf@suse.de>, Blue Swirl <blauwirbel@gmail.com>,
        =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [F.A.Q.] the advantages of a shared tool/kernel Git repository,
 tools/perf/ and tools/kvm/
Message-ID: <20111110080040.GB12768@elte.hu>
References: <20111108125609.GA14272@ghostprotocols.net>
 <4EB9315A.10806@redhat.com>
 <20111108143228.GC14272@ghostprotocols.net>
 <4EB94D08.3010207@redhat.com>
 <20111109085120.GD11473@elte.hu>
 <4EBA5881.7080409@redhat.com>
 <20111109115502.GA18207@ghostprotocols.net>
 <20111109192509.GA22581@psychosis.jim.sh>
 <20111109201337.GH18207@ghostprotocols.net>
 <CAJL_dMv-7Kszo1tT-HzwjeqyifBfQEy5J+pjXrnfS3o0dm8UQQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJL_dMv-7Kszo1tT-HzwjeqyifBfQEy5J+pjXrnfS3o0dm8UQQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Anca Emanuel <anca.emanuel@gmail.com> wrote:

> "I'd even argue that that C library is obviously something the 
> kernelshould offer as well - so klibc is the way to go and would 
> help usfurther streamline this and keep Linux quality high."
> 
> I think there is code to share. Why not ?

The biggest downside of libc integration into the kernel would be 
that the libc ABI is *vastly* larger than the kernel ABI, and i'm not 
sure the kernel community is good enough to handle that. It's roughly 
3000 ABI components compared to the 300 ABI functions the kernel has 
today - so at least an order of magnitude larger...

The biggest upside of libc integration into the kernel would be that 
we could push Linux kernel improvements into the C library - and thus 
to apps - immediately, along a much larger ABI surface. The 
'specialization' resolution of the libc ABI is an order of magnitude 
larger than that of the kernel's, giving many more opportunities for 
good, workload specific optimizations and unique solutions.

Today the latency of getting a kernel improvement to applications via 
a change in the C library is above a year, so most kernel people 
don't actually try to improve the C library but try to find 
improvements on the kernel level which gets to a distro within a 
couple of months.

If the kernel offers a /proc/libc.so.6 library then the kernel will 
always be 'in sync' with the library (there's no library to install 
on-disk - it would be offered by the kernel) and we could use 
integration techniques like the vDSO uses today.

Thanks,

	Ingo
