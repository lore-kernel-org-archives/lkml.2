Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030529Ab2CIUcR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 15:32:17 -0500
Received: from mail1.windriver.com ([147.11.146.13]:58952 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030188Ab2CIUcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 15:32:12 -0500
Date: Fri, 9 Mar 2012 15:32:07 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Linus Walleij <linus.walleij@linaro.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] pinctrl: Include <linux/bug.h> to prevent compile errors
Message-ID: <20120309203207.GB10835@windriver.com>
References: <1331324305-1649-1-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1331324305-1649-1-git-send-email-swarren@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[[PATCH] pinctrl: Include <linux/bug.h> to prevent compile errors] On 09/03/2012 (Fri 13:18) Stephen Warren wrote:

> Macros in <linux/pinctrl/machine.h> call ARRAY_SIZE(), the definition of
> which eventually calls BUILD_BUG_ON_ZERO(), which is defined in
> <linux/bug.h>. Include that so that every .c file using the pinctrl macros
> doesn't have to do that itself.

Which C files are failing?  The approach was to be adding it only
for headers with static inlines which use it, and add it to C files
that are actually *deploying* the macros.

Thanks,
Paul.

> 
> Signed-off-by: Stephen Warren <swarren@wwwdotorg.org>
> ---
>  include/linux/pinctrl/machine.h |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/pinctrl/machine.h b/include/linux/pinctrl/machine.h
> index fee4349..012731a 100644
> --- a/include/linux/pinctrl/machine.h
> +++ b/include/linux/pinctrl/machine.h
> @@ -12,7 +12,9 @@
>  #ifndef __LINUX_PINCTRL_MACHINE_H
>  #define __LINUX_PINCTRL_MACHINE_H
>  
> -#include "pinctrl-state.h"
> +#include <linux/bug.h>
> +
> +#include "pinctrl.h"
>  
>  enum pinctrl_map_type {
>  	PIN_MAP_TYPE_INVALID,
> -- 
> 1.7.0.4
> 
