Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756433Ab1KNWFV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 17:05:21 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:47385 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755094Ab1KNWFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 17:05:17 -0500
X-Sasl-enc: R5zZTvZqN/Uv1hGBqHy4IbUjROrvke1a0zNl97/j5nin 1321308316
Date: Mon, 14 Nov 2011 13:54:55 -0800
From: Greg KH <greg@kroah.com>
To: Andrew Worsley <amworsley@gmail.com>
Cc: Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Uwe Bonnes <bon@elektron.ikp.physik.tu-darmstadt.de>,
        Johan Hovold <jhovold@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix Corruption issue in USB ftdi driver
 drivers/usb/serial/ftdi_sio.c
Message-ID: <20111114215455.GA16018@kroah.com>
References: <CA+Y=x3=xEa6XVspsodhbKOArtZ7VMYSMLhpF4WZ1sFNfaJ_E9g@mail.gmail.com>
 <20111101113607.15b254c6@bob.linux.org.uk>
 <CA+Y=x3k+jxN7LEk64mHkFQkkQhWa_KX7Uh+Uwuk0u87c+FiG_Q@mail.gmail.com>
 <20111102113104.3a641f7a@bob.linux.org.uk>
 <CA+Y=x3=iPBW4UcWbsD2VX3nfbxwMBCwAYS4176iseZ-Niy+oKw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+Y=x3=iPBW4UcWbsD2VX3nfbxwMBCwAYS4176iseZ-Niy+oKw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 03, 2011 at 04:06:31PM +1100, Andrew Worsley wrote:
> Avoid unnecessary Control URBs that reset the data/parity or baud rate
> to the currently set settings which can cause the FTDI chip to glitch
> it's serial output and cause a corruption of a character it is
> currently outputting.
> 
> Signed-off-by: amworsley@gmail.com
> 
> ---
> 
> ....
> > It shouldn't be unless the apps you are running are doing odd things.
> > I'd not expect parity to keep changing certainly. What may be occuring
> > is that some of these devices only handle RTS/CTS flow and force the
> > flag on, indicating it back to the app. If the app ignores that then it
> > may end up trying to clear it several times.
> 
> Okay - Thanks I will try stracing the process and see if it is issuing
> all the requests. I thought
> it might be the line discipline trying to flow control the input. I've
> lost my box for the moment so that
> will be tomorrow perhaps.
> 
> ....
> 
> >> +
> >>         /* NOTE These routines can get interrupted by
> >>            ftdi_sio_read_bulk_callback  - need to examine what this
> >> means - don't see any problems yet */
> >>
> >> +    if ((old_termios->c_cflag & (CSIZE|PARODD|CSTOPB|PARODD)) ==
> >> +        (termios->c_cflag & (CSIZE|PARODD|CSTOPB|PARODD)))
> >
> > I think you need
> >
> > CSIZE (for CS7/8 switch)
> > PARODD (parity odd/even)
> > CMSPAR (parity mark/space v odd/even)
> > CSTOPB (stop bits)
> >
> > while you have PARODD twice.
> >
> > Otherwise this looks correct.
> 
> 
>   Woops - yep that was wrong. I attach a new patch - with CMSPAR and
> PARENB which I assume is also parity related.

Much better, thanks, but the tabs all seem to have been removed from
this patch, making it impossible to apply.

Also, I need a "clean" patch, against the 3.1 tree at the least, in
order to be able to apply this, not against a previous version of your
patch.

Also, run your patch through the scripts/checkpatch.pl script to ensure
it is correct before sending it out.

Care to fix this up and resend so that I can apply this?

thanks,

greg k-h
