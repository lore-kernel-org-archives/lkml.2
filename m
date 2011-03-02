Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756344Ab1CBJ1w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 04:27:52 -0500
Received: from www.tglx.de ([62.245.132.106]:43369 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755989Ab1CBJ1u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 04:27:50 -0500
Date: Wed, 2 Mar 2011 10:27:34 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "TK, Pratheesh Gangadhar" <pratheesh@ti.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hjk@hansjkoch.de" <hjk@hansjkoch.de>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "sshtylyov@mvista.com" <sshtylyov@mvista.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "Chatterjee, Amit" <amit.chatterjee@ti.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH v7 1/1] PRUSS UIO driver support
In-Reply-To: <B85A65D85D7EB246BE421B3FB0FBB593024BF36776@dbde02.ent.ti.com>
Message-ID: <alpine.LFD.2.00.1103021026240.2701@localhost6.localdomain6>
References: <1299014895-2022-1-git-send-email-pratheesh@ti.com> <1299014895-2022-2-git-send-email-pratheesh@ti.com> <alpine.LFD.2.00.1103012238360.2701@localhost6.localdomain6> <B85A65D85D7EB246BE421B3FB0FBB593024BF36776@dbde02.ent.ti.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Mar 2011, TK, Pratheesh Gangadhar wrote:
> > From: Thomas Gleixner [mailto:tglx@linutronix.de]
> > > +	/* Disable interrupt */
> > > +	iowrite32((val & ~intr_mask), intren_reg);
> 
> I checked more on this and actually INTC h/w has Host Interrupt
> Enable Indexed Set Register (HIEISR) and Host Interrupt Enable Indexed
> Clear Register(HIEICR) which I can use to enable/disable interrupts
> without doing RMW. I will use these registers and then we don't need
> all the spinlock and irqcontrol stuff. So I need to do
> 
> iowrite32((intr_bit, HIEICR);// This disable the interrupt bit
> in intern_reg.
> 
> Userspace can use HIEISR to re-enable the interrupt.

Great, that makes it way simpler!
 
> > It's not the purpose of a review to tell you what you need to change
> > mechanically. Reviewers hint to a correct solution and you are
> > supposed to lookup what that solution means and act accordingly. If
> > you do not understand the hint or its implications please ask _before_
> > sending a new patch set.
> 
> Seriously, I went to "fix the comments" mode. Sorry about that. Anyway
> I learnt more about things by making mistakes i.e. the positive side.
> Thanks a lot for helping us improve on this. 

Welcome!


	tglx
