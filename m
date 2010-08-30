Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989Ab0H3QbL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 12:31:11 -0400
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:57539 "HELO
	cpoproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754676Ab0H3QbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 12:31:10 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=leI2G5jqt1Q8kRRMwVflTT0LqBSrixktYPTdz/9aFZuWR/2dybNp8igQy+ViVPc2tuuIHzyv1t8nOIZIzggd0Zol9RQLLNerhZSYhA5FUObIVo+ce9wUq3dnwmMu4dqb;
Date: Mon, 30 Aug 2010 09:31:04 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Kees Cook <kees.cook@canonical.com>
Cc: linux-kernel@vger.kernel.org, Dave Airlie <airlied@redhat.com>,
        Clemens Ladisch <clemens@ladisch.de>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Devin Heitmueller <dheitmueller@kernellabs.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, dri-devel@lists.freedesktop.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] drm, video: fix use-before-NULL-check
Message-ID: <20100830093104.5aa22a0a@jbarnes-desktop>
In-Reply-To: <20100827210719.GD4703@outflux.net>
References: <20100827210719.GD4703@outflux.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Aug 2010 14:07:19 -0700
Kees Cook <kees.cook@canonical.com> wrote:

> Fix potential crashes due to use-before-NULL situations.
> 
> Signed-off-by: Kees Cook <kees.cook@canonical.com>
> ---
>  drivers/gpu/drm/drm_fb_helper.c           |    3 ++-
>  drivers/media/video/em28xx/em28xx-video.c |    3 ++-
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helper.c
> index de82e20..8dd7e6f 100644
> --- a/drivers/gpu/drm/drm_fb_helper.c
> +++ b/drivers/gpu/drm/drm_fb_helper.c
> @@ -94,10 +94,11 @@ static bool drm_fb_helper_connector_parse_command_line(struct drm_fb_helper_conn
>  	int i;
>  	enum drm_connector_force force = DRM_FORCE_UNSPECIFIED;
>  	struct drm_fb_helper_cmdline_mode *cmdline_mode;
> -	struct drm_connector *connector = fb_helper_conn->connector;
> +	struct drm_connector *connector;
>  
>  	if (!fb_helper_conn)
>  		return false;
> +	connector = fb_helper_conn->connector;
>  
>  	cmdline_mode = &fb_helper_conn->cmdline_mode;
>  	if (!mode_option)
> diff --git a/drivers/media/video/em28xx/em28xx-video.c b/drivers/media/video/em28xx/em28xx-video.c
> index 7b9ec6e..95a4b60 100644
> --- a/drivers/media/video/em28xx/em28xx-video.c
> +++ b/drivers/media/video/em28xx/em28xx-video.c
> @@ -277,12 +277,13 @@ static void em28xx_copy_vbi(struct em28xx *dev,
>  {
>  	void *startwrite, *startread;
>  	int  offset;
> -	int bytesperline = dev->vbi_width;
> +	int bytesperline;
>  
>  	if (dev == NULL) {
>  		em28xx_isocdbg("dev is null\n");
>  		return;
>  	}
> +	bytesperline = dev->vbi_width;
>  
>  	if (dma_q == NULL) {
>  		em28xx_isocdbg("dma_q is null\n");

Look fine to me.

Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>


-- 
Jesse Barnes, Intel Open Source Technology Center
