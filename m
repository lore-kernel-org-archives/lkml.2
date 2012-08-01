Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263Ab2HATDf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 15:03:35 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33059 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754421Ab2HATDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 15:03:34 -0400
Date: Wed, 1 Aug 2012 20:03:30 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] regmap: initialize all irqs to wake disabled
Message-ID: <20120801190329.GB4483@opensource.wolfsonmicro.com>
References: <1343842784-15912-1-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343842784-15912-1-git-send-email-swarren@wwwdotorg.org>
X-Cookie: Don't feed the bats tonight.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2012 at 11:39:44AM -0600, Stephen Warren wrote:

> and sets bits to disable wake. Hence, we should set all bits in
> wake_buf initially, to mirror the expected disabled state.

This fortunately isn't an issue for the only current user as masked is
the default in the silicon.

> +			ret = regmap_write(map, reg, d->wake_buf[i]);
> +			if (ret != 0) {
> +				dev_err(map->dev, "Failed to set masks in 0x%x: %d\n",
> +					reg, ret);

This should really be update_bits().  Which is a mistake we're making
in the current code for the masks and should correct there (I'll send a
patch shortly) but we may as well get it right here.
