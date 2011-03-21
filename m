Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024Ab1CUMWn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 08:22:43 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37099 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563Ab1CUMWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 08:22:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:organization:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=PcYejwNXCUGoZBMY+VDx1ckJP6tPSjSnIww4yttQwU1B62HtLAIa/5sS+2xNmiWsdJ
         dwGNZlVCAsxhG238cWTbKno3YZcr0+OQz1FdBPoReId9BaO75NUUazTl7JVWz1uWP4u/
         JZk1k8yL9j7XOyU9M39UkYx0z4wY5xHiRxL9E=
From: Florian Fainelli <florian@openwrt.org>
Organization: OpenWrt
To: Dan Carpenter <error27@gmail.com>
Subject: Re: [patch] vlynq: fix resource size calculation
Date: Mon, 21 Mar 2011 13:25:48 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.35-25-server; KDE/4.5.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20110319043813.GA2008@bicker>
In-Reply-To: <20110319043813.GA2008@bicker>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103211325.49061.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 19 March 2011 05:38:13 Dan Carpenter wrote:
> The original code had an off-by-one error so we didn't release the
> entire memory region on remove().
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Acked-by: Florian Fainelli <florian@openwrt.org>

> 
> diff --git a/drivers/vlynq/vlynq.c b/drivers/vlynq/vlynq.c
> index f885c86..1d37553 100644
> --- a/drivers/vlynq/vlynq.c
> +++ b/drivers/vlynq/vlynq.c
> @@ -764,7 +764,7 @@ static int vlynq_remove(struct platform_device *pdev)
> 
>  	device_unregister(&dev->dev);
>  	iounmap(dev->local);
> -	release_mem_region(dev->regs_start, dev->regs_end - dev->regs_start);
> +	release_mem_region(dev->regs_start, dev->regs_end - dev->regs_start + 1);
> 
>  	kfree(dev);

