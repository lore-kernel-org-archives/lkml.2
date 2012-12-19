Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719Ab2LSLDS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 06:03:18 -0500
Received: from mail-vb0-f52.google.com ([209.85.212.52]:45030 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805Ab2LSLDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 06:03:11 -0500
MIME-Version: 1.0
In-Reply-To: <1355914716-19469-1-git-send-email-grant.likely@secretlab.ca>
References: <1355914716-19469-1-git-send-email-grant.likely@secretlab.ca>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 19 Dec 2012 11:02:49 +0000
X-Google-Sender-Auth: w-gZCVQ3Xyc2YI9s309JjbcG9Lw
Message-ID: <CACxGe6vTxQGr+t5O4q0J265K02-EEeEiGoOTvB1o-ee2bBrhZg@mail.gmail.com>
Subject: Re: [PATCH] of: Fix export of of_find_matching_node_and_match()
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Stephen Warren <swarren@nvidia.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Anatolij Gustschin <agust@denx.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2012 at 10:58 AM, Grant Likely
<grant.likely@secretlab.ca> wrote:
> Commit 50c8af4cf9, "of: introduce for_each_matching_node_and_match()"
> renamed of_find_matching_node() to of_find_matching_node_and_match() and
> created a new static inline of_find_matching_node() wrapper around the
> new name. However, the change neglected to change the EXPORT_SYMBOL()
> reference causing build errors for modules.
>
> This patch fixes the EXPORT_SYMBOL() statement. Discovered on a PowerPC
> Efika build with the mpc52xx_uart driver being built as a module.
>
> Reported-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> Cc: Stephen Warren <swarren@nvidia.com>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: Anatolij Gustschin <agust@denx.de>

Rob, I've just pushed this out to my devicetree/merge branch. If
you've got any fixes queued up for Linus, then please pull this in
before sending them on to him. Otherwise I'll send Linus a pull req
for this fix this evening. Ether way, please reply to let me know what
you're going to do.

g.

The following changes since commit 752451f01c4567b506bf4343082682dbb8fb30dd:

  Merge branch 'i2c-embedded/for-next' of
git://git.pengutronix.de/git/wsa/linux (2012-12-18 16:51:10 -0800)

are available in the git repository at:

  git://git.secretlab.ca/git/linux-2.6 devicetree/merge

for you to fetch changes up to 80c2022e5645a1a789531d13010292c5c18bf1db:

  of: Fix export of of_find_matching_node_and_match() (2012-12-19
10:58:53 +0000)

----------------------------------------------------------------
Grant Likely (1):
      of: Fix export of of_find_matching_node_and_match()

 drivers/of/base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

> ---
>
> I'll push this patch out to my tree ASAP.
>
>  drivers/of/base.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/of/base.c b/drivers/of/base.c
> index db8d211..2390ddb 100644
> --- a/drivers/of/base.c
> +++ b/drivers/of/base.c
> @@ -629,7 +629,7 @@ struct device_node *of_find_matching_node_and_match(struct device_node *from,
>         read_unlock(&devtree_lock);
>         return np;
>  }
> -EXPORT_SYMBOL(of_find_matching_node);
> +EXPORT_SYMBOL(of_find_matching_node_and_match);
>
>  /**
>   * of_modalias_node - Lookup appropriate modalias for a device node
> --
> 1.7.10.4
>



--
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
