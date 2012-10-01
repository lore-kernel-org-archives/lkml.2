Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751252Ab2JARUr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 13:20:47 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:33010 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856Ab2JARUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 13:20:46 -0400
Date: Mon, 1 Oct 2012 18:20:45 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Andrey Smirnov <andrey.smirnov@convergeddevices.net>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Add a core driver for SI476x MFD
Message-ID: <20121001172044.GA25335@sirena.org.uk>
References: <1347576013-28832-1-git-send-email-andrey.smirnov@convergeddevices.net>
 <1347576013-28832-2-git-send-email-andrey.smirnov@convergeddevices.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347576013-28832-2-git-send-email-andrey.smirnov@convergeddevices.net>
X-Cookie: Androphobia:
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 03:40:11PM -0700, Andrey Smirnov wrote:

> +	core = kzalloc(sizeof(*core), GFP_KERNEL);

devm_kzalloc()

> +	if (!core) {
> +		pr_err("si476x-core: failed to allocate " \
> +		       "'struct si476x_core'\n");
> +		return -ENOMEM;
> +	}

Splitting error messages over multiple lines like this just makes things
hard to grep for.

> +	core->supplies.vio1 = regulator_get(&client->dev, "vio1");
> +	if (IS_ERR_OR_NULL(core->supplies.vio1)) {
> +		dev_info(&client->dev, "No vio1 regulator found\n");
> +		core->supplies.vio1 = NULL;
> +	}

This and all the usages of the regulator API in the driver are broken,
the driver should treat failures to get the supplies as errors.  There
are more than enough ways to stub things out in the core.
