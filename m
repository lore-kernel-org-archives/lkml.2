Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661Ab2HFQAm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 12:00:42 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:36137 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756545Ab2HFQAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 12:00:41 -0400
Date: Mon, 6 Aug 2012 17:00:39 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, arnd@arndb.de, dmitry.torokhov@gmail.com,
        STEricsson_nomadik_linux@list.st.com, sameo@linux.intel.com
Subject: Re: [PATCH 6/6] Input: ab8500-ponkey: Make the distinction between
 DT and non-DT boots
Message-ID: <20120806160039.GE29272@sirena.org.uk>
References: <1344250002-6011-1-git-send-email-lee.jones@linaro.org>
 <1344250002-6011-7-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344250002-6011-7-git-send-email-lee.jones@linaro.org>
X-Cookie: Oatmeal raisin.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06, 2012 at 11:46:42AM +0100, Lee Jones wrote:
> If we're booting with Device Tree enabled, we want the IRQ numbers to
> be taken and translated from the Device Tree binary. If not, they
> should be taken from the resource allocation defined in the AB8500 MFD
> core driver.

>  	ponkey->ab8500 = ab8500;
> -	ponkey->irq_dbf = ab8500_irq_get_virq(ab8500, irq_dbf);
> -	ponkey->irq_dbr = ab8500_irq_get_virq(ab8500, irq_dbr);
> +
> +	ponkey->irq_dbf = (np) ? ab8500_irq_get_virq(ab8500, irq_dbf) : irq_dbf;
> +	ponkey->irq_dbr = (np) ? ab8500_irq_get_virq(ab8500, irq_dbr) : irq_dbr;

Shouldn't the irq domain be coping with this?  It seems like a massive
failure to have to do this in every single user, the irq domain should
be able to encapsulate all this stuff.
