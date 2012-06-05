Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751530Ab2FETPk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 15:15:40 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:59623 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750898Ab2FETPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 15:15:38 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1+byUA94kWbeQI8UWbhSJdoqKbJVpL1YlVnWhqiwZ
	npEgntWcXMeaJ8
Message-ID: <4FCE5AD1.6040705@gmx.de>
Date: Tue, 05 Jun 2012 19:15:29 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120506 Icedove/3.0.11
MIME-Version: 1.0
To: tartler@cs.fau.de
CC: Eric Miao <eric.y.miao@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        vamos-dev@lists.cs.fau.de, Reinhard Tartler <siretart@tauware.de>
Subject: Re: [PATCH] mbxfb: unbreak compilation with CONFIG_FB_MBX_DEBUG
References: <1337013111-7732-1-git-send-email-tartler@cs.fau.de>
In-Reply-To: <1337013111-7732-1-git-send-email-tartler@cs.fau.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 05/14/2012 04:31 PM, tartler@cs.fau.de wrote:
> From: Reinhard Tartler <siretart@tauware.de>
> 
> This patch adds missing function prototypes.
> 
> Signed-off-by: Reinhard Tartler <tartler@cs.fau.de>
> ---
>  drivers/video/mbx/mbxfb.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> This patch was found with tools developed in the VAMOS project:
> http://www4.cs.fau.de/Research/VAMOS/
> 
> TBH, I'm not sure if this is the correct solution. However, I'd
> appreciate if someone could confirm that this is a real bug.
> 
> 
> diff --git a/drivers/video/mbx/mbxfb.c b/drivers/video/mbx/mbxfb.c
> index 6ce3416..c2200ec 100644
> --- a/drivers/video/mbx/mbxfb.c
> +++ b/drivers/video/mbx/mbxfb.c
> @@ -878,6 +878,9 @@ static int mbxfb_resume(struct platform_device *dev)
>  #ifndef CONFIG_FB_MBX_DEBUG
>  #define mbxfb_debugfs_init(x)	do {} while(0)
>  #define mbxfb_debugfs_remove(x)	do {} while(0)
> +#else
> +void mbxfb_debugfs_init(struct fb_info *fbi);
> +void mbxfb_debugfs_remove(struct fb_info *fbi);

I don't agree. checkpatch complains
WARNING: externs should be avoided in .c files
#71: FILE: drivers/video/mbx/mbxfb.c:882:
+void mbxfb_debugfs_init(struct fb_info *fbi);

And in drivers/video/mbx/mbxdebugfs.c
static void __devinit mbxfb_debugfs_init(struct fb_info *fbi)
static void __devexit mbxfb_debugfs_remove(struct fb_info *fbi)

So even if you want to ignore the checkpatch warning (which I could
understand for just 2 includes even if headers are certainly better)
you'd have to remove the static at the implementation and for
consistency include the __devinit/exit in your prototypes.

>  #endif
>  
>  #define res_size(_r) (((_r)->end - (_r)->start) + 1)


Best regards,

Florian Tobias Schandinat
