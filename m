Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369Ab0LaTT4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 14:19:56 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47232
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754074Ab0LaTTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 14:19:54 -0500
Date: Fri, 31 Dec 2010 11:20:25 -0800 (PST)
Message-Id: <20101231.112025.245393392.davem@davemloft.net>
To: jj@chaosbits.net
Cc: joe@perches.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        zongxi@broadcom.com, mchan@broadcom.com
Subject: Re: [PATCH v2] Broadcom CNIC core network driver: fix mem leak on
 allocation failures in cnic_alloc_uio_rings() 
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LNX.2.00.1012262154420.20797@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1012262124320.20797@swampdragon.chaosbits.net>
	<1293396850.7726.14.camel@Joe-Laptop>
	<alpine.LNX.2.00.1012262154420.20797@swampdragon.chaosbits.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Juhl <jj@chaosbits.net>
Date: Sun, 26 Dec 2010 21:57:39 +0100 (CET)

> We are leaking memory in drivers/net/cnic.c::cnic_alloc_uio_rings() if 
> either of the calls to dma_alloc_coherent() fail. This patch fixes it by 
> freeing both the memory allocated with kzalloc() and memory allocated with 
> previous calls to dma_alloc_coherent() when there's a failure.
> 
> Thanks to  Joe Perches <joe@perches.com>  for suggesting a better 
> implementation than my initial version.
> 
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

 ...
> + err_dma:
> +	dma_free_coherent(&udev->pdev->dev, udev->l2_ring_size,
> +       			  udev->l2_ring, udev->l2_ring_map);

Space before tab in indentation, improperly positioned third argument
indentation.

I fixed all of this up, but please do not skimp on making sure these
details are taken care of when updating your patch in response to feedback.

Thanks.
