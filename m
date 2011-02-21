Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922Ab1BUTyg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 14:54:36 -0500
Received: from mail-ew0-f45.google.com ([209.85.215.45]:62662 "EHLO
	mail-ew0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296Ab1BUTyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 14:54:35 -0500
Message-ID: <4D62C2A0.6060405@mvista.com>
Date: Mon, 21 Feb 2011 22:53:04 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: "Hans J. Koch" <hjk@hansjkoch.de>
CC: "TK, Pratheesh Gangadhar" <pratheesh@ti.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "Chatterjee, Amit" <amit.chatterjee@ti.com>,
        "gregkh@suse.de" <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/2] PRUSS UIO driver support
References: <1298041530-26855-1-git-send-email-pratheesh@ti.com>	<201102181644.17634.arnd@arndb.de>	<alpine.LFD.2.00.1102181713480.2701@localhost6.localdomain6>	<201102181731.05644.arnd@arndb.de>	<alpine.LFD.2.00.1102181802580.2701@localhost6.localdomain6>	<B85A65D85D7EB246BE421B3FB0FBB593024B83C108@dbde02.ent.ti.com>	<20110219183427.GG4684@local>	<B85A65D85D7EB246BE421B3FB0FBB593024B83C20F@dbde02.ent.ti.com> <20110221193316.GC2773@local>
In-Reply-To: <20110221193316.GC2773@local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Hans J. Koch wrote:

>>> -----Original Message-----
>>> From: Hans J. Koch [mailto:hjk@hansjkoch.de]
>>> Sent: Sunday, February 20, 2011 12:04 AM
>>> To: TK, Pratheesh Gangadhar
>>> Cc: Thomas Gleixner; Arnd Bergmann; linux-arm-kernel@lists.infradead.org;
>>> davinci-linux-open-source@linux.davincidsp.com; gregkh@suse.de;
>>> Chatterjee, Amit; Hans J. Koch; LKML
>>> Subject: Re: [PATCH 1/2] PRUSS UIO driver support

>>> On Sat, Feb 19, 2011 at 09:10:23PM +0530, TK, Pratheesh Gangadhar wrote:
>>>> For my understanding - if the interrupt is not shared and not level triggered -
>>>> is this okay to have empty handler?

>>> Greg already said he won't accept that. And I'm quite sure these
>>> interrupts
>>> are level triggered, since that is the default on arch/omap.

>>> E.g. in arch/arm/mach-omap1/irq.c, a loop sets all irqs to level triggered
>>> handling: set_irq_handler(j, handle_level_irq); (line 234)

>> You should be looking at arch/arm/mach-davinci/irq.c

    Into arch/arm/mach-davinci/cp_intc.c actually as we're not talking about a 
"real" DaVincis here, but about OMAP-L138.

> Hmpf. I alway get lost in the directory structure of TI SoCs...
> At least I learned that OMAP3 is in the omap2 directory :)

    It's probably even more convoluted with DaVinci and friends. :-)

>> and all interrupts except IRQ_TINT1_TINT34 is set to edge trigger mode (line 160).

> Is that really needed? Level triggered interrupts should certainly be
> preferred if possible.

    Don't look there, this code is for "real" DaVincis only.

> Thanks,
> Hans

WBR, Sergei
