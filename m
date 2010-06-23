Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112Ab0FWJju (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 05:39:50 -0400
Received: from n14.bullet.mail.mud.yahoo.com ([68.142.206.41]:32068 "HELO
	n14.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751875Ab0FWJjs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 05:39:48 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 913245.14802.bm@omp128.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=Wf69AIG+4ZCPbhSZX6+ItuFTUbemOAQUVEViMuY7TgOxNMuZNVkOFbHzotYuNl8sitxTNwUVT6T17sE7JNVShzZOobgY32c1w0sPO9ljao89Z+vYSu1cYCcktD5w2m2JBHfOfVt4V3LztTOGvVVG+cQi3nB7FefQlzhh2xk67Ko=;
Message-ID: <728731.73469.qm@web180307.mail.gq1.yahoo.com>
X-YMail-OSG: 9_cdTikVM1l5R3Pj8vJlmz2Y7vnjA8f3CNnxvtC2xIXv4E0
 Vw252h6Z0uukXhQ6H1Oqlsv3z2BHzSMSHah731Dv4K12CHJ.MKyrh_7U1tjR
 u.UwpRuqfklgURHnH_bqSrR2dcxkj60oIopfj9kqS9wAUkwFHixlq2pfsxXK
 mw9uP4SVaKz8g.KOQVnpg3F3ydWbY3_EszNI_Ib8XSp4BN07oAj5m.9Y7HU6
 euH0TBnq7WK9JpycjeQR8NaSqd.jQe0n06kVHR.qTO1vPWyULa6_xWHl9g.f
 iBBQeLbqKAdvPyNVQ7Kl1KQ.xkZv3QiFepR_y86WX1tBDCsK7wgJJ7CT1emv
 6rtLWXEjD4u9Cj7gjQcFEW0DLCaVfN8J.2eQ-
X-Mailer: YahooMailClassic/11.1.4 YahooMailWebService/0.8.104.274457
Date: Wed, 23 Jun 2010 02:39:46 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [RFC PATCH] Rework gpio cansleep (was Re: gpiolib and sleeping gpios)
To: Ryan Mallon <ryan@bluewatersys.com>
Cc: =?iso-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       David Brownell <dbrownell@users.sourceforge.net>, gregkh@suse.de,
       linux kernel <linux-kernel@vger.kernel.org>,
       ext-jani.1.nikula@nokia.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
In-Reply-To: <4C21955D.1020502@bluewatersys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Tue, 6/22/10, Ryan Mallon <ryan@bluewatersys.com> wrote:

> > --- On Tue, 6/22/10, Ryan Mallon <ryan@bluewatersys.com>
> wrote:
> > 
> > 
> >> gpiolib
> > 
> > 
> > Again, you're talking about "gpiolib" when
> > you seem to mean the GPIO framework itself
> > (for which gpiolib is only an implementation
> > option)...
> 
> Fine, its just semantics.

Yes, just the foundation of what you're
saying.  Stuff that, when you get it wrong,
prevents communication.  Try to get it right.

If you can't be bothered to get the basics
right, I'll just have to assume you're being
a troll.  There's enough evidence of that in
other parts of your latest message; sorry.


 I think everyone knows what I
> mean when I
> refer to gpiolib.

Not without first wasting tiime finding
that you don't really mean "gpiolib"; you
instead mean something else entirely.  Sigh.

 
> >> 'Can sleep' for a gpio has two different meanings
> depending
> >> on context
> > 
> > NO; for the GPIO itself it's only ever had one
> > meaning, regardless of context.
> > 
> > You're trying to conflate the GPIO and one
> > of the contexts in which it's used.  That's
> > the problem you seem to be struggling with.
> > 
> > Please stop conflating/confusing
> > those two disparate concepts...
> 
> I'm not. 

BUT Your "counter" example below is solid
proof that you are:  it shows exactly the
confusion I pointed out:  call context versus
the GPIO itself.  There's no way I can read
that as anything except "you are"...

 
Your intent here seems perhaps more to
be a troll than to address any real
technical issues.  I don't see much
point participating any further.


 Some gpios, such as those on io expanders, may
> sleep in their
> implementations of the gpio_(set/get) functions.
> 

Such GPIOs have a "cansleep" attribute, in short.


> Drivers, which use a gpio, may call gpio_(set/get)
> functions for a given
> gpio from a context where it is not safe to sleep.

And that's the call dontext
(in this case, from a driver).

  QED.  You are confusing two disparate concepts.


 In this
> case, a gpio
> which may sleep (ie one on an i2c io-expander) cannot be
> used with this
> driver. The gpio_request will succeed, but any call to
> gpio_(set/get)_value will produce a warning.
> 
> >> example, if a driver calls gpio_get_value(gpio)
> from an
> >> interupt handler


(YOU introduce interrupt/IRQ handlers...)

> >> then the gpio must not be a sleeping gpio.
> > 
> > In a threaded IRQ handler it's OK to use
> > the get_value_cansleep() option..
> 
> Ugh, you are really twisting my words.


You said IRQ handler, so did I.  In what csense could I
possibly be "twisting" your words"???


STOP TROLLING.




 replace 'interrupt
> handler' with
> 'non sleep safe context'.

No, that would really be "twisting", by
moving words from one place to another
and significantly changing meanings.



