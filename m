Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756577Ab2JTSEr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 14:04:47 -0400
Received: from mail.skyhub.de ([78.46.96.112]:50762 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756453Ab2JTSEq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 14:04:46 -0400
Date: Sat, 20 Oct 2012 20:04:37 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Artem S. Tashkinov" <t.artem@lycos.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Re: A reliable kernel panic (3.6.2) and system crash when
 visiting a particular website
Message-ID: <20121020180437.GA9301@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"Artem S. Tashkinov" <t.artem@lycos.com>,
	linux-kernel@vger.kernel.org
References: <2104474742.26357.1350734815286.JavaMail.mail@webmail05>
 <20121020162759.GA12551@liondog.tnic>
 <966148591.30347.1350754909449.JavaMail.mail@webmail08>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <966148591.30347.1350754909449.JavaMail.mail@webmail08>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 20, 2012 at 05:41:49PM +0000, Artem S. Tashkinov wrote:
> On Oct 20, 2012, Borislav Petkov wrote: 
> 
> > Yeah, your kernel is tainted with a proprietary module (vbox*, etc). Can
> > you reproduce your corruptions (this is what it looks like) without that
> > module?
> 
> Yes, I can reproduce this panic with zero proprietary/non-free modules loaded.
> 
> The problem is the kernel doesn't even print a kernel panic - the
> system just freezes completely - cursor in a text console stops blinking.
> 
> I have no means to debug it using a serial console - what can I do?

Ok, here's what you can try:

* You say this happens with google chrome. Does it happen if you use
another browser: firefox, etc?

* Can you build a 64-bit kernel and try the same with it? The 32-bit
userspace should work in compat mode just fine.

* Can you run memtest on your machine and check whether your DIMMs
aren't generating ECC errors? Are your DIMMs ECC, btw?

* What about netconsole? You only need another machine on the same
network: Documentation/networking/netconsole.txt.

* boot with "pause_on_oops=600" on the kernel command line to stop the
machine for 600 secs after the first oops happens. Then try to make a
photo of the screen. Make sure to disable X or to be on a text console
so that you can see the oops.

* Try enabling a bunch of debugging options in "Kernel hacking". More
specifically,

CONFIG_DETECT_HUNG_TASK
CONFIG_DEBUG_PREEMPT
CONFIG_DEBUG_SPINLOCK
CONFIG_DEBUG_MUTEXES
CONFIG_DEBUG_LOCK_ALLOC
CONFIG_PROVE_LOCKING
CONFIG_PROVE_RCU
CONFIG_DEBUG_ATOMIC_SLEEP
CONFIG_DEBUG_BUGVERBOSE
CONFIG_DEBUG_INFO
CONFIG_DEBUG_VM
CONFIG_DEBUG_VIRTUAL
CONFIG_DEBUG_MEMORY_INIT
CONFIG_DEBUG_LIST
CONFIG_X86_VERBOSE_BOOTUP
CONFIG_DEBUG_RODATA
...

I hope those should scream in case something goes awry.

HTH.

-- 
Regards/Gruss,
    Boris.
