Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819Ab1GEQ2s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 12:28:48 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:39667 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755765Ab1GEQ2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 12:28:46 -0400
Date: Tue, 5 Jul 2011 17:28:43 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: ashishj3 <ashish.jangam@kpitcummins.com>
Cc: linaro-dev@lists.linaro.org, lrg@slimlogic.co.uk,
        linux-kernel@vger.kernel.org, Dajun <dajun.chen@diasemi.com>
Subject: Re: [Patch 5/11] Regulator: DA9052 regulator support v2
Message-ID: <20110705162843.GA13707@sirena.org.uk>
References: <1309353363.4448.10.camel@L-0532.kpit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309353363.4448.10.camel@L-0532.kpit.com>
X-Cookie: No shirt, no shoes, no service.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 29, 2011 at 06:46:03PM +0530, ashishj3 wrote:

> +static int verify_range(struct da9052_regulator_info *info,
> +			 int min_uV, int max_uV)
> +{
> +	if (min_uV < info->min_uV || min_uV > info->max_uV)
> +		return -EINVAL;
> +	if (max_uV < info->min_uV || max_uV > info->max_uV)
> +		return -EINVAL;

This is broken, think about what it's trying to do - it's trying to
check that the regulator can deliver a voltage within the requested
range.  These checks don't help with that.
