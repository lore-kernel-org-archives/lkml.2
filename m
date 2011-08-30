Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427Ab1H3LKN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 07:10:13 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:58816 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193Ab1H3LKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 07:10:12 -0400
Date: Tue, 30 Aug 2011 14:07:49 +0300
From: Dan Carpenter <error27@gmail.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 18/46] Staging: hv: storvsc: Add code to handle IDE
 devices using the storvsc driver
Message-ID: <20110830110749.GE3705@shale.localdomain>
References: <1314469874-7017-1-git-send-email-kys@microsoft.com>
 <1314469905-7058-1-git-send-email-kys@microsoft.com>
 <1314469905-7058-18-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314469905-7058-18-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 27, 2011 at 11:31:17AM -0700, K. Y. Srinivasan wrote:
> @@ -59,6 +59,17 @@ struct storvsc_cmd_request {
>  	struct hv_storvsc_request request;
>  };
>  
> +static void storvsc_get_ide_info(struct hv_device *dev, int *target, int *path)
> +{
> +	*target =
> +		dev->dev_instance.b[5] << 8 | dev->dev_instance.b[4];
> +
> +	*path =
> +		dev->dev_instance.b[3] << 24 |
> +		dev->dev_instance.b[2] << 16 |
> +		dev->dev_instance.b[1] << 8  | dev->dev_instance.b[0];
> +}
> +

Does endianness matter here?  It seems like *path isn't actually used
anywhere.  Probably target and path should be u32 types?

regards,
dan carpenter

