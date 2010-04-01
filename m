Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758545Ab0DAXCa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 19:02:30 -0400
Received: from gate.crashing.org ([63.228.1.57]:41194 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756638Ab0DAXC1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 19:02:27 -0400
Subject: Re: start_kernel(): bug: interrupts were enabled early
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>, Yinghai Lu <yinghai@kernel.org>,
       Rabin Vincent <rabin@rab.in>, lkml <linux-kernel@vger.kernel.org>,
       penberg@cs.helsinki.fi, linux-arch@vger.kernel.org
In-Reply-To: <31829.1270119970@redhat.com>
References: <1270104536.7101.114.camel@pasglop>
	 <20100325194100.GA2364@debian>
	 <20100331134048.da4e35a7.akpm@linux-foundation.org>
	 <4BB3B4DB.7040904@kernel.org> <20100331210145.GB32165@parisc-linux.org>
	 <4BB3B8FC.1020608@zytor.com> <20100331211754.GC32165@parisc-linux.org>
	 <alpine.DEB.2.00.1003311640410.30456@router.home>
	 <20100331215411.GB17715@flint.arm.linux.org.uk>
	 <4BB3C540.9000405@zytor.com> <1270075071.7101.79.camel@pasglop>
	 <20100331154955.54176e5e.akpm@linux-foundation.org>
	 <1270084631.7101.81.camel@pasglop>
	 <20100331182654.d36c87ff.akpm@linux-foundation.org>
	 <4BB43CAC.3080102@zytor.com>
	 <20100331233330.1a7357e4.akpm@linux-foundation.org>
	 <31829.1270119970@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 02 Apr 2010 10:00:21 +1100
Message-ID: <1270162821.7101.138.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-01 at 12:06 +0100, David Howells wrote:
> Can we provide a kmem_cache_create_early()?  One that takes no locks and gets
> cleaned up with the other __init stuff?

Yuck. I hate having to expose more APIs. Also the problem with that is
means callers have to know. So we need to propagate up all call chains
etc... (ie, radix_tree_init_early(), etc...)

This is pretty much exactly the discussion we had when moving sl*b
early, and back then, the final word from Linus (heh, for once he agreed
with me :-) was that this made no sense.

We can bury logic inside kmem_cache_create() though, it's not -that- a
hot path.

Cheers,
Ben.

