Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756327Ab0KRMSb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 07:18:31 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:57470 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753936Ab0KRMS3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 07:18:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JmeHZWMEHgHtN+J6fcuk2tryhYeV+OcJWW27LUspxWmmX99tijMQ9VUvTUx4K84d+F
         6rw7i7S5IsHkpn8I1XGYVSrLG9xRZc8QZSZvdOtRwEKkJXh+UhW5+2x1Hu9ZHtJDklMZ
         eDr83M6LWDapfd6k5RfW2vL+2rK6GH9ZCm6z0=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=xJb1LcGXeCcd_tJ+Q9vV5W4z3M-up_mrKeV9q@mail.gmail.com>
References: <AANLkTi=xJb1LcGXeCcd_tJ+Q9vV5W4z3M-up_mrKeV9q@mail.gmail.com>
Date: Thu, 18 Nov 2010 13:18:28 +0100
Message-ID: <AANLkTim+sFEW6QWTMdyTGR66VKLio61v0Rxbm8Z6dy_e@mail.gmail.com>
Subject: Re: [PATCH 1/2] uml: Safely iterate list of winch handlers in line driver.
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Will Newton <will.newton@gmail.com>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
        user-mode-linux-devel@lists.sourceforge.net,
        Jeff Dike <jdike@addtoit.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 13, 2010 at 6:44 PM, Will Newton <will.newton@gmail.com> wrote:
> unregister_winch should use list_for_each_safe, as it can
> potentially delete from the list.
>
> Signed-off-by: Will Newton <will.newton@gmail.com>
> ---
>  arch/um/drivers/line.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/um/drivers/line.c b/arch/um/drivers/line.c
> index 7f7338c..5f12fef 100644
> --- a/arch/um/drivers/line.c
> +++ b/arch/um/drivers/line.c
> @@ -820,12 +820,12 @@ void register_winch_irq(int fd, int tty_fd, int
> pid, struct tty_struct *tty,
>
>  static void unregister_winch(struct tty_struct *tty)
>  {
> -       struct list_head *ele;
> +       struct list_head *ele, *next;
>        struct winch *winch;
>
>        spin_lock(&winch_handler_lock);
>
> -       list_for_each(ele, &winch_handlers) {
> +       list_for_each_safe(ele, next, &winch_handlers) {
>                winch = list_entry(ele, struct winch, list);
>                if (winch->tty == tty) {
>                        free_winch(winch, 1);
> --
> 1.7.0.4
>

Please send your patches to akpm.

-- 
Thanks,
//richard
