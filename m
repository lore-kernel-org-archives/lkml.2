Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776Ab2EPPRW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 11:17:22 -0400
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:27033 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754396Ab2EPPRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 11:17:18 -0400
Message-ID: <1337181431.2424.12.camel@lorien2>
Subject: Re: [PATCH 08/11] ramoops: Move to fs/pstore/ram.c
From: Shuah Khan <shuahkhan@gmail.com>
Reply-To: shuahkhan@gmail.com
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: shuahkhan@gmail.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>,
        Arnd Bergmann <arnd@arndb.de>, John Stultz <john.stultz@linaro.org>,
        arve@android.com, Rebecca Schultz Zavin <rebecca@android.com>,
        Jesper Juhl <jj@chaosbits.net>, Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Boyd <sboyd@codeaurora.org>, Thomas Meyer <thomas@m3y3r.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Date: Wed, 16 May 2012 09:17:11 -0600
In-Reply-To: <20120516073052.GC18058@lizard>
References: <20120512001506.GA8653@lizard> <20120512001818.GH14782@lizard>
	 <1337094779.2602.9.camel@lorien2> <20120516073052.GC18058@lizard>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-16 at 00:30 -0700, Anton Vorontsov wrote:
> Hi Shuah,
> 
> On Tue, May 15, 2012 at 09:12:59AM -0600, Shuah Khan wrote:
> > On Fri, 2012-05-11 at 17:18 -0700, Anton Vorontsov wrote:
> > > Since ramoops was converted to pstore, it has nothing to do with character
> > > devices nowadays. Instead, today it is just a RAM backend for pstore.
> > > 
> > > The patch just moves things around. There are a few changes were needed
> > > because of the move:
> > > 
> > > 1. Kconfig and Makefiles fixups, of course.
> > > 
> > > 2. In pstore/ram.c we have to play a bit with MODULE_PARAM_PREFIX, this
> > >    is needed to keep user experience the same as with ramoops driver
> > >    (i.e. so that ramoops.foo kernel command line arguments would still
> > >    work).
> > 
> > Anton,
> > 
> > Could you please enhance Kconfig as well as ram.c with information with
> > the new functionality it supports.
> 
> Sure, will do.
> 
> > Also ram.c in my opinion doesn't
> > really reflect the feature it currently supports and its future plans.
> > ramoops doesn't either. ramdesg or ramkmsg probably are better suited.
> 
> No, I actually think we shouldn't mention neither dmesg nor kmsg in
> the name of the module. We might support MCE messages, tracing
> messages and so on, and this all will be handled by ram.c.

Good point.
> 
> So, ram.c is a generic backend for pstore.
> 
> > Also leaving the ABI that ramoops specific might lead confusion in the
> > long run. It might make sense to update the ABI to reflect its new
> > features, if it doesn't impact existing ramoops users.
> 
> We can do this, I can prepare a separate patch to change the ABI, but
> so far I tend to not break any ABIs. We can always do it later -- it is
> easy. :-D

Yes it can be done later.
> 
> > Would you be interested in adding a doc file for usage describing how
> > users can configure the driver - the details I would like to see are how
> > to pick a ram address especially when mem_address and mem_size are
> > passed in as module parameters.
> 
> We actually have Documentation/ramoops.txt already, but I'll add
> a documentation for the new ecc option.
> 
> Thanks!

Thanks for doing this. One thing that would be helpful for users is some
kind of guidance/tips on how to pick ram range for module parameter
passing, which is missing from the current ramoops.txt

Thanks,
-- Shuah


