Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761570Ab2ELAle (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 20:41:34 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57236 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754890Ab2ELAld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 20:41:33 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 1/3] devres: Clarify documentation for devres_destroy()
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@stericsson.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1336065314-11696-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1336065314-11696-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Date: Fri, 11 May 2012 18:41:30 -0600
Message-Id: <20120512004130.A79063E0791@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  3 May 2012 18:15:12 +0100, Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:
> It's not massively obvious (at least to me) that removing and freeing a
> resource does not involve calling the release function for the resource
> but rather only removes the management of it. Make the documentation more
> explicit.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

This series looks appropriate to me.  FWIW:

Acked-by: Grant Likely <grant.likely@secretlab.ca>

> ---
>  drivers/base/devres.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/base/devres.c b/drivers/base/devres.c
> index 524bf96..1741a60 100644
> --- a/drivers/base/devres.c
> +++ b/drivers/base/devres.c
> @@ -309,6 +309,10 @@ EXPORT_SYMBOL_GPL(devres_remove);
>   * which @match returns 1.  If @match is NULL, it's considered to
>   * match all.  If found, the resource is removed atomically and freed.
>   *
> + * Note that the release function for the resource will not be called,
> + * only the devres-allocated data will be freed.  The caller becomes
> + * responsible for freeing any other data.
> + *
>   * RETURNS:
>   * 0 if devres is found and freed, -ENOENT if not found.
>   */
> -- 
> 1.7.10
> 

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
