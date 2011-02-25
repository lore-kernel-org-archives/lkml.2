Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932449Ab1BYPrR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 10:47:17 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:38526 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932367Ab1BYPrO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 10:47:14 -0500
MIME-Version: 1.0
In-Reply-To: <20110223025233.25131.47193.stgit@localhost6.localdomain6>
References: <20110223025233.25131.47193.stgit@localhost6.localdomain6>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 25 Feb 2011 08:46:52 -0700
X-Google-Sender-Auth: xgw-r4ATb9gDDu9qdPRN7vN7REA
Message-ID: <AANLkTikauP8+PgFyicdSQzJ19ZvqpV=3ZnRTjSvY78qc@mail.gmail.com>
Subject: Re: [PATCH] dt: add a match table pointer to struct device
To: devicetree-discuss@lists.ozlabs.org, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg, any thoughts on this change?  I'd like to take it via my tree so
I can finally dump the last vestiges of of_platform_bus_type.

Thanks,
g.

On Tue, Feb 22, 2011 at 7:52 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> Add a new .of_match field to struct device which points at the
> matching device driver .of_match_table entry when a device is probed
> via the device tree
>
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> ---
>  include/linux/device.h    |    1 +
>  include/linux/of_device.h |    5 +++--
>  2 files changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/device.h b/include/linux/device.h
> index ca5d252..8d8e267 100644
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -441,6 +441,7 @@ struct device {
>        struct dev_archdata     archdata;
>
>        struct device_node      *of_node; /* associated device tree node */
> +       const struct of_device_id *of_match; /* matching of_device_id from driver */
>
>        dev_t                   devt;   /* dev_t, creates the sysfs "dev" */
>
> diff --git a/include/linux/of_device.h b/include/linux/of_device.h
> index 975d347..8bfe6c1 100644
> --- a/include/linux/of_device.h
> +++ b/include/linux/of_device.h
> @@ -18,10 +18,11 @@ extern void of_device_make_bus_id(struct device *dev);
>  * @drv: the device_driver structure to test
>  * @dev: the device structure to match against
>  */
> -static inline int of_driver_match_device(const struct device *dev,
> +static inline int of_driver_match_device(struct device *dev,
>                                         const struct device_driver *drv)
>  {
> -       return of_match_device(drv->of_match_table, dev) != NULL;
> +       dev->of_match = of_match_device(drv->of_match_table, dev);
> +       return dev->of_match != NULL;
>  }
>
>  extern struct platform_device *of_dev_get(struct platform_device *dev);
>
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
