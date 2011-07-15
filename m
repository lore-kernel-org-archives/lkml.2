Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028Ab1GOSag (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 14:30:36 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57165 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157Ab1GOSaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 14:30:35 -0400
Date: Fri, 15 Jul 2011 12:30:32 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>, Greg KH <greg@kroah.com>,
        Jean Delvare <khali@linux-fr.org>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Samuel Oritz <sameo@linux.intel.com>,
        Graeme Gregory <gg@slimlogic.co.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] regmap: Add SPI bus support
Message-ID: <20110715183032.GC2833@ponder.secretlab.ca>
References: <20110709044923.GB13074@opensource.wolfsonmicro.com>
 <1310187044-13269-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1310187044-13269-3-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20110715025327.GI2927@ponder.secretlab.ca>
 <20110715043922.GJ32716@opensource.wolfsonmicro.com>
 <CACxGe6sjTTnB2_e2omp51bnc+4kshkhNRfqDPdB3fYQG=oiWmQ@mail.gmail.com>
 <20110715050939.GM32716@opensource.wolfsonmicro.com>
 <4E2001F0.4050402@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E2001F0.4050402@cam.ac.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 15, 2011 at 10:01:36AM +0100, Jonathan Cameron wrote:
> On 07/15/11 06:09, Mark Brown wrote:
> > On Thu, Jul 14, 2011 at 11:04:27PM -0600, Grant Likely wrote:
> >> On Thu, Jul 14, 2011 at 10:39 PM, Mark Brown
> >> <broonie@opensource.wolfsonmicro.com> wrote:
> > 
> > [Regmap API I2C bus code.]
> >>> There was a bit about this in the cover mail - it's the interace
> >>> stability issue again, the plan is to move them once we're more
> >>> confident that the interface used will stay stable.
> > 
> >> I've got no problem with churn in drivers/spi, and I'm fine to have
> >> changes in drivers/spi merged via other trees if it means the code is
> >> in the logical place.
> > 
> > Can I add an ack from you for that?  If/when it does get merged I'd
> > appreciate it if you pushed any code to me for review.
> > 
> >>>>       struct spi_transfer t[2] = { {.tx_buf = reg, .len = reg_len},
> >>>>                                    {.tx_buf = val, .len = val_len}};
> > 
> >>>> Then the memset() and t[0]/t[1] lines can all be culled.
> > 
> >>> That does the init to zero?
> > 
> >> You might want to double check, but I believe it gets implemented as a
> >> memcpy of a static initializer.
> > 
> > Hrm, given that neither of us is 100% sure I think it's safer to leave
> > it written out long hand and avoid confusing anyone else.
> 
> It does the init to zero. The relevant bit of the spec is designated initializers.
> 
> See c99 spec (draft here as I'm not paying for it ;) WG14/N1124
> 6.7.8 

Okay, good.  I would prefer the initializer form.

g.

