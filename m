Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942Ab1GNXsO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 19:48:14 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47897 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754567Ab1GNXsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 19:48:13 -0400
Date: Fri, 15 Jul 2011 08:48:07 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: Fix memory leak in set_machine_constraints()
 error paths
Message-ID: <20110714234805.GA32716@opensource.wolfsonmicro.com>
References: <1310650159.6854.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310650159.6854.1.camel@phoenix>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 14, 2011 at 09:29:19PM +0800, Axel Lin wrote:
>  static int set_machine_constraints(struct regulator_dev *rdev,
>  	const struct regulation_constraints *constraints)
>  {
> -	int ret = 0;
> +	int ret;
>  	struct regulator_ops *ops = rdev->desc->ops;
>  

This doesn't look like a leak fix?  There's nothing that checks for
other errors here (like null pointers)?
