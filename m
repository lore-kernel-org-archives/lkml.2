Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757150Ab0DAQA5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 12:00:57 -0400
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:54557 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756893Ab0DAQAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 12:00:51 -0400
Date: Thu, 1 Apr 2010 10:55:52 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: David Howells <dhowells@redhat.com>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Matthew Wilcox <matthew@wil.cx>,
       Yinghai Lu <yinghai@kernel.org>, Rabin Vincent <rabin@rab.in>,
       lkml <linux-kernel@vger.kernel.org>, penberg@cs.helsinki.fi,
       linux-arch@vger.kernel.org
Subject: Re: start_kernel(): bug: interrupts were enabled early
In-Reply-To: <31829.1270119970@redhat.com>
Message-ID: <alpine.DEB.2.00.1004011055150.16531@router.home>
References: <1270104536.7101.114.camel@pasglop> <20100325194100.GA2364@debian> <20100331134048.da4e35a7.akpm@linux-foundation.org> <4BB3B4DB.7040904@kernel.org> <20100331210145.GB32165@parisc-linux.org> <4BB3B8FC.1020608@zytor.com> <20100331211754.GC32165@parisc-linux.org>
 <alpine.DEB.2.00.1003311640410.30456@router.home> <20100331215411.GB17715@flint.arm.linux.org.uk> <4BB3C540.9000405@zytor.com> <1270075071.7101.79.camel@pasglop> <20100331154955.54176e5e.akpm@linux-foundation.org> <1270084631.7101.81.camel@pasglop>
 <20100331182654.d36c87ff.akpm@linux-foundation.org> <4BB43CAC.3080102@zytor.com> <20100331233330.1a7357e4.akpm@linux-foundation.org>  <31829.1270119970@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Apr 2010, David Howells wrote:

>
> Can we provide a kmem_cache_create_early()?  One that takes no locks and gets
> cleaned up with the other __init stuff?

Sure. We can also check if we are early in boot in kmem_cache_create and
just not take the semaphores (which are useless if we are single
threaded).


