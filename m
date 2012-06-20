Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758296Ab2FTXIp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 19:08:45 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46130 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757832Ab2FTXIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 19:08:43 -0400
Date: Wed, 20 Jun 2012 16:08:39 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Devendra Naga <devendra.aaru@gmail.com>
Cc: "Justin P. Mattock" <justinmattock@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 1/3] staging/rtl8192u: fix coding style problems
Message-ID: <20120620230839.GA17883@kroah.com>
References: <1340132742-18849-1-git-send-email-devendra.aaru@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340132742-18849-1-git-send-email-devendra.aaru@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2012 at 12:35:42AM +0530, Devendra Naga wrote:
> fixed some of the coding style problems reported by checkpatch
> 
> Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
> ---
>  drivers/staging/rtl8192u/r8180_93cx6.c |   36 +++++++++++++++++---------------
>  1 file changed, 19 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/staging/rtl8192u/r8180_93cx6.c b/drivers/staging/rtl8192u/r8180_93cx6.c
> index 3c515b7..19f5270 100644
> --- a/drivers/staging/rtl8192u/r8180_93cx6.c
> +++ b/drivers/staging/rtl8192u/r8180_93cx6.c
> @@ -22,13 +22,16 @@
>  
>  void eprom_cs(struct net_device *dev, short bit)
>  {
> -	if(bit)
> +	if (bit) {
> +		/* enable EPROM */
>  		write_nic_byte_E(dev, EPROM_CMD,
> -			       (1<<EPROM_CS_SHIFT) | \
> -			       read_nic_byte_E(dev, EPROM_CMD)); //enable EPROM
> -	else
> -		write_nic_byte_E(dev, EPROM_CMD, read_nic_byte_E(dev, EPROM_CMD)\
> -			       &~(1<<EPROM_CS_SHIFT)); //disable EPROM
> +				(1<<EPROM_CS_SHIFT) |
> +				read_nic_byte_E(dev, EPROM_CMD));
> +	} else {
> +		/* disable EPROM */
> +		write_nic_byte_E(dev, EPROM_CMD, read_nic_byte_E(dev, EPROM_CMD)
> +			       & ~(1<<EPROM_CS_SHIFT));
> +	}
>  
>  	force_pci_posting(dev);
>  	udelay(EPROM_DELAY);
> @@ -38,24 +41,24 @@ void eprom_cs(struct net_device *dev, short bit)
>  void eprom_ck_cycle(struct net_device *dev)
>  {
>  	write_nic_byte_E(dev, EPROM_CMD,
> -		       (1<<EPROM_CK_SHIFT) | read_nic_byte_E(dev,EPROM_CMD));
> +		       (1<<EPROM_CK_SHIFT) | read_nic_byte_E(dev, EPROM_CMD));
>  	force_pci_posting(dev);
>  	udelay(EPROM_DELAY);
>  	write_nic_byte_E(dev, EPROM_CMD,
> -		       read_nic_byte_E(dev, EPROM_CMD) &~ (1<<EPROM_CK_SHIFT));
> +		       read_nic_byte_E(dev, EPROM_CMD) & ~(1<<EPROM_CK_SHIFT));
>  	force_pci_posting(dev);
>  	udelay(EPROM_DELAY);
>  }
>  
>  
> -void eprom_w(struct net_device *dev,short bit)
> +void eprom_w(struct net_device *dev, short bit)
>  {
> -	if(bit)
> -		write_nic_byte_E(dev, EPROM_CMD, (1<<EPROM_W_SHIFT) | \
> -			       read_nic_byte_E(dev,EPROM_CMD));
> +	if (bit)
> +		write_nic_byte_E(dev, EPROM_CMD, (1<<EPROM_W_SHIFT) |
> +			       read_nic_byte_E(dev, EPROM_CMD));
>  	else
> -		write_nic_byte_E(dev, EPROM_CMD, read_nic_byte_E(dev,EPROM_CMD)\
> -			       &~(1<<EPROM_W_SHIFT));
> +		write_nic_byte_E(dev, EPROM_CMD, read_nic_byte_E(dev, EPROM_CMD)
> +			       & ~(1<<EPROM_W_SHIFT));
>  
>  	force_pci_posting(dev);
>  	udelay(EPROM_DELAY);
> @@ -66,11 +69,10 @@ short eprom_r(struct net_device *dev)
>  {
>  	short bit;
>  
> -	bit=(read_nic_byte_E(dev, EPROM_CMD) & (1<<EPROM_R_SHIFT) );
> +	bit = (read_nic_byte_E(dev, EPROM_CMD) & (1<<EPROM_R_SHIFT));
>  	udelay(EPROM_DELAY);
>  
> -	if(bit) return 1;
> -	return 0;
> +	return !!bit;

Oh come on, really?  !! is more "clear" here?

No, please be painfully obvious, that's the only way to write kernel
code.  Not like this.

greg k-h
