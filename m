Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932771Ab2JLG00 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 02:26:26 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48794 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753024Ab2JLG0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 02:26:25 -0400
Date: Fri, 12 Oct 2012 15:26:09 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: ciminaghi@gnudd.com
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regmap : make lock/unlock functions customizable.
Message-ID: <20121012062607.GN11726@opensource.wolfsonmicro.com>
References: <1349127064-432-1-git-send-email-ciminaghi@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349127064-432-1-git-send-email-ciminaghi@gnudd.com>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2012 at 11:31:04PM +0200, ciminaghi@gnudd.com wrote:
> From: Davide Ciminaghi <ciminaghi@gnudd.com>
> 
> It is sometimes convenient for a regmap user to override the standard
> regmap lock/unlock functions with custom functions.

This looks good overall but...

> -static void regmap_lock_mutex(struct regmap *map)
> +static void regmap_lock_mutex(void *__map)
>  {
> +	struct regmap *map = (struct regmap *)__map;
>  	mutex_lock(&map->mutex);

...you should never need to cast away from or to void, if you do there's
a bug somewhere.
