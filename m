Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934202Ab1JEKCs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 06:02:48 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48986 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932909Ab1JEKCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 06:02:47 -0400
Date: Wed, 5 Oct 2011 11:02:45 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC] drivercore: Add helper macro for platform_driver
 boilerplate
Message-ID: <20111005100244.GA9783@opensource.wolfsonmicro.com>
References: <20111004232403.10364.22050.stgit@ponder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111004232403.10364.22050.stgit@ponder>
X-Cookie: You are magnetic in your bearing.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 04, 2011 at 05:26:55PM -0600, Grant Likely wrote:

> +/* Helper macro for drivers that don't do anything special in module
> + * init/exit.  This eliminates a lot of boilerplate */
> +#define module_platform_driver(__platform_driver) \
> +int __platform_driver##_init(void) \
> +{ \
> +	return platform_driver_register(&(__platform_driver)); \
> +} \
> +module_init(__platform_driver##_init); \

This looks great but I would prefer it if the function complained if
something goes wrong - it makes problems a lot more discoverable when
they crop up.
