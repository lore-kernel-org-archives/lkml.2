Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756398Ab2ASLjU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 06:39:20 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49455 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753105Ab2ASLjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 06:39:19 -0500
Date: Thu, 19 Jan 2012 11:39:16 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: regmap: no indexed caching?
Message-ID: <20120119113916.GE3178@opensource.wolfsonmicro.com>
References: <20120119113708.GC2630@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120119113708.GC2630@pengutronix.de>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 19, 2012 at 12:37:08PM +0100, Wolfram Sang wrote:

> What about devices having just a few registers (4 in my case)? I'd think
> there are a number of such devices not yet converted to regmap. Is it
> assumed that the additional overhead from rbtree-caching will make up
> for the code saved?

There should be vanishingly little overhead from the rbtree, you'll just
end up with a single cache node containing all the registers (unless
they're widely separated numerically) - it may even be faster as we
don't need to search the array looking for the index.
