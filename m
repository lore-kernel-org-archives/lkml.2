Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497Ab0KENTh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 09:19:37 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38509 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754466Ab0KENTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 09:19:35 -0400
Date: Fri, 5 Nov 2010 09:19:42 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [PATCH 2/3] regulator: Ensure enough delay time for enabling
 regulator
Message-ID: <20101105131941.GD13709@opensource.wolfsonmicro.com>
References: <1288941912.16201.1.camel@mola>
 <1288941980.16201.2.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288941980.16201.2.camel@mola>
X-Cookie: Beware of Bigfoot!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 05, 2010 at 03:26:20PM +0800, Axel Lin wrote:

> -			if (delay >= 1000)
> +			if (delay >= 1000) {
>  				mdelay(delay / 1000);
> -			else if (delay)
> +				udelay(delay % 1000);
> +			} else if (delay)
>  				udelay(delay);

This looks good but please change this to use { } in the else case also;
I find this very helpful for legibility.
