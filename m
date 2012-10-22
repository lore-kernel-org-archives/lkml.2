Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932220Ab2JVVuF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 17:50:05 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46693 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756110Ab2JVVuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 17:50:03 -0400
Date: Mon, 22 Oct 2012 14:50:00 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Priit Laes <plaes@plaes.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] staging: csr: Replace wakelocks with wakeup interface
Message-ID: <20121022215000.GA10698@kroah.com>
References: <1349284444-5860-1-git-send-email-plaes@plaes.org>
 <1349287950-7278-1-git-send-email-plaes@plaes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349287950-7278-1-git-send-email-plaes@plaes.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2012 at 09:12:30PM +0300, Priit Laes wrote:
> Wakelocks are an Android-specific API that never made into mainline.
> Eventually power management wakeup interface appeared, therefore use
> this interface instead.
> 
> Signed-off-by: Priit Laes <plaes@plaes.org>
> ---
>  drivers/staging/csr/drv.c        |  8 ++++----
>  drivers/staging/csr/sdio_mmc.c   | 23 +++++++----------------
>  drivers/staging/csr/sme_sys.c    | 18 +++++++++---------
>  drivers/staging/csr/unifi_priv.h |  8 --------
>  4 files changed, 20 insertions(+), 37 deletions(-)
> 
> diff --git a/drivers/staging/csr/drv.c b/drivers/staging/csr/drv.c
> index 2497580..262705a 100644
> --- a/drivers/staging/csr/drv.c
> +++ b/drivers/staging/csr/drv.c
> @@ -67,6 +67,8 @@ int bh_priority = -1;
>  int log_hip_signals = 0;
>  #endif
>  
> +extern struct wakeup_source unifi_sdio_wakeup_source;

You obviously didn't run scripts/checkpatch.pl against this patch, did
you?

Never put an extern in a .c file, put this in a .h file so that all .c
files can access it properly.

Care to fix this up and resend?

thanks,

greg k-h
