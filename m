Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790Ab2H0WAA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 18:00:00 -0400
Received: from mail.skyhub.de ([78.46.96.112]:52069 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754484Ab2H0V75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 17:59:57 -0400
Date: Mon, 27 Aug 2012 23:59:52 +0200
From: Borislav Petkov <bp@alien8.de>
To: Adko Branil <adkobranil@yahoo.com>
Cc: "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: HDD problem, software bug, bios bug, or hardware ?
Message-ID: <20120827215952.GA18719@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Adko Branil <adkobranil@yahoo.com>,
	"linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
	lkml <linux-kernel@vger.kernel.org>
References: <1345901771.8871.YahooMailNeo@web124706.mail.ne1.yahoo.com>
 <20120826130152.GA20021@liondog.tnic>
 <1346086872.65665.YahooMailNeo@web124704.mail.ne1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1346086872.65665.YahooMailNeo@web124704.mail.ne1.yahoo.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 27, 2012 at 10:01:12AM -0700, Adko Branil wrote:
> >Stupid question: have you tried replacing your DIMMs to see whether this
> >can be caused by a faulty DRAM?
>
> I just tried it - i have 2 banks memory each of 1 Mb - i replaced

You mean 1 Gb each, right?

> the first , then the second, then replaced both and put memory from
> another computer, tried another slots as well - the same picture -
> crashes continuing. There is no visual sign of broken capacitors on
> motherboard - all looks good. When i pass "nosmp" option to kernel
> at boot time, it crashes much faster - may be 100 times faster, and
> the pannic messages are almost the same each-other. Is it for sure
> broken hardware, and which part of hardware it should be in ? Is
> there possibility that it is bad bios, or even virus in bios, should
> upgrading bios help in this cases ?
>
> I have found 2 interesting lines in syslog:
> 
> could not find module by name='rtc_cmos'
> microcode: AMD CPU family 0xf not supported

Not relevant.

> The kernel is 3.5.2 on slackware_current with config
> http://pastebin.com/aGqH3tTR , it crashes with older kernels as well.
>

Ok, judging by the oopses this time, most of them are in handle_irq
and "nosmp" disables IO APIC so things start to point at something irq
handling related, if I would have to guess.

Hm, ok, can you rebuild that 3.5.2 kernel with the following options
enabled:

CONFIG_DEBUG_KERNEL
CONFIG_DEBUG_SHIRQ
CONFIG_DEBUG_OBJECTS
CONFIG_DEBUG_PREEMPT
CONFIG_PROVE_LOCKING
CONFIG_DEBUG_BUGVERBOSE
CONFIG_DEBUG_INFO
CONFIG_DEBUG_VM
CONFIG_DEBUG_MEMORY_INIT
CONFIG_DEBUG_LIST
CONFIG_DEBUG_RODATA

Those are all under "Kernel Hacking". Then boot this new kernel and
catch the whole dmesg up and including a couple of oopses and send them
to me.

But do not boot with "nosmp" - we want to see whether default SMP kernel
still triggers.

This should be for now.

Thanks.

-- 
Regards/Gruss,
    Boris.
