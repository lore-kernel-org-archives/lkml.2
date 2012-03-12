Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756482Ab2CLToo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 15:44:44 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:64446 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756338Ab2CLTon convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 15:44:43 -0400
MIME-Version: 1.0
In-Reply-To: <1331324305-1649-1-git-send-email-swarren@wwwdotorg.org>
References: <1331324305-1649-1-git-send-email-swarren@wwwdotorg.org>
Date: Mon, 12 Mar 2012 20:44:42 +0100
Message-ID: <CACRpkdbkoahUiB01srfBzm1Qh2RQPw5P6BjmouuLETAqfQY6_Q@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: Include <linux/bug.h> to prevent compile errors
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 9, 2012 at 9:18 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:

> Macros in <linux/pinctrl/machine.h> call ARRAY_SIZE(), the definition of
> which eventually calls BUILD_BUG_ON_ZERO(), which is defined in
> <linux/bug.h>. Include that so that every .c file using the pinctrl macros
> doesn't have to do that itself.

I get this part...

> Signed-off-by: Stephen Warren <swarren@wwwdotorg.org>
> ---
>  include/linux/pinctrl/machine.h |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
>
> diff --git a/include/linux/pinctrl/machine.h b/include/linux/pinctrl/machine.h
> index fee4349..012731a 100644
> --- a/include/linux/pinctrl/machine.h
> +++ b/include/linux/pinctrl/machine.h
> @@ -12,7 +12,9 @@
>  #ifndef __LINUX_PINCTRL_MACHINE_H
>  #define __LINUX_PINCTRL_MACHINE_H
>
> -#include "pinctrl-state.h"

?

> +#include <linux/bug.h>
> +
> +#include "pinctrl.h"

?

But I moved the states out of machine.h and pinctrl.h just so
that we shouldn't have to include pinctrl.h into machine.h?

Thanks,
Linus Walleij
