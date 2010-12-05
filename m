Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400Ab0LEM2h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 07:28:37 -0500
Received: from ist.d-labs.de ([213.239.218.44]:37396 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754932Ab0LEM2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 07:28:36 -0500
Date: Sun, 5 Dec 2010 13:27:43 +0100
From: Florian Mickler <florian@mickler.org>
To: Keith Packard <keithp@keithp.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>, Dave Airlie <airlied@redhat.com>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH 2/2] drm: record monitor status in
 output_poll_execute
Message-ID: <20101205132743.3b3458ab@schatten.dmk.lab>
In-Reply-To: <1290797159-3977-2-git-send-email-keithp@keithp.com>
References: <1290797159-3977-1-git-send-email-keithp@keithp.com>
	<1290797159-3977-2-git-send-email-keithp@keithp.com>
X-Mailer: Claws Mail 3.7.6cvs31 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Nov 2010 10:45:59 -0800
Keith Packard <keithp@keithp.com> wrote:

> In order to correctly report monitor connected status changes, the
> previous monitor status must be recorded in the connector->status
> value instead of being discarded.
> 
> Signed-off-by: Keith Packard <keithp@keithp.com>

Keith, am I right to assume that these address 
https://bugzilla.kernel.org/show_bug.cgi?id=22672
and probably:
https://bugzilla.kernel.org/show_bug.cgi?id=23472 

Regards,
Flo

> ---
>  drivers/gpu/drm/drm_crtc_helper.c |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/gpu/drm/drm_crtc_helper.c b/drivers/gpu/drm/drm_crtc_helper.c
> index 232ee93..7ca5935 100644
> --- a/drivers/gpu/drm/drm_crtc_helper.c
> +++ b/drivers/gpu/drm/drm_crtc_helper.c
> @@ -848,7 +848,7 @@ static void output_poll_execute(struct work_struct *work)
>  	struct delayed_work *delayed_work = to_delayed_work(work);
>  	struct drm_device *dev = container_of(delayed_work, struct drm_device, mode_config.output_poll_work);
>  	struct drm_connector *connector;
> -	enum drm_connector_status old_status, status;
> +	enum drm_connector_status old_status;
>  	bool repoll = false, changed = false;
>  
>  	if (!drm_kms_helper_poll)
> @@ -873,8 +873,9 @@ static void output_poll_execute(struct work_struct *work)
>  		    !(connector->polled & DRM_CONNECTOR_POLL_HPD))
>  			continue;
>  
> -		status = connector->funcs->detect(connector, false);
> -		if (old_status != status)
> +		connector->status = connector->funcs->detect(connector, false);
> +		DRM_DEBUG_KMS("connector status updated to %d\n", connector->status);
> +		if (old_status != connector->status)
>  			changed = true;
>  	}
>  
