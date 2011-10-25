Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083Ab1JYIFr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 04:05:47 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:49256 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753771Ab1JYIFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 04:05:44 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19HKHwp4csF9a8aQs6naCss
Date: Tue, 25 Oct 2011 10:05:32 +0200
From: Tony Lindgren <tony@atomide.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@nvidia.com>,
        Mike Frysinger <vapier.adi@gmail.com>,
        Linus Walleij <linus.ml.walleij@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>, Barry Song <21cnbao@gmail.com>,
        linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Lee Jones <lee.jones@linaro.org>, David Brown <davidb@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org,
        Stijn Devriendt <highguy@gmail.com>
Subject: Re: [PATCH] drivers: create a pin control subsystem v8
Message-ID: <20111025080532.GI4429@atomide.com>
References: <20110930020754.GK12606@ponder.secretlab.ca>
 <CACRpkdYyyqB6=5M8reqgwpMxXJz5ttXWyOav6K58dQ0CrxwCNA@mail.gmail.com>
 <CACxGe6v19pZ0i-+ksYZbG2ZvGT30UkXEHTzpZMBTB4RNUV5bnA@mail.gmail.com>
 <CAKnu2MpQ8Wvd4TF8Ge=o8ACyEoaEY8TcvOSdT1w6zfYiSKFUiw@mail.gmail.com>
 <20111004203520.GK2870@ponder.secretlab.ca>
 <CAMjpGUe9abPsdWbum2MRzOV2b5_2FDqXZC-K0KThRA6MNTr4FA@mail.gmail.com>
 <CACRpkdatiBathcoo2VjKs9jHJiKC5trDCJ0bePX1q6KbrYRN-g@mail.gmail.com>
 <20111024073604.GA8708@ponder.secretlab.ca>
 <CACRpkdZ6DCeELLhiXF=oOMKB-DxeMuvbd_c6n4H1UDMhpHKZbA@mail.gmail.com>
 <20111024110518.GG8708@ponder.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111024110518.GG8708@ponder.secretlab.ca>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Grant Likely <grant.likely@secretlab.ca> [111024 12:31]:
> On Mon, Oct 24, 2011 at 09:48:19AM +0200, Linus Walleij wrote:
> > On Mon, Oct 24, 2011 at 9:36 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
> > > On Mon, Oct 24, 2011 at 09:26:38AM +0200, Linus Walleij wrote:
> > (...)
> > >> I was more thinking along the lines of one device per GPIO controller,
> > >> then you ioctl() to ask /dev/gpio0 how many pins it has or so.
> > >
> > > And there is also the question of whether it is even a good idea to
> > > export pinctrl manipulation to userspace.
> > 
> > The application I've seen is in automatic control.
> > 
> > I think people do things like connect they GPIO pins to electrical
> > relays, plus on top of that they use all the stuff in drivers/staging/iio.
> > 
> > All that from userspace. Controlling entire factories and industrial
> > robots, weapon systems too, I'm afraid.
> > 
> > The control of these dangerous things runs on a realtime-patched
> > kernel, in a single userspace app with a few threads and they have
> > done some realtime-tetris scheduling the beast more or less
> > manually with SCHED_FIFO. Basically that app is all that runs on
> > the board, and its threads take precedence over everything else
> > on the system.
> > 
> > That is the typical beast that is poking around on the GPIO sysfs
> > interfaces...
> 
> ... which maybe should be encouraged to use some form of uio driver.  :-)

Changing pins from userspace is extremely handy for debugging drivers
and PM. For normal use case there should not be any need except to
view the values.

But for debugging we should have some interface for changing
the values either via debugfs or some user space program.

Regards,

Tony
