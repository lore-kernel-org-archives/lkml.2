Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515Ab1JHSX2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 14:23:28 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:53227 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753431Ab1JHSX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 14:23:28 -0400
Message-ID: <1318098206.1844.3.camel@Joe-Laptop>
Subject: Re: Subject: [PATCH]
From: Joe Perches <joe@perches.com>
To: Jake Burton <jake5991@live.com>
Cc: gregkh@suse.de, abbotti@mev.co.uk, fmhess@users.sourceforge.net,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Sat, 08 Oct 2011 11:23:26 -0700
In-Reply-To: <BLU0-SMTP400327EB20018169910A6BAA2FF0@phx.gbl>
References: <BLU0-SMTP400327EB20018169910A6BAA2FF0@phx.gbl>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-10-08 at 19:01 +0100, Jake Burton wrote:
> diff --git a/drivers/staging/comedi/drivers/ni_atmio.c b/drivers/staging/comedi/drivers/ni_atmio.c
[]
> @@ -279,7 +279,7 @@ static const int ni_irqpin[] =
>  
>  struct ni_private {
>  	struct pnp_dev *isapnp_dev;
> - NI_PRIVATE_COMMON};
> +NI_PRIVATE_COMMON};

Hard to believe this is better.  Maybe:

struct ni_private {
	struct pnp_dev *isapnp_dev;
	NI_PRIVATE_COMMON
};

It'd be better to inline NI_PRIVATE_COMMON,
whatever that is.  There are 3 uses of that
really ugly #define.


