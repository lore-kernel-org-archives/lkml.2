Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756953Ab1GAOrQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 10:47:16 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36956 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756900Ab1GAOrO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 10:47:14 -0400
Date: Fri, 1 Jul 2011 16:46:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@infradead.org>
Cc: Petr Tesarik <ptesarik@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Fenghua Yu <fenghua.yu@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>,
        x86@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-ia64@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
        Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 00/10] Enhance /dev/mem to allow read/write of arbitrary
 physical addresses
Message-ID: <20110701144641.GA23272@elte.hu>
References: <201106171038.25988.ptesarik@suse.cz>
 <20110617093032.GA19235@elte.hu>
 <201106291106.00070.ptesarik@suse.cz>
 <20110701125802.GE12605@elte.hu>
 <20110701134705.GA6175@infradead.org>
 <20110701143735.GA21367@elte.hu>
 <20110701144129.GA10052@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110701144129.GA10052@infradead.org>
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


* Christoph Hellwig <hch@infradead.org> wrote:

> On Fri, Jul 01, 2011 at 04:37:35PM +0200, Ingo Molnar wrote:
>
> > After initial modules have loaded i essentially disable crash.ko 
> > via /proc/sys/kernel/modules_disabled so rootkits have to work a 
> > bit harder than that.
> 
> Not sure for fedora as I don'[t have a kernel tree at hand right 
> now, but for x86 systems at least RHEL6 has the module built in. 
> [...]

Fedora Rawhide has it modular:

 # grep CRASH /boot/config-2.6.38-0.rc7.git2.3.fc16.x86_64
 CONFIG_CRASH=m

 # rpm -ql kernel-2.6.38-0.rc7.git2.3.fc16.x86_64 | grep crash
 /lib/modules/2.6.38-0.rc7.git2.3.fc16.x86_64/kernel/drivers/char/crash.ko

> [...]  Either way we'll need some way to support crash properly in 
> mainline, preferably in a boot-time opt-in way. [...]

Yes, boot-time opt-in was what i suggested.

> [...] I'd tend slightly toward optionally enabling /dev/mem for it 
> instead of a separate driver, but if people prefer a different 
> route I'm fine, too.

No, sharing the driver is perfectly fine and sane as long as this 
weird usage is not enabled widely.

> Note that for normal crash usage read only access is just fine.

That's true as well. Petr?

Thanks,

	Ingo
