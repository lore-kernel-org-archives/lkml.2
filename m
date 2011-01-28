Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013Ab1A1BNg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 20:13:36 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47029 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752576Ab1A1BNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 20:13:34 -0500
Date: Thu, 27 Jan 2011 17:12:44 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Huang Ying <ying.huang@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Avi Kivity <avi@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>, Dean Nelson <dnelson@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH 1/2] mm, Make __get_user_pages return -EHWPOISON for
 HWPOISON page optionally
Message-Id: <20110127171244.7a9442a7.akpm@linux-foundation.org>
In-Reply-To: <20110128005711.GB15569@one.firstfloor.org>
References: <1294908168.4596.58.camel@yhuang-dev>
	<4D2ED737.6050802@redhat.com>
	<1294969036.4596.67.camel@yhuang-dev>
	<4D331054.4030206@redhat.com>
	<1295225259.10748.3.camel@yhuang-dev>
	<20110120155021.GA5996@amt.cnet>
	<1296113345.15213.87.camel@yhuang-dev>
	<20110127150705.f2cfe235.akpm@linux-foundation.org>
	<20110128005711.GB15569@one.firstfloor.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Jan 2011 01:57:11 +0100
Andi Kleen <andi@firstfloor.org> wrote:

> I personally would consider it cleaner to have clearly
> defined wrappers instead of complicted flags in the caller.
> 
> > The number of args to these functions is getting nutty - you'll
> > probably find that it is beneficial to inline these wrapepr functions, if
> > the number of callsites is small.
> 
> Really the functions are so heavy weight it should not matter.
> The problem with inlining is that you end up with the code in
> the header file and I personally find that much harder to browse
> instead of having everything in one file.

You'll cope.

> Also longer term we'll get compilers that can do cross-file inlining
> for optimized builds.

Which we'll probably need to turn off all over the place :(

> So please better avoid these kinds of micro optimizations unless
> it's a really really extremly speed critical path.

It's not just speed and it's not just .text size, either. Calling a
ten-arg function consumes stack space.
