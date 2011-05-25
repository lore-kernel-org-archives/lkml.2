Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758031Ab1EYQS6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 12:18:58 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:48165 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757069Ab1EYQS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 12:18:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=HQDOWSI+ITllzGgBrQ+RFIef4pU52PQaw+GGoHjXmTtpN5GUHmLfKNb1CvfZF3AuUD
         7HRNHwknosZypUm0kiNuSeFJEuFT8+/OswUEfhEawLGqdFRg43ndlosY8CkGYmlUN2Hq
         5RNssHkyOhjFqsfvG/B/ZiggRtdUxWlp5Clu8=
Date: Wed, 25 May 2011 09:18:51 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Hans Petter Selasky <hselasky@c2i.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Properly assign return value of clamp() macro.
Message-ID: <20110525161851.GB22517@core.coreip.homeip.net>
References: <201105232158.34929.hselasky@c2i.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201105232158.34929.hselasky@c2i.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 23, 2011 at 09:58:34PM +0200, Hans Petter Selasky wrote:
> From 2b7fc579e802357b7b0742bf6bbbabdaf9e40c1e Mon Sep 17 00:00:00 2001
> From: Hans Petter Selasky <hselasky@c2i.net>
> Date: Mon, 23 May 2011 21:54:42 +0200
> Subject: [PATCH] Properly assign return value of clamp() macro.
> 
> Signed-off-by: Hans Petter Selasky <hselasky@c2i.net>

Applied, thanks Hans Peter. I am not sure why I thought clamp() was
modifying its argument... I added similar change to mousedev as well.

> ---
>  drivers/input/input.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/input/input.c b/drivers/input/input.c
> index ebbceed..e3c88fc 100644
> --- a/drivers/input/input.c
> +++ b/drivers/input/input.c
> @@ -1757,7 +1757,7 @@ static unsigned int 
> input_estimate_events_per_packet(struct input_dev *dev)
>  	} else if (test_bit(ABS_MT_TRACKING_ID, dev->absbit)) {
>  		mt_slots = dev->absinfo[ABS_MT_TRACKING_ID].maximum -
>  			   dev->absinfo[ABS_MT_TRACKING_ID].minimum + 1,
> -		clamp(mt_slots, 2, 32);
> +		mt_slots = clamp(mt_slots, 2, 32);
>  	} else if (test_bit(ABS_MT_POSITION_X, dev->absbit)) {
>  		mt_slots = 2;
>  	} else {

-- 
Dmitry
