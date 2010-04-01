Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758572Ab0DABTL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 21:19:11 -0400
Received: from gate.crashing.org ([63.228.1.57]:46792 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758499Ab0DABTI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 21:19:08 -0400
Subject: Re: start_kernel(): bug: interrupts were enabled early
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>, Yinghai Lu <yinghai@kernel.org>,
       Rabin Vincent <rabin@rab.in>, lkml <linux-kernel@vger.kernel.org>,
       penberg@cs.helsinki.fi, linux-arch@vger.kernel.org
In-Reply-To: <20100331154955.54176e5e.akpm@linux-foundation.org>
References: <20100325194100.GA2364@debian>
	 <20100331134048.da4e35a7.akpm@linux-foundation.org>
	 <4BB3B4DB.7040904@kernel.org> <20100331210145.GB32165@parisc-linux.org>
	 <4BB3B8FC.1020608@zytor.com> <20100331211754.GC32165@parisc-linux.org>
	 <alpine.DEB.2.00.1003311640410.30456@router.home>
	 <20100331215411.GB17715@flint.arm.linux.org.uk>
	 <4BB3C540.9000405@zytor.com> <1270075071.7101.79.camel@pasglop>
	 <20100331154955.54176e5e.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Apr 2010 12:17:11 +1100
Message-ID: <1270084631.7101.81.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-31 at 15:49 -0700, Andrew Morton wrote:
> 
> But these things are all utterly gross.  The bottom line is that
> radix_tree_init() is manifestly unsuited to being called with local
> interrupts disabled.  773e3eb7b81e5ba13b5155dfb3bb75b8ce37f8f9 was
> just a wrong patch. 

Except that powerpc (and now it seems x86) both want to use radix trees
for interrupt handling... At least on powerpc, we trick and use a linear
search until the radix trees are initialized, which we do later during
boot, but that somewhat sucks.

I believe sherry picking things like not calling radix_tree_init() is
going to fix one case today, until we have another one, and another one,
and etc...

I suspect we're better off fixing the root of the problem in down/up.

Cheers,
Ben.


