Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935121Ab1ESWEH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 18:04:07 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:54897 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933084Ab1ESWEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 18:04:06 -0400
Date: Thu, 19 May 2011 23:04:03 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH] mfd wm8350: allocate irq descs dynamically
Message-ID: <20110519220402.GA25452@sirena.org.uk>
References: <20110519185648.GR30963@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110519185648.GR30963@pengutronix.de>
X-Cookie: Do you have lysdexia?
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 08:56:48PM +0200, Sascha Hauer wrote:

> +	if (!pdata->irq_base) {
> +		wm8350->irq_base = irq_alloc_descs(-1, 0, ARRAY_SIZE(wm8350_irqs), 0);
> +		if (wm8350->irq_base < 0) {

One other thing - it doesn't seem to be 100% desirable to making the
allocation of the IRQ descriptors depend on not specifying a base - for
many situations we're likely to want to know what the numbers we end up
with are (eg, for passing to another device) but if we don't call
irq_alloc_decs() the platform still has to arrange for the descriptors
to be there in advance.  It feels like the code should always use
irq_alloc_descs(), though obviously that's not going to work right now.
