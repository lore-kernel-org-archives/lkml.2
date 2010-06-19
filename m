Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755675Ab0FSMhA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 08:37:00 -0400
Received: from isilmar-3.linta.de ([188.40.101.200]:52006 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755602Ab0FSMg7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 08:36:59 -0400
Date: Sat, 19 Jun 2010 14:30:04 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Patrick McHardy <kaber@trash.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: pcmcia: fix 'driver ... did not release config properly'
 warning
Message-ID: <20100619123004.GA5575@comet.dominikbrodowski.net>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Patrick McHardy <kaber@trash.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <4C198CA7.4050204@trash.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C198CA7.4050204@trash.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Applied, thanks.

Best,
	Doinik

On Thu, Jun 17, 2010 at 04:47:03AM +0200, Patrick McHardy wrote:
> 

> commit b1be4845dffefe212959ee02b783571eead3e350
> Author: Patrick McHardy <kaber@trash.net>
> Date:   Thu Jun 17 04:43:07 2010 +0200
> 
>     pcmcia: fix 'driver ... did not release config properly' warning
>     
>     Up to 2.6.34 pcmcia_release_irq() reset p_dev->_irq to 0 after releasing
>     the irq. The IRQ is now released in pcmcia_disable_device(), however
>     p_dev->_irq is not reset, triggering a warning in pcmcia_device_remove().
>     
>     Signed-off-by: Patrick McHardy <kaber@trash.net>
> 
> diff --git a/drivers/pcmcia/pcmcia_resource.c b/drivers/pcmcia/pcmcia_resource.c
> index 29f91fa..a4cd9ad 100644
> --- a/drivers/pcmcia/pcmcia_resource.c
> +++ b/drivers/pcmcia/pcmcia_resource.c
> @@ -857,8 +857,10 @@ void pcmcia_disable_device(struct pcmcia_device *p_dev)
>  {
>  	pcmcia_release_configuration(p_dev);
>  	pcmcia_release_io(p_dev, &p_dev->io);
> -	if (p_dev->_irq)
> +	if (p_dev->_irq) {
>  		free_irq(p_dev->irq, p_dev->priv);
> +		p_dev->_irq = 0;
> +	}
>  	if (p_dev->win)
>  		pcmcia_release_window(p_dev, p_dev->win);
>  }

