Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555Ab2LDQPu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 11:15:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751731Ab2LDQPt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 11:15:49 -0500
Message-ID: <50BE2193.4020103@redhat.com>
Date: Tue, 04 Dec 2012 14:15:15 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Federico Vaga <federico.vaga@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH v3 3/4] sta2x11_vip: convert to videobuf2 and control
 framework
References: <1348484332-8106-1-git-send-email-federico.vaga@gmail.com> <1348484332-8106-3-git-send-email-federico.vaga@gmail.com>
In-Reply-To: <1348484332-8106-3-git-send-email-federico.vaga@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 24-09-2012 07:58, Federico Vaga escreveu:
> This patch re-write the driver and use the videobuf2
> interface instead of the old videobuf. Moreover, it uses also
> the control framework which allows the driver to inherit
> controls from its subdevice (ADV7180)
>
> Signed-off-by: Federico Vaga <federico.vaga@gmail.com>
> Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
> ---
>   drivers/media/pci/sta2x11/Kconfig       |    2 +-
>   drivers/media/pci/sta2x11/sta2x11_vip.c | 1238 ++++++++++---------------------
>   2 file modificati, 407 inserzioni(+), 833 rimozioni(-)
>
> diff --git a/drivers/media/pci/sta2x11/Kconfig b/drivers/media/pci/sta2x11/Kconfig
> index 6749f67..654339f 100644
> --- a/drivers/media/pci/sta2x11/Kconfig
> +++ b/drivers/media/pci/sta2x11/Kconfig
> @@ -2,7 +2,7 @@ config STA2X11_VIP
>   	tristate "STA2X11 VIP Video For Linux"
>   	depends on STA2X11
>   	select VIDEO_ADV7180 if MEDIA_SUBDRV_AUTOSELECT
> -	select VIDEOBUF_DMA_CONTIG
> +	select VIDEOBUF2_DMA_STREAMING
>   	depends on PCI && VIDEO_V4L2 && VIRT_TO_BUS
>   	help
>   	  Say Y for support for STA2X11 VIP (Video Input Port) capture
> diff --git a/drivers/media/pci/sta2x11/sta2x11_vip.c b/drivers/media/pci/sta2x11/sta2x11_vip.c
> index 4c10205..b9ff926 100644
> --- a/drivers/media/pci/sta2x11/sta2x11_vip.c
> +++ b/drivers/media/pci/sta2x11/sta2x11_vip.c
> @@ -1,6 +1,7 @@
>   /*
>    * This is the driver for the STA2x11 Video Input Port.
>    *
> + * Copyright (C) 2012       ST Microelectronics
>    * Copyright (C) 2010       WindRiver Systems, Inc.
>    *
>    * This program is free software; you can redistribute it and/or modify it
> @@ -19,36 +20,30 @@
>    * The full GNU General Public License is included in this distribution in
>    * the file called "COPYING".
>    *
> - * Author: Andreas Kies <andreas.kies@windriver.com>
> - *		Vlad Lungu <vlad.lungu@windriver.com>


Why are you dropping those authorship data?

Ok, it is clear to me that most of the code there got rewritten, and,
while IANAL, I think they still have some copyrights on it.

So, if you're willing to do that, you need to get authors ack
on such patch.

...

>
>   MODULE_DESCRIPTION("STA2X11 Video Input Port driver");
> -MODULE_AUTHOR("Wind River");

Same note applies here: we need Wind River's ack on that to drop it.

> +MODULE_AUTHOR("Federico Vaga <federico.vaga@gmail.com>");
>   MODULE_LICENSE("GPL v2");
>   MODULE_SUPPORTED_DEVICE("sta2x11 video input");
>   MODULE_VERSION(DRV_VERSION);
>

