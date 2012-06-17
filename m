Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757781Ab2FQR43 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 13:56:29 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:36499 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757703Ab2FQR42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 13:56:28 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 17 Jun 2012 19:56:17 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firewire: core: add is_local sysfs device attribute
Message-ID: <20120617195617.372a35c5@stein>
In-Reply-To: <4FDDEC64.5080004@ladisch.de>
References: <4FDDEC64.5080004@ladisch.de>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 17 Clemens Ladisch wrote:
> Making this information available in sysfs allows to differentiate
> between controllers in the local and remote Linux PCs, and thus is
> useful for servers that are started with udev rules.
> 
> Signed-off-by: Clemens Ladisch <clemens@ladisch.de>

Looks good to me.  Cc'ing LKML, and sending ABI documentation in a reply.

> ---
>  drivers/firewire/core-device.c |    9 +++++++++
>  include/linux/firewire.h       |    2 +-
>  2 files changed, 10 insertions(+), 1 deletions(-)
> 
> --- a/drivers/firewire/core-device.c
> +++ b/drivers/firewire/core-device.c
> @@ -398,6 +398,14 @@ static ssize_t guid_show(struct device *dev,
>  	return ret;
>  }
> 
> +static ssize_t is_local_show(struct device *dev,
> +			     struct device_attribute *attr, char *buf)
> +{
> +	struct fw_device *device = fw_device(dev);
> +
> +	return sprintf(buf, "%u\n", device->is_local);
> +}
> +
>  static int units_sprintf(char *buf, const u32 *directory)
>  {
>  	struct fw_csr_iterator ci;
> @@ -447,6 +455,7 @@ static ssize_t units_show(struct device *dev,
>  static struct device_attribute fw_device_attributes[] = {
>  	__ATTR_RO(config_rom),
>  	__ATTR_RO(guid),
> +	__ATTR_RO(is_local),
>  	__ATTR_RO(units),
>  	__ATTR_NULL,
>  };
> --- a/include/linux/firewire.h
> +++ b/include/linux/firewire.h
> @@ -152,7 +152,7 @@ static inline void fw_card_put(struct fw_card *card)
>  struct fw_attribute_group {
>  	struct attribute_group *groups[2];
>  	struct attribute_group group;
> -	struct attribute *attrs[12];
> +	struct attribute *attrs[13];
>  };
> 
>  enum fw_device_state {



-- 
Stefan Richter
-=====-===-- -==- =---=
http://arcgraph.de/sr/
