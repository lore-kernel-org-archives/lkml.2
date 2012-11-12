Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932Ab2KLNu2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 08:50:28 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:53735 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804Ab2KLNu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 08:50:26 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Vineet.Gupta1@synopsys.com
Subject: Re: [RFC Patch v1 32/55] ARC: [optim] Cache "current" in Register r25
Date: Mon, 12 Nov 2012 13:50:12 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de
References: <1352720953-24321-1-git-send-email-vgupta@synopsys.com> <1352720953-24321-2-git-send-email-vgupta@synopsys.com>
In-Reply-To: <1352720953-24321-2-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201211121350.12810.arnd@arndb.de>
X-Provags-ID: V02:K0:SakyMoYJpw5HNPNuhQPhr21GMPdNIaubLT6MpGaL5Ab
 Kk7X8qs4SKwQjvcouLs7VW7uh5wy/ZSr5bxDuhZuQX8zzNjbnv
 oYZfNoAvuCQqj0VNTApeZdyqCTsUn5L9dmg0zvh7HpohHtDuIw
 N4bHcmxQtk4fP+uYYAFRF/Z5lhWpXetN27w0MjaFEnH+x0t0DE
 Xn9+Xdb1q7FBNtVhmg1yiYkcoAsrchFGHcWg6sBOmHvcALjSkA
 GJ24N7hCBwD9Um2Vp3qMxITu06puiNk4DPFjaCj2ODCfXq3MKn
 FbolvEcK5QXhx6W/bI9fmooTSpqdy/vsRvoTtLCwtkCQL0+7Ro
 WLDTHXSP3RJOIJAZk9Bg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 November 2012, Vineet.Gupta1@synopsys.com wrote:
> 
>  endmenu # "Platform Board Configuration"
>  
> +config ARC_CURR_IN_REG
> +       bool "Dedicate Register r25 for current_task pointer"
> +       default y
> +       help
> +         This reserved Register R25 to point to Current Task in
> +         kernel mode. This saves memory access for each such access
> +

This looks like a useful feature if you have 32 GPRs, but why make it
optional? Are there cases where you would disable it?

Another alternative to caching "current" would be to cache the per-cpu
offset, and calculate current from that one.

	Arnd
