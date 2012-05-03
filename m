Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342Ab2ECNUI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 09:20:08 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:36740 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546Ab2ECNUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 09:20:07 -0400
Date: Thu, 3 May 2012 14:20:05 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Misael Lopez Cruz <misael.lopez@ti.com>,
        Benoit Cousson <b-cousson@ti.com>, devicetree-discuss@lists.ozlabs.org,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH 2/3] MFD: twl6040: Allocate IRQ numbers dynamically
Message-ID: <20120503132004.GB14296@sirena.org.uk>
References: <1336049665-27777-1-git-send-email-peter.ujfalusi@ti.com>
 <1336049665-27777-3-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336049665-27777-3-git-send-email-peter.ujfalusi@ti.com>
X-Cookie: You must be present to win.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2012 at 03:54:24PM +0300, Peter Ujfalusi wrote:

>  	/* In order to operate correctly we need valid interrupt config */
> -	if (!client->irq || !pdata->irq_base) {
> +	if (!client->irq) {

It looks like you're totally removing the use of irq_base which will
break any boards that didn't convert to DT.  The usual idiom is to use
irq_base as the base for the range of requested IRQs if it's supplied,
otherwise set it to -1 to allow dynamic allocation.  This should keep
existing users working without disruption.
