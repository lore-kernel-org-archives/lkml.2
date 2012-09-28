Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964993Ab2I1Xjc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 19:39:32 -0400
Received: from mga02.intel.com ([134.134.136.20]:57559 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964948Ab2I1Xja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 19:39:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,504,1344236400"; 
   d="scan'208";a="199557496"
Date: Fri, 28 Sep 2012 16:40:17 -0700
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Thad Phetteplace <tdphette@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Slow copy_to_user performance after kernel upgrade
Message-ID: <20120928234017.GA5280@linux.intel.com>
Reply-To: tim.c.chen@linux.intel.com
References: <CAOQSsQMY70nvzFT=rx0yqUXhm=fZWBi+ke-QuZj6uynfZmTLDw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQSsQMY70nvzFT=rx0yqUXhm=fZWBi+ke-QuZj6uynfZmTLDw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 03:58:26PM -0500, Thad Phetteplace wrote:
> I am debugging an issue with copy_to_user performance on recent linux
> kernels.  I've noticed a 4X slowdown in copy speed when I move from
> kernel 2.6.18 to more recent kernels on the same hardware.  I've
> tested so far on 2.6.32 and on various 3.x kernels.  I noticed that
> assembly code implementation of copy_to_user has changed, so as a
> sanity check I ported the 2.6.18 version over to 2.6.32 but saw the
> same slowdown when using it.  This is the hardware I am using:
> 
> Dell PowerEdge R710
> BIOS version 6.3.0
> Intel(R) Xeon(R) CPU x5650 @ 2.67GHz
> 72GB RAM (ECC DDR3 800MHz)
> 
> I am running the x86_64 version of course.  I see the issue when I do
> a copy_to_user from a dedicated block of memory located above the 4GB
> boundary into normal user space mem.  The boot parameter mem=65G is
> passed to the kernel to carve off the dedicated block of memory that
> is used as a DMA accessible buffer for a specialized network card.
> That is the buffer we do the copy_to_user from.  I should also mention
> we have been testing this on CentOS 4.8, 6.2, and 6.3, though I've
> replaced their stock kernels with ones straight from kernel.org, so I
> don't know that the linux distro is really relevant.
> 
> I've browsed the kernel mailing list looking for clues and have even
> been looking at CPU/hardware specific errata, but so far I can see no
> logical reason why the 2.6.32+ kernels should be performing so much
> worse than the 2.6.18.  Does anyone have any suggestions on areas to
> dig into besides the copy_to_user implementation itself?  Maybe
> somewhere specific in the MMU code?  Any suggestions would be
> appreciated.  Please copy me directly on replies if you don't mind.
> 

What cpu frequency governor are you using for testing?  Perhaps 
the default ondemand governor is not boosting the cpu frequency 
when you are running yor benchmark?
If that's the case, try to rerun with performance governor.

Tim
