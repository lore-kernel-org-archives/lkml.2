Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758272Ab0CaV5Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 17:57:16 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41085 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756750Ab0CaV5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 17:57:14 -0400
Date: Wed, 31 Mar 2010 22:54:11 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Matthew Wilcox <matthew@wil.cx>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yinghai@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Rabin Vincent <rabin@rab.in>,
       lkml <linux-kernel@vger.kernel.org>, penberg@cs.helsinki.fi,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-arch@vger.kernel.org
Subject: Re: start_kernel(): bug: interrupts were enabled early
Message-ID: <20100331215411.GB17715@flint.arm.linux.org.uk>
Mail-Followup-To: Christoph Lameter <cl@linux-foundation.org>,
	Matthew Wilcox <matthew@wil.cx>, "H. Peter Anvin" <hpa@zytor.com>,
	Yinghai Lu <yinghai@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Rabin Vincent <rabin@rab.in>, lkml <linux-kernel@vger.kernel.org>,
	penberg@cs.helsinki.fi,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	linux-arch@vger.kernel.org
References: <20100325194100.GA2364@debian> <20100331134048.da4e35a7.akpm@linux-foundation.org> <4BB3B4DB.7040904@kernel.org> <20100331210145.GB32165@parisc-linux.org> <4BB3B8FC.1020608@zytor.com> <20100331211754.GC32165@parisc-linux.org> <alpine.DEB.2.00.1003311640410.30456@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1003311640410.30456@router.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 31, 2010 at 04:42:25PM -0500, Christoph Lameter wrote:
> Do not run the checks while we are in a single threaded context?
> 
> I thought we had some dynamic code patching thingamy that could change
> those when we go to smp mode?

You have to remember that on embedded architectures, such as ARM,
where XIP is supported we can't change the text segment at run time -
which means dynamic code patching won't work.

However, the kernel should still work in such situations.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
