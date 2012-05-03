Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758534Ab2ECUSr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 16:18:47 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:52492 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754168Ab2ECUSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 16:18:46 -0400
X-Sasl-enc: PIB5SsSUHIznhDjnLilE1akpdi1Ki6v+TvCop4lzej5m 1336076325
Date: Thu, 3 May 2012 13:18:44 -0700
From: Greg Kroah-Hartmann <greg@kroah.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Kay Sievers <kay@vrfy.org>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 1/3] printk: convert byte-buffer to
 variable-length record buffer
Message-ID: <20120503201844.GA21584@kroah.com>
References: <1336004953.4240.9.camel@mop>
 <1336074483.6509.3.camel@twins>
 <CA+55aFxhQ3SQrZJ6KGDu0xQ6sWSDxrS1C-V_fBcgCYmSqAKSWQ@mail.gmail.com>
 <1336075373.6509.9.camel@twins>
 <CA+55aFx1BO-s1YZ3EwscdWh2y5C2Q2dUyH8xQmuBKTNZrZWTNA@mail.gmail.com>
 <1336075862.6509.10.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336075862.6509.10.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2012 at 10:11:02PM +0200, Peter Zijlstra wrote:
> On Thu, 2012-05-03 at 13:09 -0700, Linus Torvalds wrote:
> > On Thu, May 3, 2012 at 1:02 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > >
> > > Thing is, with bonkers stuff like usb-console and kms/drm that's a _lot_
> > > of code running under the logbuf/console locks.
> > 
> > The top-level console lock shouldn't be a problem - we use trylock and
> > delay if it is held.
> > 
> > It's the lower-level driver-specific locks that screw us up. And quite
> > frankly, I am *not* willing to say that that is a printk() problem.
> > That is purely a "USB serial console is damn well broken" issue, and
> > should not be considered a limitation of printk.
> 
> I'm happy to call all that broken ;-)

USB serial console was a drunken bet gone wrong.  I'm amazed that it
even works at times, and it should never be considered critical enough
to affect any core kernel code.

greg k-h
