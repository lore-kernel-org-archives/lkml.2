Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758295Ab1BRQbO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 11:31:14 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:51657 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756973Ab1BRQbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 11:31:13 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/2] PRUSS UIO driver support
Date: Fri, 18 Feb 2011 17:31:05 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org,
        Pratheesh Gangadhar <pratheesh@ti.com>,
        davinci-linux-open-source@linux.davincidsp.com, gregkh@suse.de,
        amit.chatterjee@ti.com, "Hans J. Koch" <hjk@hansjkoch.de>,
        LKML <linux-kernel@vger.kernel.org>
References: <1298041530-26855-1-git-send-email-pratheesh@ti.com> <201102181644.17634.arnd@arndb.de> <alpine.LFD.2.00.1102181713480.2701@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1102181713480.2701@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102181731.05644.arnd@arndb.de>
X-Provags-ID: V02:K0:+uGt5GCyazRU0rxDT4v24vG0VME3FTvUL+f8C0VFV4S
 oYlmVvc34iHoFKxBqySk6RUnIWHo0y14J0A7SRbLxczhVdR5GG
 CkPExb3qVkTOmyAjL+kpBxGdNurj9Em8UAoCa2EWcypnxXubkL
 gtlzXfNF/BpXyirWnPm8uHgXMWhChpFgSTVklyBRoBNGJJ6Isw
 coHgnNmZtyponJSUqz66Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 February 2011, Thomas Gleixner wrote:
> On Fri, 18 Feb 2011, Arnd Bergmann wrote:
> > On Friday 18 February 2011, Pratheesh Gangadhar wrote:
> > > Signed-off-by: Pratheesh Gangadhar <pratheesh@ti.com>
> > > +static irqreturn_t pruss_handler(int irq, struct uio_info *dev_info)
> > > +{
> > > +   return IRQ_HANDLED;
> > > +}
> > 
> > An empty interrupt handler is rather pointless. I guess you really
> > notify user space when the interrupt handler gets called, as this
> > is the main point of a UIO driver as far as I understand it.
> 
> The UIO core code does this for you when the driver handler returns
> IRQ_HANDLED

Ah, right.

> but the empty handler raises a different questions:
> 
> Is the interrupt edge triggerd or how do you avoid an irq storm here?
> Usually UIO drivers are requested to mask the interrupt in the device
> itself.

If it's edge triggered, it should not advertise IRQF_SHARED, right?

	Arnd
