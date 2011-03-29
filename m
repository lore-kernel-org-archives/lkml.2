Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752321Ab1C2WkX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 18:40:23 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:51114 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197Ab1C2WkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 18:40:22 -0400
Date: Tue, 29 Mar 2011 23:40:18 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: David Collins <collinsd@codeaurora.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm-owner@vger.kernel.org
Subject: Re: [PATCH v2 2/2] regulator: Propagate uA_load requirements up
	supply chain
Message-ID: <20110329224017.GB15535@sirena.org.uk>
References: <1301356355-7546-1-git-send-email-collinsd@codeaurora.org> <1301356432-7586-2-git-send-email-collinsd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301356432-7586-2-git-send-email-collinsd@codeaurora.org>
X-Cookie: Is there life before breakfast?
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 28, 2011 at 04:53:52PM -0700, David Collins wrote:

Some more specific comments on the code:

> +	if (rdev->desc->ops->get_current_required) {
> +		err = rdev->desc->ops->get_current_required(rdev, input_uV,
> +							output_uV, current_uA);
> +		if (err < 0)
> +			return;
> +		rdev->uA_load = err;
> +	}

I think we need something to handle misssing data here if there is a
supply connected, otherwise we'll end up failing silently.  Off the top
of my head we could either just complain loudly if there's no operation
and there should be one or make a pessimistic assumption about
efficiency by default.

> +	/* get supply current required for load */
> +	int (*get_current_required) (struct regulator_dev *, int input_uV,
> +				     int output_uV, int load_uA);
> +

I like the interface for the driver but possibly call it something like
get_supply_current() or something to make it a little clearer which
current is being requested?  Also needs to have kerneldoc added for the
new function - ideally the documentation would say this is for sustained
rather than peak load.
