Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757128Ab1JRHXj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 03:23:39 -0400
Received: from mprc.pku.edu.cn ([162.105.203.9]:47955 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753257Ab1JRHXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 03:23:38 -0400
Subject: Re: [PATCH] rtc: rtc-puv3: Add __devinit and __devexit markers for
 probe and remove
From: Guan Xuetao <gxt@mprc.pku.edu.cn>
Reply-To: gxt@mprc.pku.edu.cn
To: Axel Lin <axel.lin@gmail.com>, Michal Marek <mmarek@suse.cz>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com
In-Reply-To: <1317824987.2674.1.camel@phoenix>
References: <1317824987.2674.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Organization: MPRC, PKU
Date: Tue, 18 Oct 2011 15:22:21 +0800
Message-ID: <1318922541.1789.36.camel@epip-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,
The patch yield following warnings:

WARNING: drivers/rtc/built-in.o(.data+0x90): Section mismatch in
reference from the variable puv3_rtcdrv to the
function .devinit.text:puv3_rtc_probe()
The variable puv3_rtcdrv references
the function __devinit puv3_rtc_probe()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the
variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one,
*_console

WARNING: drivers/rtc/built-in.o(.data+0x94): Section mismatch in
reference from the variable puv3_rtcdrv to the
function .devexit.text:puv3_rtc_remove()
The variable puv3_rtcdrv references
the function __devexit puv3_rtc_remove()
If the reference is valid then annotate the
variable with __exit* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one,
*_console

WARNING: drivers/built-in.o(.data+0x6c04): Section mismatch in reference
from the variable puv3_rtcdrv to the
function .devinit.text:puv3_rtc_probe()
The variable puv3_rtcdrv references
the function __devinit puv3_rtc_probe()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the
variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one,
*_console

WARNING: drivers/built-in.o(.data+0x6c08): Section mismatch in reference
from the variable puv3_rtcdrv to the
function .devexit.text:puv3_rtc_remove()
The variable puv3_rtcdrv references
the function __devexit puv3_rtc_remove()
If the reference is valid then annotate the
variable with __exit* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one,
*_console

WARNING: vmlinux.o(.data+0x1126c): Section mismatch in reference from
the variable puv3_rtcdrv to the function .devinit.text:puv3_rtc_probe()
The variable puv3_rtcdrv references
the function __devinit puv3_rtc_probe()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the
variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one,
*_console

WARNING: vmlinux.o(.data+0x11270): Section mismatch in reference from
the variable puv3_rtcdrv to the function .devexit.text:puv3_rtc_remove()
The variable puv3_rtcdrv references
the function __devexit puv3_rtc_remove()
If the reference is valid then annotate the
variable with __exit* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one,
*_console

For puv3_rtc_probe, I think it should be in the white-list, but warnings
are yielded.
For puv3_rtc_remove, the warning could be disappeared by modifying
__devexit to __exit, however is it proper?

Also,
Cc: Michal Marek <mmarek@suse.cz>
Cc: Arnd Bergmann <arnd@arndb.de>

Any advice is appreciated, thanks.

Guan Xuetao


On Wed, 2011-10-05 at 22:29 +0800, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/rtc/rtc-puv3.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/rtc/rtc-puv3.c b/drivers/rtc/rtc-puv3.c
> index b3eba3c..e4b6880 100644
> --- a/drivers/rtc/rtc-puv3.c
> +++ b/drivers/rtc/rtc-puv3.c
> @@ -220,7 +220,7 @@ static void puv3_rtc_enable(struct platform_device *pdev, int en)
>  	}
>  }
>  
> -static int puv3_rtc_remove(struct platform_device *dev)
> +static int __devexit puv3_rtc_remove(struct platform_device *dev)
>  {
>  	struct rtc_device *rtc = platform_get_drvdata(dev);
>  
> @@ -236,7 +236,7 @@ static int puv3_rtc_remove(struct platform_device *dev)
>  	return 0;
>  }
>  
> -static int puv3_rtc_probe(struct platform_device *pdev)
> +static int __devinit puv3_rtc_probe(struct platform_device *pdev)
>  {
>  	struct rtc_device *rtc;
>  	struct resource *res;


