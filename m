Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713Ab1DZQvz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 12:51:55 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54413 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578Ab1DZQvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 12:51:54 -0400
Date: Tue, 26 Apr 2011 12:51:50 -0400
From: Christoph Hellwig <hch@infradead.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: Re: [PATCH 20/25] Staging: hv: Use the probe function in struct
 hv_driver
Message-ID: <20110426165150.GA21187@infradead.org>
References: <1303834785-4981-1-git-send-email-kys@microsoft.com>
 <1303834842-5022-1-git-send-email-kys@microsoft.com>
 <1303834842-5022-20-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303834842-5022-20-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -882,7 +882,7 @@ static int blkvsc_drv_init(void)
>  
>  	drv->driver.name = storvsc_drv_obj->base.name;
>  
> -	drv->driver.probe = blkvsc_probe;
> +	drv->probe = blkvsc_probe;
>  	drv->driver.remove = blkvsc_remove;
>  	drv->driver.shutdown = blkvsc_shutdown;

Not new in this patch, but you should really declare the driver as a
static object and initialize it at compile time, similar to how it's 
done for PCI and countless other busses, e.g.

struct hv_driver blkvsc_driver {
	.name		= "blkvsc",
	.probe		= blkvsc_probe,
	.remove		= blkvsc_remove,
	.shutdown	= blkvsc_shutdown,
};

