Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966Ab1BNT7f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 14:59:35 -0500
Received: from www.tglx.de ([62.245.132.106]:49509 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751022Ab1BNT7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 14:59:32 -0500
Date: Mon, 14 Feb 2011 20:58:47 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Gregory Bean <gbean@codeaurora.org>
cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jean Delvare <khali@linux-fr.org>,
        Lennert Buytenhek <buytenh@secretlab.ca>, rvaswani@codeaurora.org
Subject: Re: [patch] drivers: gpio: sx150x: Do not access I2C from mask/unmask
 functions
In-Reply-To: <20110214194546.GA10940@gbean-linux.qualcomm.com>
Message-ID: <alpine.LFD.2.00.1102142058330.26192@localhost6.localdomain6>
References: <20110214164634.510293676@linutronix.de> <20110214194546.GA10940@gbean-linux.qualcomm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Feb 2011, Gregory Bean wrote:

> >  static int sx150x_irq_set_type(struct irq_data *d, unsigned int flow_type)
> > @@ -350,7 +353,7 @@ static int sx150x_irq_set_type(struct ir
> >  
> >  	chip->irq_sense &= ~(3UL << (n * 2));
> >  	chip->irq_sense |= val << (n * 2);
> > -	chip->irq_set_type_pending |= BIT(n);
> > +	chip->update = n;
> 
> Should this be irq_update?

See reply to myself
