Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811Ab1BUTdZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 14:33:25 -0500
Received: from www.hansjkoch.de ([178.63.77.200]:39411 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754352Ab1BUTdY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 14:33:24 -0500
Date: Mon, 21 Feb 2011 20:33:16 +0100
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: "TK, Pratheesh Gangadhar" <pratheesh@ti.com>
Cc: "Hans J. Koch" <hjk@hansjkoch.de>, Thomas Gleixner <tglx@linutronix.de>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "Chatterjee, Amit" <amit.chatterjee@ti.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] PRUSS UIO driver support
Message-ID: <20110221193316.GC2773@local>
References: <1298041530-26855-1-git-send-email-pratheesh@ti.com>
 <201102181644.17634.arnd@arndb.de>
 <alpine.LFD.2.00.1102181713480.2701@localhost6.localdomain6>
 <201102181731.05644.arnd@arndb.de>
 <alpine.LFD.2.00.1102181802580.2701@localhost6.localdomain6>
 <B85A65D85D7EB246BE421B3FB0FBB593024B83C108@dbde02.ent.ti.com>
 <20110219183427.GG4684@local>
 <B85A65D85D7EB246BE421B3FB0FBB593024B83C20F@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B85A65D85D7EB246BE421B3FB0FBB593024B83C20F@dbde02.ent.ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 21, 2011 at 09:27:47AM +0530, TK, Pratheesh Gangadhar wrote:
> Hi Hans,
> 
> > -----Original Message-----
> > From: Hans J. Koch [mailto:hjk@hansjkoch.de]
> > Sent: Sunday, February 20, 2011 12:04 AM
> > To: TK, Pratheesh Gangadhar
> > Cc: Thomas Gleixner; Arnd Bergmann; linux-arm-kernel@lists.infradead.org;
> > davinci-linux-open-source@linux.davincidsp.com; gregkh@suse.de;
> > Chatterjee, Amit; Hans J. Koch; LKML
> > Subject: Re: [PATCH 1/2] PRUSS UIO driver support
> > 
> > On Sat, Feb 19, 2011 at 09:10:23PM +0530, TK, Pratheesh Gangadhar wrote:
> > >
> > > For my understanding - if the interrupt is not shared and not level
> > triggered -
> > > is this okay to have empty handler?
> > 
> > Greg already said he won't accept that. And I'm quite sure these
> > interrupts
> > are level triggered, since that is the default on arch/omap.
> > 
> > E.g. in arch/arm/mach-omap1/irq.c, a loop sets all irqs to level triggered
> > handling: set_irq_handler(j, handle_level_irq); (line 234)
> 
> You should be looking at arch/arm/mach-davinci/irq.c

Hmpf. I alway get lost in the directory structure of TI SoCs...
At least I learned that OMAP3 is in the omap2 directory :)

> and all interrupts except IRQ_TINT1_TINT34 is set to edge trigger mode (line 160).

Is that really needed? Level triggered interrupts should certainly be
preferred if possible.

Thanks,
Hans

