Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735Ab1JXKG1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 06:06:27 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:55149 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754236Ab1JXKG0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 06:06:26 -0400
MIME-Version: 1.0
In-Reply-To: <1319450012-13033-1-git-send-email-nicolas.ferre@atmel.com>
References: <1319450012-13033-1-git-send-email-nicolas.ferre@atmel.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 24 Oct 2011 12:06:05 +0200
X-Google-Sender-Auth: jUTeNcFxRBFLuPxL_t5P87CA2kQ
Message-ID: <CACxGe6txWcZYvym411Xat0S8UJX=3MWwSLq-GPQn=ERwV00KjA@mail.gmail.com>
Subject: Re: [PATCH] dt: Add empty of_match_node() macro
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: robherring2@gmail.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 24, 2011 at 11:53 AM, Nicolas Ferre <nicolas.ferre@atmel.com> wrote:
> Add an empty macro for of_match_node() that will save
> some '#ifdef CONFIG_OF' for non-dt builds.
>
> I have chosen to use a macro instead of a function to
> be able to avoid defining the first parameter.
> In fact, this "struct of_device_id *" first parameter
> is usualy not defined as well on non-dt builds.
>
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
>  include/linux/of.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/include/linux/of.h b/include/linux/of.h
> index 736b747..92c40a1 100644
> --- a/include/linux/of.h
> +++ b/include/linux/of.h
> @@ -303,6 +303,7 @@ static inline struct device_node *of_parse_phandle(struct device_node *np,
>  }
>
>  #define of_match_ptr(_ptr)     NULL
> +#define of_match_node(_matches, _node) NULL

Where possible, I prefer to code to be written in C, not PP.  :-)
static inline please.

g.
