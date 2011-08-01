Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751797Ab1HALM7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 07:12:59 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:62764 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213Ab1HALMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 07:12:54 -0400
Date: Mon, 1 Aug 2011 14:10:50 +0300
From: Dan Carpenter <error27@gmail.com>
To: Manohar Vanga <manohar.vanga@cern.ch>
Cc: gregkh@suse.de, martyn.welch@ge.com, devel@driverdev.osuosl.org,
        cota@braap.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/8] staging: vme: make [alloc|free]_consistent bridge
 specific
Message-ID: <20110801111050.GG5575@shale.localdomain>
References: <1312194053-32310-1-git-send-email-manohar.vanga@cern.ch>
 <1312194053-32310-4-git-send-email-manohar.vanga@cern.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312194053-32310-4-git-send-email-manohar.vanga@cern.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 01, 2011 at 12:20:48PM +0200, Manohar Vanga wrote:
>  	if (bridge->parent == NULL) {
>  		printk(KERN_ERR "Dev entry NULL\n");

The user wouldn't know which driver is printing the error.

>  		return NULL;
>  	}
> -	pdev = container_of(bridge->parent, struct pci_dev, dev);
>  
> -	return pci_alloc_consistent(pdev, size, dma);
> +	if (bridge->alloc_consistent == NULL) {
> +		printk(KERN_ERR "alloc_consistent not supported by bridge\n");

Could probably be improved as well.

> +		return NULL;
> +	}
> +

regards,
dan carpenter
