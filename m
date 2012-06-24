Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005Ab2FXMJ0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 08:09:26 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:43893 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754726Ab2FXMJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 08:09:24 -0400
Date: Sun, 24 Jun 2012 15:08:53 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org,
        Marcos Paulo de Souza <marcos.mage@gmail.com>,
        Forest Bond <forest@alittletooquiet.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: vt6656: Correct a few assignments to be
 compares in iwctl_siwencodeext()
Message-ID: <20120624120853.GH5333@mwanda>
References: <alpine.LNX.2.00.1206220225000.7671@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1206220225000.7671@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2012 at 02:28:12AM +0200, Jesper Juhl wrote:
> The result of "foo = bar" is true, so in statements such as
>   ...
>   if((pDevice->bwextstep0 = TRUE)&&(param->u.wpa_key.key_index ==1))
>   ...
> an assignment  is most likely not what was intended - a comparison was. As in:
>   ...
>   if ((pDevice->bwextstep0 == TRUE) && (param->u.wpa_key.key_index == 1))
>   ...
> 
> There are a 3 such mistakes in the iwctl_siwencodeext() function.
> This patch fixes them all.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  drivers/staging/vt6656/iwctl.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
>   The file could also do with a serious style cleanup, but that's a 
>   different (set of) patches. This one just fixes the bug.
> 
> diff --git a/drivers/staging/vt6656/iwctl.c b/drivers/staging/vt6656/iwctl.c
> index b24e531..5740438 100644
> --- a/drivers/staging/vt6656/iwctl.c
> +++ b/drivers/staging/vt6656/iwctl.c
> @@ -1708,15 +1708,15 @@ if(param->u.wpa_key.alg_name == WPA_ALG_NONE) {
>     if(param->u.wpa_key.key_index ==0) {
>       pDevice->bwextstep0 = TRUE;
>      }
> -   if((pDevice->bwextstep0 = TRUE)&&(param->u.wpa_key.key_index ==1)) {
> +   if ((pDevice->bwextstep0 == TRUE) && (param->u.wpa_key.key_index == 1)) {

Good catch.

GCC would have warned about this bug except that the author tried to
program it in lisp and added stupid extra paranthesis through out.

regards,
dan carpenter


