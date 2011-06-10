Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772Ab1FJR1n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 13:27:43 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:36579 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107Ab1FJR1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 13:27:39 -0400
Date: Fri, 10 Jun 2011 18:27:35 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Liam Girdwood <lrg@ti.com>, uclinux-dist-devel@blackfin.uclinux.org,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        device-drivers-devel@blackfin.uclinux.org
Subject: Re: [alsa-devel] [PATCH 1/3] ASoC: Add ADAU1701 codec driver
Message-ID: <20110610172734.GI26441@sirena.org.uk>
References: <1307726331-28618-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307726331-28618-1-git-send-email-lars@metafoo.de>
X-Cookie: I had pancake makeup for brunch!
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 10, 2011 at 07:18:49PM +0200, Lars-Peter Clausen wrote:
> This patch adds support for the Analog Devices ADAU1701 SigmaDSP.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>

Looks OK but one thing it'd be nice to do:

> +static unsigned int adau1701_register_size(unsigned int reg)
> +{
> +	switch (reg) {
> +	case ADAU1701_DSPCTRL:
> +	case ADAU1701_SEROCTL:
> +	case ADAU1701_AUXNPOW:
> +	case ADAU1701_OSCIPOW:
> +	case ADAU1701_DACSET:
> +		return 2;
> +	case ADAU1701_SERICTL:
> +		return 1;
> +	}
> +
> +	return 0;
> +}

I'd be happier if this complained loudly when it fell through the
switch in case something goes wrong.  You've got checks in the callers
but I'd feel safer if the log were here in case we missed a caller.

Also someone should remonstrate with the hardware designers.
