Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751538Ab0LPW1j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 17:27:39 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:33073 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869Ab0LPW1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 17:27:38 -0500
Date: Thu, 16 Dec 2010 14:26:49 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de, akpm@linux-foundation.org,
        andi@firstfloor.org
Subject: Re: [PATCH] init: Fix for section mismatch in reference from
 name_to_dev_t().
Message-Id: <20101216142649.4a904846.randy.dunlap@oracle.com>
In-Reply-To: <1292532772-29923-1-git-send-email-mroberto@cpti.cetuc.puc-rio.br>
References: <1292532772-29923-1-git-send-email-mroberto@cpti.cetuc.puc-rio.br>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Dec 2010 18:52:52 -0200 Marcelo Roberto Jimenez wrote:

> This patch fixes the following message while compiling the kernel:

I think that this one is preferable:

https://lkml.org/lkml/2010/12/7/210


> WARNING: init/mounts.o(.text+0x40): Section mismatch in reference from
> the function name_to_dev_t() to the function
> .init.text:devt_from_partuuid()
> The function name_to_dev_t() references
> the function __init devt_from_partuuid().
> This is often because name_to_dev_t lacks a __init
> annotation or the annotation of devt_from_partuuid is wrong.
> 
> Signed-off-by: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
> ---
>  init/do_mounts.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/init/do_mounts.c b/init/do_mounts.c
> index 830aaec..ba48e11 100644
> --- a/init/do_mounts.c
> +++ b/init/do_mounts.c
> @@ -133,7 +133,7 @@ done:
>   *	bangs.
>   */
>  
> -dev_t name_to_dev_t(char *name)
> +dev_t __init name_to_dev_t(char *name)
>  {
>  	char s[32];
>  	char *p;
> -- 
> 1.7.3.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
