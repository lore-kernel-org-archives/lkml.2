Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760705Ab2FGLDP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 07:03:15 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:43269 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755757Ab2FGLDO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 07:03:14 -0400
MIME-Version: 1.0
In-Reply-To: <1338656634-3870-1-git-send-email-devendra.aaru@gmail.com>
References: <1338656634-3870-1-git-send-email-devendra.aaru@gmail.com>
Date: Thu, 7 Jun 2012 13:03:13 +0200
Message-ID: <CACRpkdYCUOwNVApn06x+_1CA0zNarUt6d-4Kfd76P=UeREDrRw@mail.gmail.com>
Subject: Re: [PATCH 1/2] pinctrl: free allocated pinctrl_map structure only
 once and use kernel facilities for IMX_PMX_DUMP
From: Linus Walleij <linus.walleij@linaro.org>
To: Devendra Naga <devendra.aaru@gmail.com>, Shawn Guo <shawn.guo@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 2, 2012 at 7:03 PM, Devendra Naga <devendra.aaru@gmail.com> wrote:

> a) as we allocate the pinctrl_map structure at imx_dt_node_to_map at  line 167, anyway
> if its an element, or a num_elements * (sizeof(type)) elements allocated to one single
> pointer must be freed only once.
>
> CASE. A)
>
> as new_map is not moved and allocated like,
>
> for (i = 0; i < MAX_ELEMS; i++) {
>        new_map[i] = kmalloc(numelems * size, GFP_KERNEL);
> }
>
> its freed as
>
> for (i = 0; i < MAX_ELEMS; i++) {
>        kfree(new_map[i]);
> }
>
> CASE. B)
> and its allocated like
>        new_map = kmalloc(numelems * size, GFP_KERNEL);
>
> it just needs kfree not as case A's.
>
> b) use KERN_DEBUG facility for the IMX_PMX_DUMP macro.
>
> Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
> ---
>  drivers/pinctrl/pinctrl-imx.c |   23 +++++++++++------------
>  1 file changed, 11 insertions(+), 12 deletions(-)

Shawn/Dong: can you look at this patch too?

Yours,
Linus Walleij
