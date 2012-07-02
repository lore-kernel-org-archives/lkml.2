Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933087Ab2GBVXV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 17:23:21 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:38226 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756030Ab2GBVXU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 17:23:20 -0400
Message-ID: <1341264199.10162.2.camel@joe2Laptop>
Subject: Re: [RFC][PATCH 1/2] lib: printf: append support of '%*p[Mm][FR]'
From: Joe Perches <joe@perches.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>, proski@gnu.org,
        Andrei Emeltchenko <andrei.emeltchenko@intel.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 02 Jul 2012 14:23:19 -0700
In-Reply-To: <CAHp75Vde4+A5NCH-YvrsrjE-KA3A+xLdMOozeFU4VV7vvUfcmQ@mail.gmail.com>
References: <20110930115306.3bc105cb@mj>
	 <1340985513-15655-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1340986086.6562.36.camel@joe2Laptop>
	 <20120629162649.f277177f.akpm@linux-foundation.org>
	 <1341067733.10253.2.camel@joe2Laptop>
	 <CAHp75Vde4+A5NCH-YvrsrjE-KA3A+xLdMOozeFU4VV7vvUfcmQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-02 at 20:32 +0300, Andy Shevchenko wrote:
> On Sat, Jun 30, 2012 at 5:48 PM, Joe Perches <joe@perches.com> wrote:
> > On Fri, 2012-06-29 at 16:26 -0700, Andrew Morton wrote:
> >> On Fri, 29 Jun 2012 09:08:06 -0700
> >> Joe Perches <joe@perches.com> wrote:
> >>
> >> > > diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> >> > []
> >> > > @@ -655,11 +655,12 @@ char *resource_string(char *buf, char *end, struct resource *res,
> >> > >  }
> >> > >
> >> > >  static noinline_for_stack
> >> > > -char *mac_address_string(char *buf, char *end, u8 *addr,
> >> > > -                  struct printf_spec spec, const char *fmt)
> >> > > +char *hex_string(char *buf, char *end, u8 *addr, struct printf_spec spec,
> >> > > +          const char *fmt)
> >> > >  {
> >> > > - char mac_addr[sizeof("xx:xx:xx:xx:xx:xx")];
> >> > > - char *p = mac_addr;
> >> > > + char hex_str[64*3];     /* support up to 64 bytes to print */
> >> >
> >> > Might be too much stack though.
> >>
> >> Yes, it's a bit marginal, as this new capability might be used in debug
> >> or crash situations where we're deep into the stack.  The average case
> >> could be improved by using alloca()-style allocation.
> >
> > Or maybe support larger sizes with a smaller
> > stack buffer and a while loop.
> 
> What do you think about mixed approach? Let's say we would use buffer
> on stack for 8 bytes or less, and allocated buffer in case of larger
> input. It allows to keep implementation simple.
> 

I think the while loop is simplest.
I'll code something up tomorrow unless
you get to it first.

