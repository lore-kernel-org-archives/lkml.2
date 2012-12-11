Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456Ab2LKIwF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 03:52:05 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:48702 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930Ab2LKIwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 03:52:02 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH RFC 04/13] OF: make a function pointer argument const
To: Sylwester Nawrocki <s.nawrocki@samsung.com>, g.liakhovetski@gmx.de,
        linux-media@vger.kernel.org
Cc: rob.herring@calxeda.com, thomas.abraham@linaro.org, t.figa@samsung.com,
        sw0312.kim@samsung.com, kyungmin.park@samsung.com,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <1355168499-5847-5-git-send-email-s.nawrocki@samsung.com>
References: <1355168499-5847-1-git-send-email-s.nawrocki@samsung.com> <1355168499-5847-5-git-send-email-s.nawrocki@samsung.com>
Date: Tue, 11 Dec 2012 08:51:48 +0000
Message-Id: <20121211085148.DB67A3E076D@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Dec 2012 20:41:30 +0100, Sylwester Nawrocki <s.nawrocki@samsung.com> wrote:
> From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> 
> The "struct device_node *" argument of of_parse_phandle_*() can be const.

This is a good time to talk about commit text. Again, the patch looks
fine, but it helps *a lot* if you give me some details about how you
constructed the patch and tested it.

What architectures did you build? What defconfigs did you use? Did you look
at all the users, or can you say the users should all be good?

It also always helps to tell my *why* you made a change.

Otherwise you leave all the leg work up to me or another maintainer.
We've got a lot of work. Anything you can do to make that easier makes
us less grumpy. :-)

I'll try to apply the patch (I've actually already merged another one
that does of_parse_phandle, but not of_parse_phandle_with_args, so I'll
need to resolve the conflict)

g.

> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
>  drivers/of/base.c  |    4 ++--
>  include/linux/of.h |    6 +++---
>  2 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/of/base.c b/drivers/of/base.c
> index af3b22a..c180205 100644
> --- a/drivers/of/base.c
> +++ b/drivers/of/base.c
> @@ -894,7 +894,7 @@ EXPORT_SYMBOL_GPL(of_property_count_strings);
>   * of_node_put() on it when done.
>   */
>  struct device_node *
> -of_parse_phandle(struct device_node *np, const char *phandle_name, int index)
> +of_parse_phandle(const struct device_node *np, const char *phandle_name, int index)
>  {
>  	const __be32 *phandle;
>  	int size;
> @@ -939,7 +939,7 @@ EXPORT_SYMBOL(of_parse_phandle);
>   * To get a device_node of the `node2' node you may call this:
>   * of_parse_phandle_with_args(node3, "list", "#list-cells", 1, &args);
>   */
> -int of_parse_phandle_with_args(struct device_node *np, const char *list_name,
> +int of_parse_phandle_with_args(const struct device_node *np, const char *list_name,
>  				const char *cells_name, int index,
>  				struct of_phandle_args *out_args)
>  {
> diff --git a/include/linux/of.h b/include/linux/of.h
> index 38d4b1a..2fb0dbe 100644
> --- a/include/linux/of.h
> +++ b/include/linux/of.h
> @@ -256,10 +256,10 @@ extern int of_n_size_cells(struct device_node *np);
>  extern const struct of_device_id *of_match_node(
>  	const struct of_device_id *matches, const struct device_node *node);
>  extern int of_modalias_node(struct device_node *node, char *modalias, int len);
> -extern struct device_node *of_parse_phandle(struct device_node *np,
> +extern struct device_node *of_parse_phandle(const struct device_node *np,
>  					    const char *phandle_name,
>  					    int index);
> -extern int of_parse_phandle_with_args(struct device_node *np,
> +extern int of_parse_phandle_with_args(const struct device_node *np,
>  	const char *list_name, const char *cells_name, int index,
>  	struct of_phandle_args *out_args);
>  
> @@ -412,7 +412,7 @@ static inline int of_property_match_string(struct device_node *np,
>  	return -ENOSYS;
>  }
>  
> -static inline struct device_node *of_parse_phandle(struct device_node *np,
> +static inline struct device_node *of_parse_phandle(const struct device_node *np,
>  						   const char *phandle_name,
>  						   int index)
>  {
> -- 
> 1.7.9.5
> 

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
