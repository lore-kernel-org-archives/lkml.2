Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757342Ab1ERQcG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 12:32:06 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46279 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755868Ab1ERQcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 12:32:04 -0400
Date: Wed, 18 May 2011 09:32:06 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [RFC][PATCH] regulator: Fix _regulator_get_voltage if
 get_voltage callback is NULL
Message-ID: <20110518163205.GC16414@opensource.wolfsonmicro.com>
References: <1305723718.6172.6.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305723718.6172.6.camel@phoenix>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 09:01:58PM +0800, Axel Lin wrote:

> @@ -1886,13 +1886,15 @@ static int _regulator_get_voltage(struct regulator_dev *rdev)
>  		if (sel < 0)
>  			return sel;
>  		ret = rdev->desc->ops->list_voltage(rdev, sel);
> +		goto out;
>  	}

Why are you adding this goto?  It's not going to change anything...
