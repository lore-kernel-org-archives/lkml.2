Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755138Ab2HLCKV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2012 22:10:21 -0400
Received: from mga11.intel.com ([192.55.52.93]:35485 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753271Ab2HLCKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2012 22:10:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,753,1336374000"; 
   d="scan'208";a="198216724"
Date: Sun, 12 Aug 2012 10:10:13 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Michael Cree <mcree@orcon.net.nz>
Cc: linux-alpha@vger.kernel.org, Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>, Tony Luck <tony.luck@gmail.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        John David Anglin <dave.anglin@bell.net>, Mel Gorman <mgorman@suse.de>,
        kernel-janitors@vger.kernel.org, Kyle McMartin <kyle@parisc-linux.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Parisc List <linux-parisc@vger.kernel.org>
Subject: Re: [next:akpm 129/309] net/core/sock.c:274:36: error: initializer
 element is not constant
Message-ID: <20120812021013.GA8442@localhost>
References: <1343042420.3027.11.camel@dabdike.int.hansenpartnership.com>
 <20120723114258.GV9222@suse.de>
 <20120723122905.GA22476@localhost>
 <BLU0-SMTP2254F8872DDE5FA6035CDE97DD0@phx.gbl>
 <20120724074844.GA9519@localhost>
 <BLU0-SMTP6C7CFCFF734FE10A39B6E97DC0@phx.gbl>
 <1343193053.3139.6.camel@dabdike>
 <CA+8MBbJkGN+zGBdD5Hg26wW_6E9L_ufoutn7wj+Y+nhtW7WKWg@mail.gmail.com>
 <20120802150209.GA26601@localhost>
 <502707D5.7020602@orcon.net.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <502707D5.7020602@orcon.net.nz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 12, 2012 at 01:33:09PM +1200, Michael Cree wrote:
> On 03/08/12 03:02, Fengguang Wu wrote:
> > On Thu, Jul 26, 2012 at 10:06:41AM -0700, Tony Luck wrote:
> >> On Tue, Jul 24, 2012 at 10:10 PM, James Bottomley
> >> <James.Bottomley@hansenpartnership.com> wrote:
> >>>> Here is the line in sock.i:
> >>>>
> >>>> struct static_key memalloc_socks = ((struct static_key) { .enabled =
> >>>> ((atomic_t) { (0) }) });
> >>>
> >>> The above line contains two compound literals.  It also uses a designated
> >>> initializer to initialize the field enabled.  A compound literal is not a
> >>> constant expression.
> >>
> >> Seeing the same thing on ia64 building next-20120726.  Same fix works
> >> for me ... so I'll steal this whole changelog and attributes.
> > 
> > I got the same error for alpha, the same fix applies.
> 
> Just trying this patch on Alpha against v3.6-rc1 and it leads to new
> compilation errors, namely:
> 
> init/init_task.c:12: error: braced-group within expression allowed only
> inside a function
> init/init_task.c:13: error: braced-group within expression allowed only
> inside a function
> init/init_task.c:16: error: braced-group within expression allowed only
> inside a function
> init/init_task.c:16: error: braced-group within expression allowed only
> inside a function
> make[1]: *** [init/init_task.o] Error 1

Sorry! This will actually compile:

-#define ATOMIC_INIT(i)         ( { (i) } )
+#define ATOMIC_INIT(i)         { (i) }

Ditto for the 64bit version. I'll send the updated patch.

Thanks,
Fengguang
