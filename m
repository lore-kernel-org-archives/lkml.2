Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758820Ab2FEIR7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 04:17:59 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:58705 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756291Ab2FEIR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 04:17:56 -0400
Date: Tue, 5 Jun 2012 11:17:51 +0300
From: Dimitrios Semitsoglou-Tsiapos <dimitrios.semitsoglou@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] staging: comedi: cb_pcidas64: Fixed an if-statement
 check
Message-ID: <20120605081751.GA25855@remilia>
References: <1338229715-2730-1-git-send-email-dimitrios.semitsoglou@gmail.com>
 <1338241905-24327-1-git-send-email-dimitrios.semitsoglou@gmail.com>
 <1338241905-24327-2-git-send-email-dimitrios.semitsoglou@gmail.com>
 <20120605034318.GA28810@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120605034318.GA28810@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2012 at 08:43:18PM -0700, Greg KH wrote:
> On Tue, May 29, 2012 at 12:51:45AM +0300, Dimitrios Semitsoglou-Tsiapos wrote:
> > Fixed in if-statemnt responsible for a sanity check inside the
> > prep_ao_dma function.
> > 
> > Signed-off-by: Dimitrios Semitsoglou-Tsiapos <dimitrios.semitsoglou@gmail.com>
> > ---
> >  drivers/staging/comedi/drivers/cb_pcidas64.c |    4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/staging/comedi/drivers/cb_pcidas64.c b/drivers/staging/comedi/drivers/cb_pcidas64.c
> > index 6f7fd99..a2e6f96 100644
> > --- a/drivers/staging/comedi/drivers/cb_pcidas64.c
> > +++ b/drivers/staging/comedi/drivers/cb_pcidas64.c
> > @@ -3392,8 +3392,8 @@ static int prep_ao_dma(struct comedi_device *dev, const struct comedi_cmd *cmd)
> >  	num_bytes = load_ao_dma_buffer(dev, cmd);
> >  	if (num_bytes == 0)
> >  		return -1;
> > -	if (num_bytes >= DMA_BUFFER_SIZE) ;
> > -	load_ao_dma(dev, cmd);
> > +	if (num_bytes >= DMA_BUFFER_SIZE)
> > +		load_ao_dma(dev, cmd);
> 
> Are you sure about this change?  I think someone forgot to include an
> error check here, the driver was working with this function always being
> called, and now you only do it for the extreme case.
> 
> Have you checked it somehow?
> 
> thanks,
> 
> greg k-h
You are correct. I had misread load_ao_dma's loop as a while loop.
I'm afraid I did not have a way to test this and it does seem that it
should *not* be included.

Regards,
Dimitrios Semitsoglou-Tsiapos
