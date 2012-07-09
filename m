Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409Ab2GIMDj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 08:03:39 -0400
Received: from mga02.intel.com ([134.134.136.20]:38870 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753090Ab2GIMDi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 08:03:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="169176464"
Date: Mon, 9 Jul 2012 15:03:33 +0300
From: Andrei Emeltchenko <andrei.emeltchenko@intel.com>
To: Joe Perches <joe@perches.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, proski@gnu.org,
        linux-wireless@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCHv2 2/3] lib: printf: append support of '%*p[Mm][FR]'
Message-ID: <20120709120326.GH2627@aemeltch-MOBL1>
References: <1341264199.10162.2.camel@joe2Laptop>
 <1341310000-4082-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1341310000-4082-2-git-send-email-andriy.shevchenko@linux.intel.com>
 <1341329631.2164.15.camel@joe2Laptop>
 <CAHp75VfN4X9fH7NEUag3XYy7kLiEz-jcjhEOdoHMk3if_m_aOg@mail.gmail.com>
 <1341341280.2012.3.camel@joe2Laptop>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1341341280.2012.3.camel@joe2Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jul 03, 2012 at 11:48:00AM -0700, Joe Perches wrote:
> On Tue, 2012-07-03 at 21:32 +0300, Andy Shevchenko wrote:
> > On Tue, Jul 3, 2012 at 6:33 PM, Joe Perches <joe@perches.com> wrote:
> > > On Tue, 2012-07-03 at 13:06 +0300, Andy Shevchenko wrote:
> > >> There are many places in the kernel where the drivers print small buffers as a
> > >> hex string. This patch adds a support of the variable width buffer to print it
> > >> as a hex string with a delimiter. The idea came from Pavel Roskin here:
> > >> http://www.digipedia.pl/usenet/thread/18835/17449/
> > >>
> > >> Sample output of
> > >>       pr_info("buf[%d:%d] %*pM\n", from, len, len, &buf[from]);
> > >> could be look like this:
> > >>       [ 0.726130] buf[51:8] e8:16:b6:ef:e3:74:45:6e
> > >>       [ 0.750736] buf[59:15] 31:81:b8:3f:35:49:06:ae:df:32:06:05:4a:af:55
> > >>       [ 0.757602] buf[17:5] ac:16:d5:2c:ef

The idea is really good and can make redundant lots of print_hex
functions.

> > 
> > > It might be more sensible to use new, distinct
> > > "%*pH" and "%*ph" functions and not touch the
> > > mac address function at all.  Will anyone ever
> > > really want to emit the buffer in reverse?
> > > I don't think so.
> > Yeah, probably it's only the case for the Bluetooth addresses.
> > 
> > > Perhaps when using a hex_string_buffer func the
> > > separator should be a space/no-space with %*pHh.
> > What I learned from today's linux-next is the most used separators are
> > ' ' (space), '' (nothing), ':' and '-'. We have dozens of the cases
> > for first three. The '-' support could not be implemented
> > nevertheless.
> > So, might be %*pHh[CDS] C for 'colon', S for 'space', D for 'dash' looks better.
> 
> Maybe use a space default.

I do not think we need other specifier then space at all.

> 
> > 'Hh' for capital/small letters than?
> 
> If you want, though I'd hope nobody uses upper case.
> 
> > > You could extend the max to 128 or larger now.
> > I don't think it is really needed.
> 
> I hope it's not, but I just don't see the need to limit it.
> 
> > Most of the current cases usually
> > print not more than ~30bytes (in average) per time. And I couldn't
> > imagine good looking printing for long lines anyway.

Maybe insert '\n' after 16 numbers?

> 
> Yup, they'd be ugly.
> print_hex_dump() should be favored anyway.

For print_hex_dump we would need to invent unreadable constructions with
defines like you mentioned in other thread:

#ifdef SOME_BLUETOOTH_DEBUG_FLAG
#define bt_hex_dump_dbg(...)    \
        print_hex_dump(...)
#else
#define bt_hex_dump_dbg(...)    \
        do { } while (0)
#endif

Best regards 
Andrei Emeltchenko 

---------------------------------------------------------------------
Intel Finland Oy
Registered Address: PL 281, 00181 Helsinki 
Business Identity Code: 0357606 - 4 
Domiciled in Helsinki 

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

