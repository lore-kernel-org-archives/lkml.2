Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756253Ab2JIPnm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 11:43:42 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:19774 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754570Ab2JIPnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 11:43:39 -0400
X-IronPort-AV: E=Sophos;i="4.80,560,1344204000"; 
   d="scan'208";a="176494686"
Date: Tue, 9 Oct 2012 17:43:36 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Jean Delvare <khali@linux-fr.org>
cc: Julia Lawall <Julia.Lawall@lip6.fr>,
        Mauro Carvalho Chehab <mchehab@infradead.org>, ben-linux@fluff.org,
        w.sang@pengutronix.de, linux-i2c@vger.kernel.org,
        kernel-janitors@vger.kernel.org, rmallon@gmail.com,
        shubhrajyoti@ti.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/11] introduce macros for i2c_msg initialization
In-Reply-To: <20121009173237.7c1a49e9@endymion.delvare>
Message-ID: <alpine.DEB.2.02.1210091737450.1971@hadrien>
References: <1349624323-15584-1-git-send-email-Julia.Lawall@lip6.fr> <20121009173237.7c1a49e9@endymion.delvare>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Oct 2012, Jean Delvare wrote:

> Hi Julia,
>
> On Sun,  7 Oct 2012 17:38:30 +0200, Julia Lawall wrote:
> > This patch set introduces some macros for describing how an i2c_msg is
> > being initialized.  There are three macros: I2C_MSG_READ, for a read
> > message, I2C_MSG_WRITE, for a write message, and I2C_MSG_OP, for some other
> > kind of message, which is expected to be very rarely used.
>
> "Some other kind of message" is actually messages which need extra
> flags. They are still read or write messages.

I agree.  We could also have a read with extra options macro and a write
with extra options macro.  That would give four macros, which is not too
much more than three.

> OK, I've read the whole series now and grepped the kernel tree so I
> have a better overview. There are a lot more occurrences than what you
> converted. I presume the conversions were just an example and you leave
> the rest up to the relevant maintainers (e.g. me) if they are
> interested?

I would be happy to do the rest, or at least to do more.  I just didn't
want to do 600+ cases before knowing how others felt about the various
changes.  Actually, now that we seem to have decided to make fewer changes
at once, I could probably work more quickly.  So far, I have been
comparing the results after running cpp, as well as checking that the
sizeof transformation is correct, which is a bit slow.

> Given the huge number of affected drivers (a quick grep suggests 230
> drivers and more than 300 occurrences), we'd better think twice before
> going on as it will be intrusive and hard to change afterward.
>
> So my first question will be: what is your goal with this change? Are
> you only trying to save a few lines of source code? Or do you expect to
> actually fix/prevent bugs by introducing these macros? Or something
> else?

The main goal just seems to be to provide something that is more readable.

> I admit I am not completely convinced by the benefit at the moment. A
> number of these drivers should be using i2c_smbus_*() functions instead
> of i2c_transfer() for improved compatibility, or i2c_master_send/recv()
> for single message transfers (383 occurrences!), so making
> i2c_transfer() easier to use isn't at the top of my priority list. And
> I see the extra work for the pre-processor, so we need a good reason
> for doing that.

OK, if it doesn't seem like a good idea, it is no problem to drop the idea
completely.  It does seem a bit nicer to have writing indicated as WRITE
rather than as 0, but that might not be a big enough benefit to justify
making changes.

julia
