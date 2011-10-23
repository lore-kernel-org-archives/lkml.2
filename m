Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999Ab1JWUUq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 16:20:46 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51588 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782Ab1JWUUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 16:20:45 -0400
Date: Sun, 23 Oct 2011 21:20:08 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Paul Schilling <paul.s.schilling@gmail.com>
Cc: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Boojin Kim <boojin.kim@samsung.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH 02/14] ARM : SAMSUNG : Add RS485 support.
Message-ID: <20111023202008.GB27802@n2100.arm.linux.org.uk>
References: <1319255194-4799-1-git-send-email-paul.s.schilling@gmail.com> <20111022134726.GD21374@n2100.arm.linux.org.uk> <CAC=G6syuf-J4am1mHRg-5gzqy661yOT9pUK2vQyToLPtv4tvEg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAC=G6syuf-J4am1mHRg-5gzqy661yOT9pUK2vQyToLPtv4tvEg@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 23, 2011 at 12:12:13PM -0500, Paul Schilling wrote:
> On Sat, Oct 22, 2011 at 8:47 AM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
> >> +             } else {
> >> +                     /* Set a short timer to toggle RTS */
> >> +                     mod_timer(
> >> +                                     &(ourport->rs485_tx_timer),
> >> +                                     jiffies + usecs_to_jiffies(
> >> +                                                     ourport->char_time_usec
> >> +                                                     / 10));
> >
> > This could do with being better formatted.  Also, & doesn't need following
> > parens.
> 
> when I ran checkpatch it complained that it exceeded 80 characters.  I
> had trouble keeping this line
> under 80 characters.

		} else {
			mod_timer(&our_port->rs485_tx_timer, jiffies +
				  usecs_to_jiffies(ourport->char_time_usec
						   / 10));

is probably a better way to format it.

> >> -             if (port->flags & UPF_CONS_FLOW)
> >> +             if (port->flags & UPF_CONS_FLOW) {
> >>                       s3c24xx_serial_rx_enable(port);
> >> +             }
> >
> > Why are you reformatting code?
> 
> I will remove the reformatting of the code.

If you wish to reformat the code to clean up checkpatch warnings, then that
needs to be a separate patch from any other changes.
