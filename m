Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615Ab3AJIxq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 03:53:46 -0500
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:16324 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753683Ab3AJIxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 03:53:43 -0500
X-IronPort-AV: E=Sophos;i="4.84,443,1355094000"; 
   d="scan'208";a="189220321"
Date: Thu, 10 Jan 2013 09:53:17 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Lars-Peter Clausen <lars@metafoo.de>
cc: Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Jonathan Cameron <jic23@cam.ac.uk>, linux-iio@vger.kernel.org
Subject: Re: [PATCH 1/3] spi: Add helper functions for setting up transfers
In-Reply-To: <1357752671-30222-1-git-send-email-lars@metafoo.de>
Message-ID: <alpine.DEB.2.02.1301100951060.2063@localhost6.localdomain6>
References: <1357752671-30222-1-git-send-email-lars@metafoo.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +@r1@
> +identifier fn;
> +identifier xfers;
> +@@
> +fn(...)
> +{
> +	...
> +(
> +	struct spi_transfer xfers[...];
> +|
> +	struct spi_transfer xfers[];
> +)
> +	...
> +}

Can it happen that there would be more than one spi_transfer or spi_message
variable per function?  This semantic patch will only treat the case where
there is only one, because the ... before an after the variable declaration
won't match another declaration of the same form.

julia
