Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149Ab1GaWIR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 18:08:17 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:58788 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752913Ab1GaWH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 18:07:57 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sven Eckelmann <sven@narfation.org>
Subject: Re: [PATCHv4 05/11] omap3isp: Use *_dec_not_zero instead of *_add_unless
Date: Sun, 31 Jul 2011 17:00:43 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.37-gentoo-r3; KDE/4.6.5; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
References: <1311760070-21532-1-git-send-email-sven@narfation.org> <1311760070-21532-5-git-send-email-sven@narfation.org>
In-Reply-To: <1311760070-21532-5-git-send-email-sven@narfation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201107311700.43515.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sven,

Thanks for the patch.

On Wednesday 27 July 2011 11:47:44 Sven Eckelmann wrote:
> atomic_dec_not_zero is defined for each architecture through
> <linux/atomic.h> to provide the functionality of
> atomic_add_unless(x, -1, 0).
> 
> Signed-off-by: Sven Eckelmann <sven@narfation.org>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

I'll queue this to my tree for v3.2. Please let me know if you would rather 
push the patch through another tree.

> Cc: linux-media@vger.kernel.org
> ---
>  drivers/media/video/omap3isp/ispstat.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/omap3isp/ispstat.c
> b/drivers/media/video/omap3isp/ispstat.c index b44cb68..81b1ec9 100644
> --- a/drivers/media/video/omap3isp/ispstat.c
> +++ b/drivers/media/video/omap3isp/ispstat.c
> @@ -652,7 +652,7 @@ static int isp_stat_buf_process(struct ispstat *stat,
> int buf_state) {
>  	int ret = STAT_NO_BUF;
> 
> -	if (!atomic_add_unless(&stat->buf_err, -1, 0) &&
> +	if (!atomic_dec_not_zero(&stat->buf_err) &&
>  	    buf_state == STAT_BUF_DONE && stat->state == ISPSTAT_ENABLED) {
>  		ret = isp_stat_buf_queue(stat);
>  		isp_stat_buf_next(stat);

-- 
Regards,

Laurent Pinchart
