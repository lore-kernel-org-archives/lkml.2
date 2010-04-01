Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061Ab0DAHur (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 03:50:47 -0400
Received: from gate.crashing.org ([63.228.1.57]:58969 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752522Ab0DAHuk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 03:50:40 -0400
Subject: Re: start_kernel(): bug: interrupts were enabled early
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>, Yinghai Lu <yinghai@kernel.org>,
       Rabin Vincent <rabin@rab.in>, lkml <linux-kernel@vger.kernel.org>,
       penberg@cs.helsinki.fi, linux-arch@vger.kernel.org
In-Reply-To: <4BB43CAC.3080102@zytor.com>
References: <20100325194100.GA2364@debian>
	 <20100331134048.da4e35a7.akpm@linux-foundation.org>
	 <4BB3B4DB.7040904@kernel.org>	<20100331210145.GB32165@parisc-linux.org>
	 <4BB3B8FC.1020608@zytor.com>	<20100331211754.GC32165@parisc-linux.org>
	 <alpine.DEB.2.00.1003311640410.30456@router.home>
	 <20100331215411.GB17715@flint.arm.linux.org.uk>
	 <4BB3C540.9000405@zytor.com>	<1270075071.7101.79.camel@pasglop>
	 <20100331154955.54176e5e.akpm@linux-foundation.org>
	 <1270084631.7101.81.camel@pasglop>
	 <20100331182654.d36c87ff.akpm@linux-foundation.org>
	 <4BB43CAC.3080102@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Apr 2010 17:50:23 +1100
Message-ID: <1270104623.7101.116.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-31 at 23:26 -0700, H. Peter Anvin wrote:
> On 03/31/2010 03:26 PM, Andrew Morton wrote:
> > 
> > Not by adding overhead to every single down_read()/down_write() just to
> > fix a once-off startup problem - that's taking laziness way too far.
> > 
> 
> How much overhead is this on non-x86 architectures (keep in mind x86
> doesn't use this?)

None on powerpc, we use atomic ops and don't disable IRQs.

BTW. The same problem used to happen with mutex debug. Was this ever
fixed ?

Cheers,
Ben.


