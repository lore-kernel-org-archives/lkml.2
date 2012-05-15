Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755815Ab2EOKo3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 06:44:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20285 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752536Ab2EOKo2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 06:44:28 -0400
Message-ID: <4FB23381.5020007@redhat.com>
Date: Tue, 15 May 2012 07:44:17 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: mathieu.poirier@linaro.org
CC: mchehab@infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: Re: [PATCH 2/6] v4l/dvb: fix Kconfig dependencies on VIDEO_CAPTURE_DRIVERS
References: <1336083747-3142-1-git-send-email-mathieu.poirier@linaro.org> <1336083747-3142-3-git-send-email-mathieu.poirier@linaro.org>
In-Reply-To: <1336083747-3142-3-git-send-email-mathieu.poirier@linaro.org>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 03-05-2012 19:22, mathieu.poirier@linaro.org escreveu:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> Kconfig warns about unsatisfied dependencies of symbols that
> are directly selected.
> 
> Many capture drivers depend on DVB capture drivers, which
> are hidden behind the CONFIG_DVB_CAPTURE_DRIVERS setting.
> 
> The solution here is to enable DVB_CAPTURE_DRIVERS unconditionally
> when both DVB and VIDEO_CAPTURE_DRIVERS are enabled.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
> ---
>  drivers/media/dvb/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/dvb/Kconfig b/drivers/media/dvb/Kconfig
> index f6e40b3..c617996 100644
> --- a/drivers/media/dvb/Kconfig
> +++ b/drivers/media/dvb/Kconfig
> @@ -29,7 +29,7 @@ config DVB_DYNAMIC_MINORS
>  	  If you are unsure about this, say N here.
>  
>  menuconfig DVB_CAPTURE_DRIVERS
> -	bool "DVB/ATSC adapters"
> +	bool "DVB/ATSC adapters" if !VIDEO_CAPTURE_DRIVERS
>  	depends on DVB_CORE
>  	default y
>  	---help---

No, this is not right. Users can select either DVB or V4L2 (or hybrid) 
devices independently.

If now a warning is happening, is because something changed Kconfig
behavior on some non-expected way.

Nack.

Regards,
Mauro
