Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757125Ab0DAQCF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 12:02:05 -0400
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:54938 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757114Ab0DAQB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 12:01:58 -0400
Date: Thu, 1 Apr 2010 10:57:10 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Matthew Wilcox <matthew@wil.cx>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yinghai@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Rabin Vincent <rabin@rab.in>,
       lkml <linux-kernel@vger.kernel.org>, penberg@cs.helsinki.fi,
       linux-arch@vger.kernel.org
Subject: Re: start_kernel(): bug: interrupts were enabled early
In-Reply-To: <1270075013.7101.78.camel@pasglop>
Message-ID: <alpine.DEB.2.00.1004011056090.16531@router.home>
References: <20100325194100.GA2364@debian>  <20100331134048.da4e35a7.akpm@linux-foundation.org>  <4BB3B4DB.7040904@kernel.org> <20100331210145.GB32165@parisc-linux.org>  <4BB3B8FC.1020608@zytor.com> <20100331211754.GC32165@parisc-linux.org> 
 <alpine.DEB.2.00.1003311640410.30456@router.home> <1270075013.7101.78.camel@pasglop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Apr 2010, Benjamin Herrenschmidt wrote:

> On Wed, 2010-03-31 at 16:42 -0500, Christoph Lameter wrote:
> >
> > Do not run the checks while we are in a single threaded context?
> >
> > I thought we had some dynamic code patching thingamy that could change
> > those when we go to smp mode?
>
> The problem isn't about checks. Those -will- enable IRQs before it's
> safe to do so, the checks are perfectly right to point it out, it -is- a
> bug waiting to happen on some random HW.

Taking sems in single threaded mode is pretty pointless. Those functions
could just return success until the scheduler is actually able to do
something with threads.


