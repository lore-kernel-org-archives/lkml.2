Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497Ab0HPMZw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 08:25:52 -0400
Received: from edu-smtp-01.edutel.nl ([88.159.1.175]:37816 "EHLO
	edu-smtp-01.edutel.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224Ab0HPMZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 08:25:51 -0400
Message-ID: <4C692E4C.4040300@neli.hopto.org>
Date: Mon, 16 Aug 2010 14:25:48 +0200
From: Micha Nelissen <micha@neli.hopto.org>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: Alexandre Bounine <alexandre.bounine@idt.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 6/9] RapidIO: Add switch-specific sysfs initialization
 callback
References: <1281712686-31308-1-git-send-email-alexandre.bounine@idt.com> <1281712686-31308-7-git-send-email-alexandre.bounine@idt.com>
In-Reply-To: <1281712686-31308-7-git-send-email-alexandre.bounine@idt.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexandre Bounine wrote:
> -	if (!rdev->rswitch)
> -		goto out;
> -

Is it safe? All devices have a switch?

> @@ -63,10 +59,11 @@ struct device_attribute rio_dev_attrs[] = {
>  	__ATTR_RO(asm_did),
>  	__ATTR_RO(asm_vid),
>  	__ATTR_RO(asm_rev),
> -	__ATTR_RO(routes),
>  	__ATTR_NULL,
>  };
>  
> +static DEVICE_ATTR(routes, S_IRUGO, routes_show, NULL);
> +

This seems a separate change from the sw_sysfs? Why make it separate?

>   */
>  struct rio_switch {
> @@ -256,6 +257,7 @@ struct rio_switch {
>  			   u8 *sw_domain);
>  	int (*em_init) (struct rio_dev *dev);
>  	int (*em_handle) (struct rio_dev *dev, u8 swport);
> +	int (*sw_sysfs) (struct rio_dev *dev, int create);
>  	struct rio_dev *nextdev[0];
>  };

Why not make a sw_sysfs_create and sw_sysfs_remove? Is better for 
readability. Now you call 'sw_sysfs(dev, 0)' or 'sw_sysfs(dev, 1)';

Micha
