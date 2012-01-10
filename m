Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756376Ab2AJOik (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 09:38:40 -0500
Received: from mga03.intel.com ([143.182.124.21]:36261 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751111Ab2AJOij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 09:38:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="94303187"
Date: Tue, 10 Jan 2012 22:38:05 +0800
From: Wu Fengguang <wfg@linux.intel.com>
To: =?utf-8?B?0JjQu9GM0Y8g0KLRg9C80LDQudC60LjQvQ==?= 
	<librarian_rus@yahoo.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: A regression in recent 3.2 kernel: bdi_dirty_limit() divide
 error
Message-ID: <20120110143805.GA8320@localhost>
References: <20120109040445.GB31049@localhost>
 <1326205945.62365.YahooMailClassic@web161603.mail.bf1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1326205945.62365.YahooMailClassic@web161603.mail.bf1.yahoo.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 10, 2012 at 06:32:25AM -0800, Илья Тумайкин wrote:
> Hello, Mr. Fengguang.
> 
> This latter patch fixed the problem completely! I've tested vanilla 3.2 with both patches applied and with only the latter one, results are the same: 
> - first of all the initial problem solved. I have no "divide error" (not sure if this panic) now.
> - doing daily desktop stuff (e.g. web browsing, movie playback, book reading etc) also without any errors as well as compiling packages.
> 
> So, I can confirm the problem is solved completely. 
> Thank you and your colleagues very much for you fast response and active help! I am very grateful!
 
Ilya, thank you too for your report and testing! I'll submit the patch right now.

Thanks,
Fengguang

> --- Пн, 9.1.12, Wu Fengguang <wfg@linux.intel.com> пишет:
> 
> > От: Wu Fengguang <wfg@linux.intel.com>
> > Тема: Re: A regression in recent 3.2 kernel: bdi_dirty_limit() divide error
> > Кому: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
> > Копия: "Илья Тумайкин" <librarian_rus@yahoo.com>, "LKML" <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
> > Дата: Понедельник, 9 январь 2012, 7:04
> > On Sun, Jan 08, 2012 at 11:19:14AM
> > +0100, Peter Zijlstra wrote:
> > 
> > > But even then, we limit PROP_MAX_SHIFT to
> > 3*BITS_PER_LONG/4, I don't
> > > think that could ever overflow.
> > 
> > do_div() only uses the lower 32 bit value of the 64 bit
> > denominator,
> > which may happen to be 0.
> > 
> > The denominator is not really 64 bit, but limited by
> > PROP_MAX_SHIFT =
> > 48 bit, however that upper limit looks not enough.
> > 
> > Ilya, would you help try the attached patch instead?
> > 
> > Thanks,
> > Fengguang
> >
