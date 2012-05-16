Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757897Ab2EPL5Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 07:57:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4296 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068Ab2EPL5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 07:57:14 -0400
X-Authority-Analysis: v=2.0 cv=OMylLFmB c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=jKu8JnxlA44A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=gjdCREqasA1MwOVGck8A:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1337169432.6724.30.camel@gandalf.stny.rr.com>
Subject: Re: [WARNING] at kernel/irq/manage.c:421 __enable_irq
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, David Miller <davem@davemloft.net>
Date: Wed, 16 May 2012 07:57:12 -0400
In-Reply-To: <alpine.LFD.2.02.1205161001500.3231@ionos>
References: <1337131823.6724.11.camel@gandalf.stny.rr.com>
	 <alpine.LFD.2.02.1205161001500.3231@ionos>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-16 at 13:27 +0200, Thomas Gleixner wrote:
> On Tue, 15 May 2012, Steven Rostedt wrote:
> > The code in ide_probe_port() does the following:
> 
> Right, you just forgot to show the most interesting gem of that code:
> 
> 	/*
> 	 * We must always disable IRQ, as probe_for_drive will assert IRQ, but
> 	 * we'll install our IRQ driver much later...
> 	 */

Heh, I would have kept that, but I was more interested in cut and
pasting code than comments. I'll make sure to keep comments in emails
too.


> >         if (irqd)
> >                 enable_irq(irqd);
> 
> So this code is wrong and unsafe in various aspects. I wonder why it
> didn't blow up before. Maybe init ordering changed ....
> 

Or it always did. This is on my main box that I reboot once every 100
days or so. I'm not usually present when the machine comes online, nor
do I search dmesg for warnings. Although, yesterday I did. This could
have been complaining from day one.


> I have an idea how to fix that proper. Will send out patches later.

I'll test them, but it's a bit of a pain, as it would require me
shutting down evolution, xchat, firefox, chrome and all my emacs
windows :-)  This is why I don't reboot this box often.

-- Steve


