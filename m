Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757361Ab0GWS6x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 14:58:53 -0400
Received: from mail.perches.com ([173.55.12.10]:2076 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756290Ab0GWS6u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 14:58:50 -0400
Subject: Re: [PATCH] Staging: dt3155: make local variables static
From: Joe Perches <joe@perches.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, devel@driverdev.osuosl.org,
        ss@aao.gov.au, gregkh@suse.de
In-Reply-To: <201007231145.50239.hartleys@visionengravers.com>
References: <201007231145.50239.hartleys@visionengravers.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Jul 2010 11:58:48 -0700
Message-ID: <1279911528.24768.1689.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-07-23 at 11:45 -0700, H Hartley Sweeten wrote:
> The symbols dt3155_dev_open, unique_tag, and allocatorAddr are only used in
> the file dt3155_drv.c and should be static.
> diff --git a/drivers/staging/dt3155/dt3155_drv.c b/drivers/staging/dt3155/dt3155_drv.c
> index 9e7b880..49924d0 100644
> --- a/drivers/staging/dt3155/dt3155_drv.c
> +++ b/drivers/staging/dt3155/dt3155_drv.c
> @@ -118,14 +118,14 @@ static void __iomem *dt3155_lbase[MAXBOARDS] = { NULL
[]
> -u32  dt3155_dev_open[MAXBOARDS] = {0
> +static u32  dt3155_dev_open[MAXBOARDS] = {0
[]
> -u32 unique_tag = 0;;
> +static u32 unique_tag = 0;;

Statics don't need initialization and could you fix
the style issues ("{0", ";;") at the same time please?

static u32 dt3155_dev_open[MAXBOARDS];
static u32 unique_tag;


