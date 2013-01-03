Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093Ab3ACIKT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 03:10:19 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:64583 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422Ab3ACIKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 03:10:18 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 1/2] timer: vt8500: Move system timer to clocksource
Date: Thu, 3 Jan 2013 08:07:53 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Tony Prisk <linux@prisktech.co.nz>, Olof Johansson <olof@lixom.net>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
References: <1357183510-8476-1-git-send-email-linux@prisktech.co.nz> <20130103073540.GB11309@core.coreip.homeip.net> <1357199114.25181.48.camel@joe-AO722>
In-Reply-To: <1357199114.25181.48.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201301030807.53550.arnd@arndb.de>
X-Provags-ID: V02:K0:iEkOnWkmEhz8UmNpZm/PwocdXoYlYLR38+JCzHvFlZu
 xBBHrSHHmuxHZhKkJRjFPKCMYI0sqbo3uV2Uzi1gcfV9+08BWz
 JxwyApSFQYtHc/bBAPHhdhYk2tAHpd/vwZVyeSX0INGqj1i/Xr
 7GYkuBlThSIp6+Jl5+apR0KZJ/c9jzomd5BGax67jjuJi7EKNg
 /AGNx/BEohSusYWIProl6vRQwwa8aNiMO/gTVMJKHfYvcd2rwo
 wyPOYc0gKeSBFi015WP+hl5ehWa5mcak3qPFTFiNUEctCOG92X
 Ya1QsBBBBnwCwF71ugqkdjxdJ/Cy9G+YSmCGPk4qJjxF/sQUBv
 5swFkigFVp2PCoGp73WQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 January 2013, Joe Perches wrote:
> Also I think it'd be nicer to write something like:
> 
>         struct device_node *np;
>         int timer_irq;
>         const char *reason;
> 
>         np = of_find_matching_node(NULL, vt8500_timer_ids);
>         if (!np) {
>                 reason = "timer";
>             goto error;
>         }
>         regbase = of_iomap(np, 0);
>         if (!regbase) {
>                 reason = "iobase";
>                 goto error_put;
>         }
>         timer_irq = irq_of_parse_and_map(np, 0);
>         if (!timer_irq) {
>                 reason = "irq";
>                 goto error_remap;
>         }
>  
>         ...
> 
> error_remap:
>         unmap...;
> error_put:
>         of_node_put(np);
> error:
>         pr_err("%s: Missing %s description in Device Tree\n",
>                __func__, reason);
>         return;

Right, but that would be a separate cleanup patch, since the patch that
Tony posted is just supposed to move the code around and change as little
else as possible in the process. The cleanup can come either right before
or right after the move.

	Arnd
