Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932335Ab0FKIlK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 04:41:10 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:62909 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759251Ab0FKIlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 04:41:08 -0400
X-Greylist: delayed 1574 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Jun 2010 04:41:07 EDT
Message-ID: <19473.61547.684572.647641@ipc1.ka-ro>
Date: Fri, 11 Jun 2010 10:14:35 +0200
From: =?iso-8859-15?Q?Lothar_Wa=DFmann?= <LW@KARO-electronics.de>
To: Jeremy Kerr <jeremy.kerr@canonical.com>
Cc: Ben Dooks <ben-linux@fluff.org>,
       Ben Herrenchmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Subject: Re: [RFC,PATCH 1/2] Add a common struct clk
In-Reply-To: <201006111557.12249.jeremy.kerr@canonical.com>
References: <1275636608.606606.450179637764.0.gpush@pororo>
	<1275636608.607067.417709988883.1.gpush@pororo>
	<20100611042046.GA31045@fluff.org.uk>
	<201006111557.12249.jeremy.kerr@canonical.com>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> > > +static inline int clk_enable(struct clk *clk)
> > > +{
> > > +	int ret = 0;
> > > +
> > > +	if (!clk->ops->enable)
> > > +		return 0;
> > > +
> > > +	mutex_lock(&clk->mutex);
> > > +	if (!clk->enable_count)
> > > +		ret = clk->ops->enable(clk);
> > > +
> > > +	if (!ret)
> > > +		clk->enable_count++;
> > > +	mutex_unlock(&clk->mutex);
> > > +
> > > +	return ret;
> > > +}
> > 
Using a mutex in clk_enable()/clk_disable() is a bad idea, since that
makes it impossible to call those functions in interrupt context.


Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
