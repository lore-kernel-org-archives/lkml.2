Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753623Ab1A1HjQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 02:39:16 -0500
Received: from one.firstfloor.org ([213.235.205.2]:33558 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780Ab1A1HjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 02:39:14 -0500
Date: Fri, 28 Jan 2011 08:39:09 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Huang Ying <ying.huang@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Avi Kivity <avi@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>, Dean Nelson <dnelson@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH 1/2] mm, Make __get_user_pages return -EHWPOISON for HWPOISON page optionally
Message-ID: <20110128073909.GC15569@one.firstfloor.org>
References: <1294908168.4596.58.camel@yhuang-dev> <4D2ED737.6050802@redhat.com> <1294969036.4596.67.camel@yhuang-dev> <4D331054.4030206@redhat.com> <1295225259.10748.3.camel@yhuang-dev> <20110120155021.GA5996@amt.cnet> <1296113345.15213.87.camel@yhuang-dev> <20110127150705.f2cfe235.akpm@linux-foundation.org> <20110128005711.GB15569@one.firstfloor.org> <20110127171244.7a9442a7.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110127171244.7a9442a7.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Also longer term we'll get compilers that can do cross-file inlining
> > for optimized builds.
> 
> Which we'll probably need to turn off all over the place :(

Why? 

> 
> > So please better avoid these kinds of micro optimizations unless
> > it's a really really extremly speed critical path.
> 
> It's not just speed and it's not just .text size, either. Calling a
> ten-arg function consumes stack space.

gcc is pretty good at handling tail calls. Take a look at the code
it generates.


-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
