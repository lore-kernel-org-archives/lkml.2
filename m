Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752395Ab1GPCEv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 22:04:51 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:40016
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751578Ab1GPCEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 22:04:50 -0400
Date: Fri, 15 Jul 2011 22:04:47 -0400
From: Christoph Hellwig <hch@infradead.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 097/117] Staging: hv: storvsc: Add code to handle IDE
 devices using the storvsc driver
Message-ID: <20110716020447.GB7199@infradead.org>
References: <1310752024-27854-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-97-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310752065-27895-97-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, this looks much cleaner than the initial variant.

> +	if (dev_is_ide) {
> +		storvsc_get_ide_info(device, &target, &path);
> +		host_dev->path = device_info.path_id;
> +		host_dev->target = device_info.target_id;
> +	} else {
> +		host_dev->path = device_info.path_id;
> +		host_dev->target = device_info.target_id;
> +	}

Is using the device_info values in both branches intentional?  If so
there's no need to have these assignments duplicated.

> +	if (dev_is_ide) {
> +		ret = scsi_add_device(host, 0, target, 0);
> +		if (ret) {
> +			scsi_remove_host(host);
> +			goto err_out;
> +		}

I'd add another goto error label for this piece of error handling.

