Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757209Ab0LMVea (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 16:34:30 -0500
Received: from web31803.mail.mud.yahoo.com ([68.142.207.66]:47854 "HELO
	web31803.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754839Ab0LMVe3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 16:34:29 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=o93qLU7cO1QCrrIdb4zwuee5osEFPjVZy0F6WjtJIV4tRC0PG9bAr39wpFT+Ljk66swO6/Mm1LjYHfXNEH7YyxMpQJQY2SnEqIvjcXbXfoUZWkh4dzbE7IvrxgXwplykxBrgLwkegfB4Xvlh054XwXd3RKq4Jm/MlhoyBrsfowE=;
Message-ID: <807414.96852.qm@web31803.mail.mud.yahoo.com>
X-YMail-OSG: FPYIjMUVM1nrlKdagdG9Er1mP5XTTBtdzhLIKjZWTN3GFdL
 opR4GfmJ.K8y6rgbfLEI6ScdfB4AhhH3nxriOIh9fsHS7K4IE5PlLSdY_dtI
 yaILRh_HPDblgTEnq5yxP_Upzw9QlR5rFMAYAFzIQYg9Q7KCEr.FM_pN4xEN
 Mie5MrYPs6IrhF.K.httNfYFEOHHdCVei4TOKgJr9P.QFyT8X6rtve0MehXc
 Sl_1JvFRiuYpyFqVhhpeEiRkTwjl2N7mZgiBaxy2.5RP.lv9pnC0yrAm8zW6
 PbaBiiX0zZ2x2KtbUKCWp99VwAjHvi7AYj_81vRPn406oa3a4.cqUWLhs0CI
 0oWvVC3H7we0XuWBNZmcHzE3LOP.ak5znQeNk.KF3kODXKE3KEvBb1R0r2s0
 ZMgZzcn6Anorm
X-Mailer: YahooMailClassic/11.4.20 YahooMailWebService/0.8.107.289296
Date: Mon, 13 Dec 2010 13:34:27 -0800 (PST)
From: Luben Tuikov <ltuikov@yahoo.com>
Reply-To: ltuikov@yahoo.com
Subject: Re: [PATCH] [USB] UASP: USB Attached SCSI (UAS) protocol driver
To: Mark Brown <broonie@sirena.org.uk>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
In-Reply-To: <20101213184057.GB18736@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Mon, 12/13/10, Mark Brown <broonie@sirena.org.uk> wrote:
> > --- On Fri, 12/10/10, Alan Cox <alan@lxorguk.ukuu.org.uk>
> wrote:
> 
> > > "Do you not see HOW DIFFERENT the two drivers
> are? Do you
> > > not see the
> > > difference in quality, presentation, etc, etc."
> > > 
> > > I find the presentation *very* different. I'm
> rather
> > > worried about the
> > > manner in which it is being presented.
> 
> > Wait a minute... So a commit patch is not enough any
> more? Code is not
> > enough anymore? Quick and knowledgeable responses are
> not enough
> > anymore?
> 
> The issue here is with the kernel change and risk
> management processes
> rather than the code.

There are no UAS devices in the market. Risk 0. The in-kernel UAS driver is defunct, both in the way it is written, the terminology it uses and in the fact that it simply does not work. See the technological treatment here:
http://marc.info/?l=linux-usb&m=129185378612218&w=2

> Your new code adds a driver which replicates the
> functionality of an
> existing driver.

"eplicates the functionality of an existing driver": Now read this again:
http://marc.info/?l=linux-usb&m=129185378612218&w=2


> We've had multiple implementations
> of the same
> functionality in the past.

I've not followed the kernel lately, but I do remember what you speak of: rtl8139.c and 8139too.c.  And this duplicate functionality was in fact a re-write (as the notice in the latter driver explains) WHILE there were hundreds of thousands devices out there. Why re-write instead of "contribute to the one in the kernel, patch by patch" as Greg and Alan would like you to believe? And at the same time WHILE there are (were) so many RealTek chips out there...


>  Usually what happens is
> that users and
> distros get confused and end up swapping randomly between
> the two
> different implemenations trading off the different bug and
> feature sets,
> which doesn't make anyone happy and there's a general idea
> that we
> should try to avoid that.

Ah, yes, I see: you're trying to _protect_ distros and end users. But the fact is that users and distros are smart enough to figure out what works and what doesn't work. People working at distros are smart enough to test and see what works. And often enough, distros would contain, new and/or rewritten drivers from the one in the mainline, especially for new or rare devices which their customers want support.  So, please don't try to pull this bs of "we're protecting the end user and distros".

> This means that the 1000 foot review comment is what Greg
> has been
> telling you - the standard approach is to work on the
> existing code in
> place, incrementally making it better.

Just one patch I submitted changed 86% of the driver:
http://marc.info/?l=linux-kernel&m=128901883520391&w=2

Adding them all up, it'll be 100%. uas.c should be ripped out altogether. Do it now, while there are still no devices out there.

> This avoids
> the problem with bug
> tradeoff (as there's only ever one version in the kernel at
> once) and
> makes it much easier to isolate any new problems if they
> are introduced.

The only problems I've seen so far are with uas.c.

> Sometimes this isn't possible or a good idea for some
> reason, in which
> case the change should really explain that in the changelog
> (usually
> everyone involved will have some awareness of the issues
> already but a
> summary is useful for people picking up a new kernel
> release or
> similar).

See this: http://marc.info/?l=linux-usb&m=129185378612218&w=2

> At the very least proposing such changes
> needs to involve
> some discussion of why a rewrite is required, and there
> needs to be some
> sort of plan for how everything should converge back onto a
> single
> implementation again.

uas.c doesn't work and is very badly written piece of code. uasp.c works and complies with USB, UAS, SCSI and Linux kernel code programming guidlines. Again see this:
http://marc.info/?l=linux-usb&m=129185378612218&w=2

> > http://marc.info/?l=linux-usb&m=129185378612218&w=2

Ah, I see, so you have it.

> This is a good summary of what improvements the new driver
> brings
> (ideally more of it would have gone in the changelog), the
> missing bit
> is an explanation of why these issues can't be addressed
> with the usual
> process of incremental improvements to the existing code,
> discussion
> of how the existence of the two separate implementations
> would be
> resolved and discussion of the user visible impact of
> swapping to a new
> implementation.

I'm not sure what needs to be resolved: rip out the defunct uas.c and put in the working uasp.c. Then move on with more interesting things (like one's real job).

> Bear in mind that all your changelog said originally was:
> 
> | UASP: USB Attached SCSI (UAS) protocol driver
> 
> | This driver allows you to connect to UAS devices
> | and use them as SCSI devices
> 
> which doesn't say much more than that there's a new
> implementation of
> this.

It doesn't need to say any more, if the defunct uas.c is ripped out.  This isn't a "why uasp.c should be in and uas.c out"--it's "here is a working UAS driver".

   Luben

