Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964836Ab2LIHVj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 02:21:39 -0500
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:24142
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756214Ab2LIHVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 02:21:37 -0500
X-IronPort-AV: E=Sophos;i="4.84,246,1355094000"; 
   d="scan'208";a="165230239"
Date: Sun, 9 Dec 2012 08:21:33 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Tony Prisk <linux@prisktech.co.nz>
cc: Julia Lawall <Julia.Lawall@lip6.fr>, linux-fbdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: Re: [PATCH] drivers/video/wm8505fb.c: use devm_ functions
In-Reply-To: <1355002958.14981.11.camel@gitbox>
Message-ID: <alpine.DEB.2.02.1212090820270.2028@localhost6.localdomain6>
References: <1354984288-773-1-git-send-email-Julia.Lawall@lip6.fr> <1355002958.14981.11.camel@gitbox>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Rather than the goto, add the fail path code in directly, and return.
>
>
> ret = register_framebuffer(&fbi->fb);
> if (ret < 0) {
>  dev_err(&pdev->dev,
>  "Failed to register framebuffer device: %d\n", ret);
>  if (fbi->fb.cmap.len)
>    fb_dealloc_cmap(&fbi->fb.cmap);
>  return ret;
> }

So there is no need for the platform_set_drvdata(pdev, NULL); ?

Also, do you know if it is correct that the original code does not include
a call to dma_free_coherent?

thanks,
julia
