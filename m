Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758693Ab2KWBS7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 20:18:59 -0500
Received: from mga14.intel.com ([143.182.124.37]:60502 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758444Ab2KWBS5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 20:18:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,304,1352102400"; 
   d="scan'208";a="221242485"
Subject: Re: [PATCH] serial:ifx6x60:Delete SPI timer when shut down port
From: chao bi <chao.bi@intel.com>
To: Alan Cox <alan@linux.intel.com>
Cc: richardx.r.gorby@intel.com, jun.d.chen@intel.com,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20121122110640.3fd5ef9b@bob.linux.org.uk>
References: <1353573787.22077.8.camel@bichao>
	 <20121122110640.3fd5ef9b@bob.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Nov 2012 09:25:09 +0800
Message-ID: <1353633909.22077.12.camel@bichao>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-11-22 at 11:06 +0000, Alan Cox wrote:
> > --- a/drivers/tty/serial/ifx6x60.c
> > +++ b/drivers/tty/serial/ifx6x60.c
> > @@ -552,7 +552,10 @@ static void ifx_port_shutdown(struct tty_port
> > *port) container_of(port, struct ifx_spi_device, tty_port);
> >  
> >  	mrdy_set_low(ifx_dev);
> > -	clear_bit(IFX_SPI_STATE_TIMER_PENDING, &ifx_dev->flags);
> > +	if (test_and_clear_bit(IFX_SPI_STATE_TIMER_PENDING,
> > +		&ifx_dev->flags)) {
> > +		del_timer(&ifx_dev->spi_timer);
> > +	}
> 
> You don't actually need the test here as far as I can see. Providing a
> timer has been initialised (init_timer) then running del_timer is safe
> even if the timer is not currently queued or has completed.
> 
> Alan

Yes, thanks. I'll update it.

