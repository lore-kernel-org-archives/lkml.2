Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792Ab2E2GVV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 02:21:21 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:22850 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291Ab2E2GVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 02:21:19 -0400
Date: Tue, 29 May 2012 09:21:07 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Emil Goode <emilgoode@gmail.com>
Cc: FlorianSchandinat@gmx.de, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v2] video: bfin_adv7393fb: Fix cleanup code
Message-ID: <20120529062107.GA21008@mwanda>
References: <1338224091-8322-1-git-send-email-emilgoode@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338224091-8322-1-git-send-email-emilgoode@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 28, 2012 at 06:54:51PM +0200, Emil Goode wrote:
> This patch fixes the cleanup code of the bfin_adv7393_fb_probe
> function.
> 
> 1) The resources were not freed in the order that we allocated them
>    so we call dma_free_coherent() before it was allocated.
> 2) The labels weren't in the right place which also meant that we
>    freed resources that weren't allocated.
> 3) We should free gpio_free(P_IDENT(P_PPI0_FS3)) before returning.
> 4) Lets change the label names into something more meaningful.
> 
> Signed-off-by: Emil Goode <emilgoode@gmail.com>
> ---

Yep.  Looks great.

I see the goto free_ppi_pins;  I look up a couple lines.  I see that
yeah, it makes sense to free the ppi_pins.  I hit the '*' key in vim
I see that the label does exactly what it says.  Move on.

Bing.  Bang.  Boom.

regards,
dan carpenter

