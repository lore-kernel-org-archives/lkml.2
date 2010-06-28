Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216Ab0F1ICp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 04:02:45 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:54084 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794Ab0F1ICm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 04:02:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Oy6FToAndhyj73PSDLUcK+GBOkbGCvUrc5YmNSS9TKSd6ve9SDOrUgySAXS1D2AhJD
         VaSOiMtQE+VbyK1NwUvdQwL4YN6iTijqhyFh4u73BzwIFR9HEccqwBdvFCc27y0TbwcM
         LESa0zfDn24blJpt14U6Fkfa2esxdXcswE0l4=
Date: Mon, 28 Jun 2010 01:02:35 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Miloslav Trmac <mitr@volny.cz>, Rakib Mullick <rakib.mullick@gmail.com>,
       TJ <ubuntu@tjworld.net>, Julia Lawall <julia@diku.dk>,
       Samu Onkalo <samu.p.onkalo@nokia.com>, linux-input@vger.kernel.org
Subject: Re: [PATCH] wistron_btns: fix a memory leak in wb_module_init error
 path
Message-ID: <20100628080235.GB25287@core.coreip.homeip.net>
References: <1277706620.4148.2.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277706620.4148.2.camel@mola>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Mon, Jun 28, 2010 at 02:30:20PM +0800, Axel Lin wrote:
> select_keymap calls copy_keymap to allocate a memory for keymap.
> This patch adds a missing kfree(keymap) in wb_module_init error path.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/input/misc/wistron_btns.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/input/misc/wistron_btns.c b/drivers/input/misc/wistron_btns.c
> index 4dac8b7..55ce70e 100644
> --- a/drivers/input/misc/wistron_btns.c
> +++ b/drivers/input/misc/wistron_btns.c
> @@ -1371,6 +1371,7 @@ static int __init wb_module_init(void)
>  	platform_driver_unregister(&wistron_driver);
>   err_unmap_bios:
>  	unmap_bios();
> +	kfree(keymap);

Thank you for the patch, however this is not quite enough - we also need
to free keymap when map_bios() call fails instead of returning
immediately.

I fixed up locally and applied the patch.

-- 
Dmitry
