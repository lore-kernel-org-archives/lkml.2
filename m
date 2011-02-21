Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932160Ab1BUD6Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 22:58:16 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:36823 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753982Ab1BUD6P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 22:58:15 -0500
From: "TK, Pratheesh Gangadhar" <pratheesh@ti.com>
To: "Hans J. Koch" <hjk@hansjkoch.de>
CC: Thomas Gleixner <tglx@linutronix.de>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "Chatterjee, Amit" <amit.chatterjee@ti.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 21 Feb 2011 09:27:47 +0530
Subject: RE: [PATCH 1/2] PRUSS UIO driver support
Thread-Topic: [PATCH 1/2] PRUSS UIO driver support
Thread-Index: AcvQY6b69chRYi9/RFyrPC25/ncTqABF054w
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593024B83C20F@dbde02.ent.ti.com>
References: <1298041530-26855-1-git-send-email-pratheesh@ti.com>
 <201102181644.17634.arnd@arndb.de>
 <alpine.LFD.2.00.1102181713480.2701@localhost6.localdomain6>
 <201102181731.05644.arnd@arndb.de>
 <alpine.LFD.2.00.1102181802580.2701@localhost6.localdomain6>
 <B85A65D85D7EB246BE421B3FB0FBB593024B83C108@dbde02.ent.ti.com>
 <20110219183427.GG4684@local>
In-Reply-To: <20110219183427.GG4684@local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hans,

> -----Original Message-----
> From: Hans J. Koch [mailto:hjk@hansjkoch.de]
> Sent: Sunday, February 20, 2011 12:04 AM
> To: TK, Pratheesh Gangadhar
> Cc: Thomas Gleixner; Arnd Bergmann; linux-arm-kernel@lists.infradead.org;
> davinci-linux-open-source@linux.davincidsp.com; gregkh@suse.de;
> Chatterjee, Amit; Hans J. Koch; LKML
> Subject: Re: [PATCH 1/2] PRUSS UIO driver support
> 
> On Sat, Feb 19, 2011 at 09:10:23PM +0530, TK, Pratheesh Gangadhar wrote:
> >
> > For my understanding - if the interrupt is not shared and not level
> triggered -
> > is this okay to have empty handler?
> 
> Greg already said he won't accept that. And I'm quite sure these
> interrupts
> are level triggered, since that is the default on arch/omap.
> 
> E.g. in arch/arm/mach-omap1/irq.c, a loop sets all irqs to level triggered
> handling: set_irq_handler(j, handle_level_irq); (line 234)

You should be looking at arch/arm/mach-davinci/irq.c and all interrupts except IRQ_TINT1_TINT34 is set to edge trigger mode (line 160).
> 
> > In this specific case, these interrupt lines are internal to SOC and
> hooked to ARM INTC from PRUSS. PRUSS has another INTC to handle system
> events to PRUSS as well as to generate system events to host ARM. These
> generated events are used for IPC between user application and PRU
> firmware and for async notifications from PRU firmware to user space. I
> don't see a reason to make it shared as we have 8 lines available for use.
> As mentioned before ARM INTC interrupt processing logic converts
> interrupts to active high pulses.
> 
> What's a "pulse triggered interrupt"? I know level and edge triggered
> ones.

Basically it's same as edge triggered.

Thanks,
Pratheesh
