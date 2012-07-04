Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755735Ab2GDUGA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 16:06:00 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54151 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753821Ab2GDUF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 16:05:56 -0400
Date: Wed, 4 Jul 2012 13:05:50 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH] lm8333: Fix check ordering
Message-ID: <20120704200550.GA13248@core.coreip.homeip.net>
References: <20120704145653.7910.26502.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120704145653.7910.26502.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

On Wed, Jul 04, 2012 at 03:57:00PM +0100, Alan Cox wrote:
> From: Alan Cox <alan@linux.intel.com>
> 
> Fix harmless reference off end of array
> 
> Reported-by: <dcb314@hotmail.com>
> Resolves-bug: https://bugzilla.kernel.org/show_bug.cgi?43861
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> ---
> 
>  drivers/input/keyboard/lm8333.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/input/keyboard/lm8333.c b/drivers/input/keyboard/lm8333.c
> index ca168a6..081fd9e 100644
> --- a/drivers/input/keyboard/lm8333.c
> +++ b/drivers/input/keyboard/lm8333.c
> @@ -91,7 +91,7 @@ static void lm8333_key_handler(struct lm8333 *lm8333)
>  		return;
>  	}
>  
> -	for (i = 0; keys[i] && i < LM8333_FIFO_TRANSFER_SIZE; i++) {
> +	for (i = 0; i < LM8333_FIFO_TRANSFER_SIZE && keys[i]; i++) {
>  		pressed = keys[i] & 0x80;
>  		code = keys[i] & 0x7f;
>  
> 

I believe Jiri has already queued this through trivial tree...

Thanks.

-- 
Dmitry
