Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943Ab1KBJ3k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 05:29:40 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:56341 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760Ab1KBJ3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 05:29:38 -0400
Date: Wed, 2 Nov 2011 10:29:35 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux-sh list <linux-sh@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH 1/3] PM / Sleep: Mark devices involved in wakeup signaling
 during suspend
In-Reply-To: <201110200013.56428.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.64.1111021015350.18080@axis700.grange>
References: <201110200012.43840.rjw@sisk.pl> <201110200013.56428.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:R38ONOs2IPhhVHEQKo4UVu5dx7hyIS13am+hFrDGvLW
 etdEAZH15ibMwyApQHp00co3aYkzBf3SAjdJmBdJITu6bDWWY0
 JPWbQzorRahaQxpZTp+rthY7zNrhotsA1I0VAzV1V+pMpYX3wG
 4doFDcXBzS1QUcwM8krafRoE0bLrinI42cY2T3AefXzIw5flM7
 CdYOFiEDTwBkI6ulHYNLSPzVwzTfQuBGwzeSpZFYuGZMSEBXEU
 4qta5xgQbgqTJwGxvN12ZWNUklOqXPS+A+sMW0AtQIy74BPsFm
 PMLEL75mjcZS1B1ZqKR7ewzrPrUvcqJZM3ipqSCPFClXoh9rB/
 HIm/g72cvoYGZv9OUIrA2RNtGuBIW2AGSpKten5/cDeNu/GLBR
 ItwaUom1pCAQQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael

Just something, that made me wonder:

On Thu, 20 Oct 2011, Rafael J. Wysocki wrote:

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> The generic PM domains code in drivers/base/power/domain.c has
> to avoid powering off domains that provide power to wakeup devices
> during system suspend.  Currently, however, this only works for
> wakeup devices directly belonging to the given domain and not for
> their children (or the children of their children and so on).
> Thus, if there's a wakeup device whose parent belongs to a power
> domain handled by the generic PM domains code, the domain will be
> powered off during system suspend preventing the device from
> signaling wakeup.
> 
> To address this problem introduce a device flag, power.wakeup_path,
> that will be set during system suspend for all wakeup devices,
> their parents, the parents of their parents and so on.  This way,
> all wakeup paths in the device hierarchy will be marked and the
> generic PM domains code will only need to avoid powering off
> domains containing devices whose power.wakeup_path is set.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  drivers/base/power/domain.c |    4 ++--
>  drivers/base/power/main.c   |    8 +++++++-
>  include/linux/pm.h          |    1 +
>  3 files changed, 10 insertions(+), 3 deletions(-)

[snip]

> Index: linux/include/linux/pm.h
> ===================================================================
> --- linux.orig/include/linux/pm.h
> +++ linux/include/linux/pm.h
> @@ -452,6 +452,7 @@ struct dev_pm_info {
>  	struct list_head	entry;
>  	struct completion	completion;
>  	struct wakeup_source	*wakeup;
> +	bool			wakeup_path:1;

This is an interesting idea... I'd presume, the compiler is aware, that 
one bit is enough for "bool," so, it should choose an optimal 
implementation by itself? I checked gcc 4.4.1 on ARM - without the 
bitfield notation the compiler just uses one byte in my example. Anyway, 
not a request-for-change, just wondering whether you really were trying to 
(potentially) save a couple of bits here or what was the motivation.

>  #else
>  	unsigned int		should_wakeup:1;
>  #endif

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
