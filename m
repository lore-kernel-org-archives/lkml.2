Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759617Ab2EPHca (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 03:32:30 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61649 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759223Ab2EPHcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 03:32:22 -0400
Date: Wed, 16 May 2012 00:30:52 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Shuah Khan <shuahkhan@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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
Subject: Re: [PATCH 08/11] ramoops: Move to fs/pstore/ram.c
Message-ID: <20120516073052.GC18058@lizard>
References: <20120512001506.GA8653@lizard>
 <20120512001818.GH14782@lizard>
 <1337094779.2602.9.camel@lorien2>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1337094779.2602.9.camel@lorien2>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shuah,

On Tue, May 15, 2012 at 09:12:59AM -0600, Shuah Khan wrote:
> On Fri, 2012-05-11 at 17:18 -0700, Anton Vorontsov wrote:
> > Since ramoops was converted to pstore, it has nothing to do with character
> > devices nowadays. Instead, today it is just a RAM backend for pstore.
> > 
> > The patch just moves things around. There are a few changes were needed
> > because of the move:
> > 
> > 1. Kconfig and Makefiles fixups, of course.
> > 
> > 2. In pstore/ram.c we have to play a bit with MODULE_PARAM_PREFIX, this
> >    is needed to keep user experience the same as with ramoops driver
> >    (i.e. so that ramoops.foo kernel command line arguments would still
> >    work).
> 
> Anton,
> 
> Could you please enhance Kconfig as well as ram.c with information with
> the new functionality it supports.

Sure, will do.

> Also ram.c in my opinion doesn't
> really reflect the feature it currently supports and its future plans.
> ramoops doesn't either. ramdesg or ramkmsg probably are better suited.

No, I actually think we shouldn't mention neither dmesg nor kmsg in
the name of the module. We might support MCE messages, tracing
messages and so on, and this all will be handled by ram.c.

So, ram.c is a generic backend for pstore.

> Also leaving the ABI that ramoops specific might lead confusion in the
> long run. It might make sense to update the ABI to reflect its new
> features, if it doesn't impact existing ramoops users.

We can do this, I can prepare a separate patch to change the ABI, but
so far I tend to not break any ABIs. We can always do it later -- it is
easy. :-D

> Would you be interested in adding a doc file for usage describing how
> users can configure the driver - the details I would like to see are how
> to pick a ram address especially when mem_address and mem_size are
> passed in as module parameters.

We actually have Documentation/ramoops.txt already, but I'll add
a documentation for the new ecc option.

Thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
