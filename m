Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967143Ab2EPAU5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 20:20:57 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:53962 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966737Ab2EPAUz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 20:20:55 -0400
MIME-Version: 1.0
In-Reply-To: <1337013111-7732-1-git-send-email-tartler@cs.fau.de>
References: <1337013111-7732-1-git-send-email-tartler@cs.fau.de>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Wed, 16 May 2012 08:20:31 +0800
Message-ID: <CAMPhdO_B_CM2cupu2r-FMcm69CEkUttFiSbaMb+M_1rX5=Pxww@mail.gmail.com>
Subject: Re: [PATCH] mbxfb: unbreak compilation with CONFIG_FB_MBX_DEBUG
To: tartler@cs.fau.de
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Arnd Bergmann <arnd@arndb.de>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, vamos-dev@lists.cs.fau.de,
        Reinhard Tartler <siretart@tauware.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2012 at 12:31 AM,  <tartler@cs.fau.de> wrote:
> From: Reinhard Tartler <siretart@tauware.de>
>
> This patch adds missing function prototypes.
>
> Signed-off-by: Reinhard Tartler <tartler@cs.fau.de>
> ---
>  drivers/video/mbx/mbxfb.c |    3 +++
>  1 file changed, 3 insertions(+)
>
> This patch was found with tools developed in the VAMOS project:
> http://www4.cs.fau.de/Research/VAMOS/
>
> TBH, I'm not sure if this is the correct solution. However, I'd
> appreciate if someone could confirm that this is a real bug.

This looks to be a correct solution to me.

Acked-by: Eric Miao <eric.y.miao@gmail.com>

>
>
> diff --git a/drivers/video/mbx/mbxfb.c b/drivers/video/mbx/mbxfb.c
> index 6ce3416..c2200ec 100644
> --- a/drivers/video/mbx/mbxfb.c
> +++ b/drivers/video/mbx/mbxfb.c
> @@ -878,6 +878,9 @@ static int mbxfb_resume(struct platform_device *dev)
>  #ifndef CONFIG_FB_MBX_DEBUG
>  #define mbxfb_debugfs_init(x)  do {} while(0)
>  #define mbxfb_debugfs_remove(x)        do {} while(0)
> +#else
> +void mbxfb_debugfs_init(struct fb_info *fbi);
> +void mbxfb_debugfs_remove(struct fb_info *fbi);
>  #endif
>
>  #define res_size(_r) (((_r)->end - (_r)->start) + 1)
> --
> 1.7.9.5
>
