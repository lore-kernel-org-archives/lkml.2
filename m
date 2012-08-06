Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756818Ab2HFRWL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 13:22:11 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:46633 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756754Ab2HFRWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 13:22:10 -0400
Date: Mon, 6 Aug 2012 18:22:05 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, arnd@arndb.de, dmitry.torokhov@gmail.com,
        STEricsson_nomadik_linux@list.st.com, sameo@linux.intel.com
Subject: Re: [PATCH 6/6] Input: ab8500-ponkey: Make the distinction between
 DT and non-DT boots
Message-ID: <20120806172204.GB31409@gmail.com>
References: <1344250002-6011-1-git-send-email-lee.jones@linaro.org>
 <1344250002-6011-7-git-send-email-lee.jones@linaro.org>
 <20120806160039.GE29272@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120806160039.GE29272@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06, 2012 at 05:00:39PM +0100, Mark Brown wrote:
> On Mon, Aug 06, 2012 at 11:46:42AM +0100, Lee Jones wrote:
> > If we're booting with Device Tree enabled, we want the IRQ numbers to
> > be taken and translated from the Device Tree binary. If not, they
> > should be taken from the resource allocation defined in the AB8500 MFD
> > core driver.
> 
> >  	ponkey->ab8500 = ab8500;
> > -	ponkey->irq_dbf = ab8500_irq_get_virq(ab8500, irq_dbf);
> > -	ponkey->irq_dbr = ab8500_irq_get_virq(ab8500, irq_dbr);
> > +
> > +	ponkey->irq_dbf = (np) ? ab8500_irq_get_virq(ab8500, irq_dbf) : irq_dbf;
> > +	ponkey->irq_dbr = (np) ? ab8500_irq_get_virq(ab8500, irq_dbr) : irq_dbr;
> 
> Shouldn't the irq domain be coping with this?  It seems like a massive
> failure to have to do this in every single user, the irq domain should
> be able to encapsulate all this stuff.

Already in hand.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
