Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756640Ab2FNTGX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 15:06:23 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:42658 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756084Ab2FNTGV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 15:06:21 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: Deprecate suspend/resume in device_driver
Date: Thu, 14 Jun 2012 21:11:39 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0+; KDE/4.6.0; x86_64; ; )
Cc: Ning Jiang <ning.n.jiang@gmail.com>, linux-kernel@vger.kernel.org,
        Linux PM mailing list <linux-pm@vger.kernel.org>
References: <CAH3Oq6Sua5vmOioOQHZd6BYRvVGfeTrNCgCHpyhZAv2_HhhcZg@mail.gmail.com>
In-Reply-To: <CAH3Oq6Sua5vmOioOQHZd6BYRvVGfeTrNCgCHpyhZAv2_HhhcZg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201206142111.39618.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 13, 2012, Ning Jiang wrote:
> The suspend/resume will not be called if they are defined in
> device_driver directly,
> PM core will only use suspend/resume function in dev_pm_ops. Thus we shall
> mark the old suspend/resume deprecated and make them scheduled for removal.
> 
> 
> From efee1b349a8abcb4702d93c1c12e7f27c96fbcfc Mon Sep 17 00:00:00 2001
> From: Ning Jiang <ning.n.jiang@gmail.com>
> Date: Wed, 13 Jun 2012 15:00:33 +0800
> Subject: [PATCH] PM: Deprecate suspend/resume in device_driver
> 
> Make suspend/resume callbacks in device_driver deprecated and scheduled
> for removal since they are not used in PM core anymore.
> 
> Legacy drivers who still use them need to move suspend/resume callbacks
> to dev_pm_ops.
> 
> Signed-off-by: Ning Jiang <ning.n.jiang@gmail.com>

Greg, do you have any objections here?

Rafael


> ---
>  include/linux/device.h |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/device.h b/include/linux/device.h
> index e04f577..884d9a6 100644
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -226,8 +226,8 @@ struct device_driver {
>  	int (*probe) (struct device *dev);
>  	int (*remove) (struct device *dev);
>  	void (*shutdown) (struct device *dev);
> -	int (*suspend) (struct device *dev, pm_message_t state);
> -	int (*resume) (struct device *dev);
> +	int (*suspend) (struct device *dev, pm_message_t state) __deprecated;
> +	int (*resume) (struct device *dev) __deprecated;
>  	const struct attribute_group **groups;
> 
>  	const struct dev_pm_ops *pm;
> 

