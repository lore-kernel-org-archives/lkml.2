Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757213Ab2BGX0H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 18:26:07 -0500
Received: from xes-mad.com ([216.165.139.218]:4318 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756602Ab2BGX0G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 18:26:06 -0500
Date: Tue, 07 Feb 2012 17:25:52 -0600 (CST)
From: Aaron Sierra <asierra@xes-inc.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: guenter roeck <guenter.roeck@ericsson.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        LKML <linux-kernel@vger.kernel.org>, Peter Tyser <ptyser@xes-inc.com>
Subject: Re: [PATCH 2/3 v2] gpio: Add support for Intel ICHx/3100/Series[56] GPIO
Message-ID: <7e927131-d885-4dfd-8c29-4807ae5766b8@zimbra>
In-Reply-To: <20120207230741.17220c09@endymion.delvare>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.52.0.65]
X-Mailer: Zimbra 7.1.3_GA_3346 (ZimbraWebClient - GC15 (Linux)/7.1.3_GA_3346)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +static int ichx_write_bit(int reg, unsigned nr, int val, int
> > verify)
> > +{
> > +	unsigned long flags;
> > +	u32 data, tmp;
> > +	int reg_nr = nr / 32;
> > +	int bit = nr & 0x1f;
> > +	int ret = 0;
> > +
> > +	spin_lock_irqsave(&ichx_priv.lock, flags);
> > +
> > +	data = ICHX_READ(ichx_regs[reg][reg_nr], ichx_priv.gpio_base);
> > +	data = (data & ~(1 << bit)) | (val << bit);
> 
> I posted a fix for this function last Sunday:
> 
> Subject: [PATCH] gpio-ich: Fix setting GPIO value
> Date: Sun, 5 Feb 2012 21:44:44 +0100
> 
> Please apply it, otherwise your driver doesn't implement the gpio
> driver API properly and code running on top of it (consumer drivers)
> may fail.
> 

Jean,
Thanks for the reminder and for the patch. I have applied it to my tree.

-Aaron

> > +	ICHX_WRITE(data, ichx_regs[reg][reg_nr], ichx_priv.gpio_base);
> > +	tmp = ICHX_READ(ichx_regs[reg][reg_nr], ichx_priv.gpio_base);
> > +	if (verify && (data != tmp))
> > +		ret = -EPERM;
> > +
> > +	spin_unlock_irqrestore(&ichx_priv.lock, flags);
> > +
> > +	return ret;
> > +}
> 
> --
> Jean Delvare
> 
