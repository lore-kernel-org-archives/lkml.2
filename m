Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932848Ab2GCSsE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 14:48:04 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:58897 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932255Ab2GCSsB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 14:48:01 -0400
Message-ID: <1341341280.2012.3.camel@joe2Laptop>
Subject: Re: [RFC][PATCHv2 2/3] lib: printf: append support of '%*p[Mm][FR]'
From: Joe Perches <joe@perches.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, proski@gnu.org,
        Andrei Emeltchenko <andrei.emeltchenko@intel.com>,
        linux-wireless@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Date: Tue, 03 Jul 2012 11:48:00 -0700
In-Reply-To: <CAHp75VfN4X9fH7NEUag3XYy7kLiEz-jcjhEOdoHMk3if_m_aOg@mail.gmail.com>
References: <1341264199.10162.2.camel@joe2Laptop>
	 <1341310000-4082-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1341310000-4082-2-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1341329631.2164.15.camel@joe2Laptop>
	 <CAHp75VfN4X9fH7NEUag3XYy7kLiEz-jcjhEOdoHMk3if_m_aOg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-03 at 21:32 +0300, Andy Shevchenko wrote:
> On Tue, Jul 3, 2012 at 6:33 PM, Joe Perches <joe@perches.com> wrote:
> > On Tue, 2012-07-03 at 13:06 +0300, Andy Shevchenko wrote:
> >> There are many places in the kernel where the drivers print small buffers as a
> >> hex string. This patch adds a support of the variable width buffer to print it
> >> as a hex string with a delimiter. The idea came from Pavel Roskin here:
> >> http://www.digipedia.pl/usenet/thread/18835/17449/
> >>
> >> Sample output of
> >>       pr_info("buf[%d:%d] %*pM\n", from, len, len, &buf[from]);
> >> could be look like this:
> >>       [ 0.726130] buf[51:8] e8:16:b6:ef:e3:74:45:6e
> >>       [ 0.750736] buf[59:15] 31:81:b8:3f:35:49:06:ae:df:32:06:05:4a:af:55
> >>       [ 0.757602] buf[17:5] ac:16:d5:2c:ef
> 
> > It might be more sensible to use new, distinct
> > "%*pH" and "%*ph" functions and not touch the
> > mac address function at all.  Will anyone ever
> > really want to emit the buffer in reverse?
> > I don't think so.
> Yeah, probably it's only the case for the Bluetooth addresses.
> 
> > Perhaps when using a hex_string_buffer func the
> > separator should be a space/no-space with %*pHh.
> What I learned from today's linux-next is the most used separators are
> ' ' (space), '' (nothing), ':' and '-'. We have dozens of the cases
> for first three. The '-' support could not be implemented
> nevertheless.
> So, might be %*pHh[CDS] C for 'colon', S for 'space', D for 'dash' looks better.

Maybe use a space default.

> 'Hh' for capital/small letters than?

If you want, though I'd hope nobody uses upper case.

> > You could extend the max to 128 or larger now.
> I don't think it is really needed.

I hope it's not, but I just don't see the need to limit it.

> Most of the current cases usually
> print not more than ~30bytes (in average) per time. And I couldn't
> imagine good looking printing for long lines anyway.

Yup, they'd be ugly.
print_hex_dump() should be favored anyway.

cheers, Joe

