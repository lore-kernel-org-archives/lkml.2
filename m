Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866Ab2FLVgu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 17:36:50 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:32784 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745Ab2FLVgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 17:36:49 -0400
Date: Tue, 12 Jun 2012 14:36:44 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Chris Yungmann <yungmann.chris@gmail.com>
Cc: samuel.thibault@ens-lyon.org, w.d.hubbs@gmail.com, chris@the-brannons.com,
        kirk@braille.uwo.ca, speakup@braille.uwo.ca,
        linux-kernel@vger.kernel.org, kernelnewbies@kernelnewbies.org
Subject: Re: [PATCH][RESEND] staging: speakup: fixed checkpatch and sparse
 warnings in selection.c
Message-ID: <20120612213644.GA31966@kroah.com>
References: <1339526651-14388-1-git-send-email-yungmann.chris@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339526651-14388-1-git-send-email-yungmann.chris@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2012 at 02:44:11PM -0400, Chris Yungmann wrote:
> Left in_atomic() call as more work is needed (see TODO note at top of function).
> 
> Signed-off-by: Chris Yungmann <yungmann.chris@gmail.com>
> ---
>  drivers/staging/speakup/selection.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/speakup/selection.c b/drivers/staging/speakup/selection.c
> index fe1f405..006403d 100644
> --- a/drivers/staging/speakup/selection.c
> +++ b/drivers/staging/speakup/selection.c
> @@ -68,7 +68,7 @@ int speakup_set_selection(struct tty_struct *tty)
>  	if (spk_sel_cons != vc_cons[fg_console].d) {
>  		speakup_clear_selection();
>  		spk_sel_cons = vc_cons[fg_console].d;
> -		printk(KERN_WARNING
> +		pr_warn(KERN_WARNING

Nope, that will not work, sorry.

Actually, please use dev_warn() and friends instead of "raw" printk()
calls is the better thing to do.

thanks,

greg k-h
