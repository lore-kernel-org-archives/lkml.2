Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862Ab1LXMhS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Dec 2011 07:37:18 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:42109 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230Ab1LXMhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Dec 2011 07:37:15 -0500
Date: Sat, 24 Dec 2011 12:37:13 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
Cc: linaro-dev@lists.linaro.org, patches@linaro.org,
        linux-kernel@vger.kernel.org, eric.miao@linaro.org,
        Nancy Chen <Nancy.Chen@freescale.com>, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCHv2] Regulator: Add Anatop regulator driver
Message-ID: <20111224123713.GB13778@sirena.org.uk>
References: <1323265998-29088-2-git-send-email-paul.liu@linaro.org>
 <1324458211-1612-1-git-send-email-paul.liu@linaro.org>
 <20111222113337.GL4546@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111222113337.GL4546@opensource.wolfsonmicro.com>
X-Cookie: Justice, n.:
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 22, 2011 at 11:33:38AM +0000, Mark Brown wrote:
> On Wed, Dec 21, 2011 at 05:03:31PM +0800, Ying-Chun Liu (PaulLiu) wrote:

> > +	if (anatop_reg->rdata->control_reg) {
> > +		val = anatop_reg->rdata->min_bit_val +
> > +			(uv - reg->constraints->min_uV) / 25000;

> You're not checking that the resulting voltage matches the constraints
> or updating selector.

Also on re-reading this looks *very* broken - you're using the
constraints value in your set_voltage() operation.  The runtime
constraints a system has should have *no* impact on the way you ask for
a specific voltage from the regulator.
