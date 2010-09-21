Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612Ab0IUIDu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 04:03:50 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62718 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755589Ab0IUIDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 04:03:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=G8EzAq2+zM42+gFmKONCR6Y5nn2H0TuGbDsOvSPSP4L4/U3sm54ygE35vmL7MHiPzl
         SkA6SoAYI4t/2vq8BnYhj2H1IG9vFV3M5rR5I9KbE4GlyKII6FLtPiZ4A//pftVHfRb5
         2ClZpW7r7SvC1hW+eZAvuhTCclh8c46pn2ZNg=
Date: Tue, 21 Sep 2010 01:03:42 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Kenneth Waters <kwwaters@gmail.com>
Cc: steve@sk2.org, linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: joydev: Fix JSIOCSAXMAP ioctl.
Message-ID: <20100921080342.GA1365@core.coreip.homeip.net>
References: <1285051885-20417-1-git-send-email-kwwaters@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285051885-20417-1-git-send-email-kwwaters@gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 20, 2010 at 11:51:25PM -0700, Kenneth Waters wrote:
> Fixed JSIOCSAXMAP ioctl to update absmap, the map from hardware axis to
> event axis in addition to abspam.  This fixes a regression introduced
> by 999b874f.
> 
> Signed-off-by: Kenneth Waters <kwwaters@gmail.com>

Applied, thank you Kenneth.

> ---
>  drivers/input/joydev.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/input/joydev.c b/drivers/input/joydev.c
> index d85bd8a..22239e9 100644
> --- a/drivers/input/joydev.c
> +++ b/drivers/input/joydev.c
> @@ -483,6 +483,9 @@ static int joydev_handle_JSIOCSAXMAP(struct joydev *joydev,
>  
>  	memcpy(joydev->abspam, abspam, len);
>  
> +	for (i = 0; i < joydev->nabs; i++)
> +		joydev->absmap[joydev->abspam[i]] = i;
> +
>   out:
>  	kfree(abspam);
>  	return retval;
> -- 
> 1.7.2.2
> 

-- 
Dmitry
