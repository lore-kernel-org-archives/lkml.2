Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933784Ab2LIKVl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 05:21:41 -0500
Received: from server.prisktech.co.nz ([115.188.14.127]:64736 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933754Ab2LIKVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 05:21:40 -0500
Message-ID: <1355048513.9812.7.camel@gitbox>
Subject: Re: [PATCH] drivers/video/wm8505fb.c: use devm_ functions
From: Tony Prisk <linux@prisktech.co.nz>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: linux-fbdev@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Date: Sun, 09 Dec 2012 23:21:53 +1300
In-Reply-To: <alpine.DEB.2.02.1212090820270.2028@localhost6.localdomain6>
References: <1354984288-773-1-git-send-email-Julia.Lawall@lip6.fr>
	 <1355002958.14981.11.camel@gitbox>
	 <alpine.DEB.2.02.1212090820270.2028@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-12-09 at 08:21 +0100, Julia Lawall wrote:
> > Rather than the goto, add the fail path code in directly, and return.
> >
> >
> > ret = register_framebuffer(&fbi->fb);
> > if (ret < 0) {
> >  dev_err(&pdev->dev,
> >  "Failed to register framebuffer device: %d\n", ret);
> >  if (fbi->fb.cmap.len)
> >    fb_dealloc_cmap(&fbi->fb.cmap);
> >  return ret;
> > }
> 
> So there is no need for the platform_set_drvdata(pdev, NULL); ?

Unless there is some kind of reference counting, I can't see any reason
for this.

> 
> Also, do you know if it is correct that the original code does not include
> a call to dma_free_coherent?

No, that is not correct - there definitely should be a
dma_free_coherent, both in the fail path and in the remove(). Appears
they are both missing.

Regards
Tony P

