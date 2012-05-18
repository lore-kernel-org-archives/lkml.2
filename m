Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933706Ab2ERLSJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 07:18:09 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:36394 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933182Ab2ERLSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 07:18:07 -0400
Date: Fri, 18 May 2012 13:18:04 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Johan Hovold <jhovold@gmail.com>
Subject: Re: [PATCH] mfd: lm3533: fix return type of attribute is_visible
Message-ID: <20120518111804.GA20467@localhost>
References: <1336725641-11826-1-git-send-email-jhovold@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336725641-11826-1-git-send-email-jhovold@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

On Fri, May 11, 2012 at 10:40:41AM +0200, Johan Hovold wrote:
> Since commit 587a1f1659 ("switch ->is_visible() to returning umode_t")
> the return type of is_visible is umode_t rather than mode_t.
> 
> This silences a compiler warning on some architectures where these types
> are not compatible.
> 
> Reported-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Johan Hovold <jhovold@gmail.com>
> ---

Apparently Dan Carpenter sent a fix for this compiler warning the day
after I submitted mine. Dan's patch, however, only fixed the return type
and not the type of the mode variable.

Could you consider applying this patch one on top of Dan's (which you
applied to mfd-next on Monday)?

Thanks,
Johan

>  drivers/mfd/lm3533-core.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/mfd/lm3533-core.c b/drivers/mfd/lm3533-core.c
> index d11c891..5770bea 100644
> --- a/drivers/mfd/lm3533-core.c
> +++ b/drivers/mfd/lm3533-core.c
> @@ -359,7 +359,7 @@ static struct attribute *lm3533_attributes[] = {
>  #define to_dev_attr(_attr) \
>  	container_of(_attr, struct device_attribute, attr)
>  
> -static mode_t lm3533_attr_is_visible(struct kobject *kobj,
> +static umode_t lm3533_attr_is_visible(struct kobject *kobj,
>  					     struct attribute *attr, int n)
>  {
>  	struct device *dev = container_of(kobj, struct device, kobj);
> @@ -367,7 +367,7 @@ static mode_t lm3533_attr_is_visible(struct kobject *kobj,
>  	struct device_attribute *dattr = to_dev_attr(attr);
>  	struct lm3533_device_attribute *lattr = to_lm3533_dev_attr(dattr);
>  	enum lm3533_attribute_type type = lattr->type;
> -	mode_t mode = attr->mode;
> +	umode_t mode = attr->mode;
>  
>  	if (!lm3533->have_backlights && type == LM3533_ATTR_TYPE_BACKLIGHT)
>  		mode = 0;
