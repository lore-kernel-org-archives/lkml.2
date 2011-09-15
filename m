Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933671Ab1IOM7H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 08:59:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32913 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933338Ab1IOM7F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 08:59:05 -0400
Date: Thu, 15 Sep 2011 14:59:03 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH][Resend] viacam: Don't explode if pci_find_bus() returns
 NULL
In-Reply-To: <alpine.LNX.2.00.1108012337070.31999@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1109151458550.13109@pobox.suse.cz>
References: <alpine.LNX.2.00.1108012337070.31999@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Aug 2011, Jesper Juhl wrote:

> In the unlikely case that pci_find_bus() should return NULL
> viacam_serial_is_enabled() is going to dereference a NULL pointer and
> blow up. Better safe than sorry, so be defensive and check the
> pointer.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> Acked-by: Jonathan Corbet <corbet@lwn.net>
> ---
>  drivers/media/video/via-camera.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/via-camera.c b/drivers/media/video/via-camera.c
> index 85d3048..bb7f17f 100644
> --- a/drivers/media/video/via-camera.c
> +++ b/drivers/media/video/via-camera.c
> @@ -1332,6 +1332,8 @@ static __devinit bool viacam_serial_is_enabled(void)
>  	struct pci_bus *pbus = pci_find_bus(0, 0);
>  	u8 cbyte;
>  
> +	if (!pbus)
> +		return false;
>  	pci_bus_read_config_byte(pbus, VIACAM_SERIAL_DEVFN,
>  			VIACAM_SERIAL_CREG, &cbyte);
>  	if ((cbyte & VIACAM_SERIAL_BIT) == 0)

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs
