Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985Ab0KYQP5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 11:15:57 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:48751 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753632Ab0KYQPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 11:15:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=r920hSBuOiCnasziCN+OOm+EGHnSAlVqN3XaCWmstTOIJUG5keg9uufFl0Q9vhZS3b
         9TvZlEmfJZ5atIqpw2JLs7AX6HDB9tVA4taNp2JgO5h5cvhNjhEhhhHkJDS8XVTDY0GC
         4R6vOboAs/dLPAYJVyB3Gj70FyOZsY82cSiH8=
Date: Thu, 25 Nov 2010 19:15:50 +0300
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Lin Mac <mkl0301@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, dbrownell@users.sourceforge.net,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH v2 2/3] ARM: cns3xxx: Add architecture definition for
 EHCI/OHCI controller
Message-ID: <20101125161550.GA2580@oksana.dev.rtsoft.ru>
References: <20101125135614.GA22212@oksana.dev.rtsoft.ru>
 <Pine.LNX.4.44L0.1011251031220.22247-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.44L0.1011251031220.22247-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 25, 2010 at 10:37:16AM -0500, Alan Stern wrote:
> > > 2010/11/25 Anton Vorontsov <cbouatmailru@gmail.com>:
> > > > On Thu, Nov 25, 2010 at 03:25:38PM +0800, Lin Mac wrote:
> > > > [...]
> > > >> > Â #include <linux/module.h>
> > > >> > Â #include <linux/io.h>
> > > >> > Â #include <linux/delay.h>
> > > >> > +#include <asm/atomic.h>
> > > >> It's not necessary for mach/pm.h already included it, right?
> > > >
> > > > Technically, it's not necessary. But in Linux we don't rely on
> > > > headers including other headers.
> 
> Just saw this.  Don't be ridiculous -- this happens all over the place.
> People generally aren't aware of it, because it's next to impossible to
> verify that all the headers needed by a source file are included
> directly.

Sure. But that doesn't mean we shouldn't try to keep these things
sane enough.

I just noticed that the patch introduced atomic_t usage, but didn't
include asm/atomic.h, so I corrected this before applying that patch.
So I don't see what's the fuss is about. :-)

Thanks,

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
