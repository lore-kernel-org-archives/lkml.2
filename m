Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932198Ab2HFPyu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 11:54:50 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:53998 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756396Ab2HFPyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 11:54:49 -0400
Date: Mon, 6 Aug 2012 16:54:46 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, arnd@arndb.de, dmitry.torokhov@gmail.com,
        STEricsson_nomadik_linux@list.st.com, sameo@linux.intel.com
Subject: Re: [PATCH 4/6] mfd: Use interrupt-parent as IRQ controller if
 specified in DT
Message-ID: <20120806155446.GD29272@sirena.org.uk>
References: <1344250002-6011-1-git-send-email-lee.jones@linaro.org>
 <1344250002-6011-5-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344250002-6011-5-git-send-email-lee.jones@linaro.org>
X-Cookie: Oatmeal raisin.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06, 2012 at 11:46:40AM +0100, Lee Jones wrote:

> -				domain = irq_find_host(parent->of_node);
> +#ifdef CONFIG_OF
> +				parent_node = of_irq_find_parent(np);
> +#endif

Shouldn't of_irq_find_parent() be stubbed out by the header?  Every
single user of this is going to need it.  Indeed, shouldn't we be making
irq_find_host() just do this?
