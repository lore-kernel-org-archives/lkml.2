Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759529Ab2FEGdm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 02:33:42 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:41969 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753693Ab2FEGdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 02:33:41 -0400
Date: Mon, 4 Jun 2012 20:43:18 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Dimitrios Semitsoglou-Tsiapos <dimitrios.semitsoglou@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] staging: comedi: cb_pcidas64: Fixed an if-statement
 check
Message-ID: <20120605034318.GA28810@kroah.com>
References: <1338229715-2730-1-git-send-email-dimitrios.semitsoglou@gmail.com>
 <1338241905-24327-1-git-send-email-dimitrios.semitsoglou@gmail.com>
 <1338241905-24327-2-git-send-email-dimitrios.semitsoglou@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338241905-24327-2-git-send-email-dimitrios.semitsoglou@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2012 at 12:51:45AM +0300, Dimitrios Semitsoglou-Tsiapos wrote:
> Fixed in if-statemnt responsible for a sanity check inside the
> prep_ao_dma function.
> 
> Signed-off-by: Dimitrios Semitsoglou-Tsiapos <dimitrios.semitsoglou@gmail.com>
> ---
>  drivers/staging/comedi/drivers/cb_pcidas64.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/comedi/drivers/cb_pcidas64.c b/drivers/staging/comedi/drivers/cb_pcidas64.c
> index 6f7fd99..a2e6f96 100644
> --- a/drivers/staging/comedi/drivers/cb_pcidas64.c
> +++ b/drivers/staging/comedi/drivers/cb_pcidas64.c
> @@ -3392,8 +3392,8 @@ static int prep_ao_dma(struct comedi_device *dev, const struct comedi_cmd *cmd)
>  	num_bytes = load_ao_dma_buffer(dev, cmd);
>  	if (num_bytes == 0)
>  		return -1;
> -	if (num_bytes >= DMA_BUFFER_SIZE) ;
> -	load_ao_dma(dev, cmd);
> +	if (num_bytes >= DMA_BUFFER_SIZE)
> +		load_ao_dma(dev, cmd);

Are you sure about this change?  I think someone forgot to include an
error check here, the driver was working with this function always being
called, and now you only do it for the extreme case.

Have you checked it somehow?

thanks,

greg k-h
