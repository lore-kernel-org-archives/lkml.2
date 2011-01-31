Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756659Ab1AaWKx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 17:10:53 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:46511 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069Ab1AaWKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 17:10:52 -0500
Date: Mon, 31 Jan 2011 15:10:47 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Thomas Chou <thomas@wytron.com.tw>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Ben Dooks <ben-linux@fluff.org>, linux-kernel@vger.kernel.org,
        nios2-dev@sopc.et.ntust.edu.tw, devicetree-discuss@lists.ozlabs.org,
        linux-i2c@vger.kernel.org, Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH 1/3] of: define dummy of_get_property if not CONFIG_OF
Message-ID: <20110131221047.GA27856@angua.secretlab.ca>
References: <AANLkTimS70uHqmv3jhr+7mPz4QFKXRXuFnWj8s3EpKsO@mail.gmail.com>
 <1296487551-30938-1-git-send-email-thomas@wytron.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296487551-30938-1-git-send-email-thomas@wytron.com.tw>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 31, 2011 at 11:25:49PM +0800, Thomas Chou wrote:
> This will help to reduce the ifdef CONFIG_OF needed in most
> platform data probing.
> 
> Signed-off-by: Thomas Chou <thomas@wytron.com.tw>

With moving the dt reading into a separate function protected by
CONFIG_OF, this patch shouldn't be necessary.

g.

> ---
>  include/linux/of.h |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/of.h b/include/linux/of.h
> index cad7cf0..5e122cb 100644
> --- a/include/linux/of.h
> +++ b/include/linux/of.h
> @@ -222,5 +222,13 @@ extern void of_attach_node(struct device_node *);
>  extern void of_detach_node(struct device_node *);
>  #endif
>  
> +#else /* !CONFIG_OF */
> +
> +static inline const void *of_get_property(const struct device_node *node,
> +				const char *name, int *lenp)
> +{
> +	return NULL;
> +}
> +
>  #endif /* CONFIG_OF */
>  #endif /* _LINUX_OF_H */
> -- 
> 1.7.3.5
> 
