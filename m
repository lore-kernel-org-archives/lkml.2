Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041Ab2BMAEl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 19:04:41 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:40661 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754757Ab2BMAEk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 19:04:40 -0500
MIME-Version: 1.0
In-Reply-To: <1328980929-5423-1-git-send-email-dong.aisheng@linaro.org>
References: <1328980929-5423-1-git-send-email-dong.aisheng@linaro.org>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sun, 12 Feb 2012 17:04:20 -0700
X-Google-Sender-Auth: gW4hDwNsIIhvX9GEbX0j7vUY3Ec
Message-ID: <CACxGe6tUVR+dWphnswTYcY+kut6V_WTN17ZMR8dFGd0XviyU9Q@mail.gmail.com>
Subject: Re: [PATCH V3 1/1] dt: add of_get_child_count helper function
To: Dong Aisheng <dong.aisheng@linaro.org>
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, rob.herring@calxeda.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 11, 2012 at 10:22 AM, Dong Aisheng <dong.aisheng@linaro.org> wrote:
> Currently most code to get child count in kernel are almost same,
> add a helper to implement this function for dt to use.
>
> Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Rob Herring <rob.herring@calxeda.com>
>
> ---
> Hi Rob,
>
> Since my imx pinctrl driver series still depends on the pinctrl core dt
> binding patch which is still not in mainline, i'd like this pure dt patch
> go separately first in case others want to use.
>
> changes v2->v3:
>  Addressed some people's comments:
>  * do not use assignment as expression
>  * return 0 for non-dt case
>
> Changes v1->v2:
>  * change the name from of_get_child_number to of_get_child_count
> ---
>  include/linux/of.h |   16 ++++++++++++++++
>  1 files changed, 16 insertions(+), 0 deletions(-)
>
> diff --git a/include/linux/of.h b/include/linux/of.h
> index a75a831..ae242ef 100644
> --- a/include/linux/of.h
> +++ b/include/linux/of.h
> @@ -195,6 +195,17 @@ extern struct device_node *of_get_next_child(const struct device_node *node,
>        for (child = of_get_next_child(parent, NULL); child != NULL; \
>             child = of_get_next_child(parent, child))
>
> +static inline int of_get_child_count(const struct device_node *np)
> +{
> +       struct device_node *child = NULL;
> +       int num = 0;
> +
> +       while ((child = of_get_next_child(np, child)) != NULL)
> +               num++;

Use for_each_child_of_node()

g.
