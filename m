Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932074Ab2LNPqG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 10:46:06 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:55922 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756289Ab2LNPqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 10:46:04 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1212121521590.1995@hadrien>
References: <1355223525-19165-1-git-send-email-Julia.Lawall@lip6.fr>
	<20121212115624.GI4398@game.jcrosoft.org>
	<alpine.DEB.2.02.1212121521590.1995@hadrien>
Date: Fri, 14 Dec 2012 16:46:02 +0100
Message-ID: <CACRpkdbTKB+evcoqp02GBAnWOZ-06pEB_u=ssXQFdi5ZvV_8FQ@mail.gmail.com>
Subject: Re: [PATCH] drivers/pinctrl/pinctrl-at91.c: convert kfree to devm_kfree
From: Linus Walleij <linus.walleij@linaro.org>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2012 at 3:22 PM, Julia Lawall <julia.lawall@lip6.fr> wrote:

> From: Julia Lawall <Julia.Lawall@lip6.fr>
>
> The function at91_dt_node_to_map is ultimately called by the function
> pinctrl_get, which is an exported function.  Since it is possible that this
> function is not called from within a probe function, for safety, the kfree
> is converted to a devm_kfree, to both free the data and remove it from the
> device in a failure situation.
>
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>
> ---
> v2: Drop cleanup of the call to devm_kzalloc at the same time.

Thanks, applied with Jean-Christophe's ACK.

Yours,
Linus Walleij
