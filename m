Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160Ab2FXVYV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 17:24:21 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:40571 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753609Ab2FXVYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 17:24:19 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1+9D3cwFEi928TjF4qlfxoVD+DXtNU9I036V+BpAV
	uxKyIjt8MFhwDm
Message-ID: <4FE78582.5080503@gmx.de>
Date: Sun, 24 Jun 2012 21:24:18 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120506 Icedove/3.0.11
MIME-Version: 1.0
To: Paul Parsons <lost.distance@yahoo.com>
CC: mreimer@sdgsystems.com, philipp.zabel@gmail.com,
        linux-kernel@vger.kernel.org,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>
Subject: Re: [PATCH RESEND] video: w100fb: Reduce sleep mode battery discharge
References: <20120603103355.3845gmx1@mx072.gmx.net>
In-Reply-To: <20120603103355.3845gmx1@mx072.gmx.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

you should als the relevant mailing list, linux-fbdev (done now)

On 06/03/2012 10:33 AM, Paul Parsons wrote:
> In 2006 and 2007 the handhelds.org kernel w100fb driver was patched to
> reduce sleep mode battery discharge. Unfortunately those two patches
> never migrated to the mainline kernel.
> 
> Fortunately the function affected - w100_suspend() - has not changed
> since; thus those patches still apply cleanly.
> 
> Applying those patches to linux-3.4-rc3 running on an HP iPAQ hx4700
> reduces the sleep mode battery discharge from approximately 26 mA to
> approximately 11 mA.
> 
> This patch combines those two patches into a single unified patch.
> 
> Signed-off-by: Paul Parsons <lost.distance@yahoo.com>
> Cc: Matt Reimer <mreimer@sdgsystems.com>
> Cc: Philipp Zabel <philipp.zabel@gmail.com>

Actually it would be good if we had the Signed-offs of the original
authors. Oh well, I think if it can't be helped yours should be sufficient.

> ---
> 
> Many thanks to Matt Reimer for suggesting this.
> 
> The seeming demise of handhelds.org has removed any formal patch logs.
> However the patches can still be viewed online:
> 2006 patch:
> http://paste.lisp.org/display/31700
> 2007 patch:
> http://osdir.com/ml/handhelds.linux.kernel/2007-02/msg00020.html
> 
> And the fully patched handhelds.org kernel is still available, e.g.:
> http://www.linuxtogo.org/~goxboxlive/htcuniversal/Kernel/linux-2.6.21-hh20.tar.bz2
> 
>  drivers/video/w100fb.c |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/video/w100fb.c b/drivers/video/w100fb.c
> index 90a2e30..2f6b2b8 100644
> --- a/drivers/video/w100fb.c
> +++ b/drivers/video/w100fb.c
> @@ -1567,6 +1567,18 @@ static void w100_suspend(u32 mode)
>  		val = readl(remapped_regs + mmPLL_CNTL);
>  		val |= 0x00000004;  /* bit2=1 */
>  		writel(val, remapped_regs + mmPLL_CNTL);
> +
> +		writel(0x00000000, remapped_regs + mmLCDD_CNTL1);
> +		writel(0x00000000, remapped_regs + mmLCDD_CNTL2);
> +		writel(0x00000000, remapped_regs + mmGENLCD_CNTL1);
> +		writel(0x00000000, remapped_regs + mmGENLCD_CNTL2);
> +		writel(0x00000000, remapped_regs + mmGENLCD_CNTL3);
> +
> +		val = readl(remapped_regs + mmMEM_EXT_CNTL);
> +		val |= 0xF0000000;
> +		val &= ~(0x00000001);
> +		writel(val, remapped_regs + mmMEM_EXT_CNTL);
> +

If anyone understands what this change does (like for example disabling
the LCD controller) a comment would be useful.

>  		writel(0x0000001d, remapped_regs + mmPWRMGT_CNTL);
>  	}
>  }

If nobody comments on this I will apply it in a few days.


Best regards,

Florian Tobias Schandinat
