Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756939Ab1DFXBJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 19:01:09 -0400
Received: from relais.videotron.ca ([24.201.245.36]:8688 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813Ab1DFXBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 19:01:07 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Wed, 06 Apr 2011 19:01:07 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Alexander Holler <holler@ahsoftware.de>
Cc: linux-arm-kernel@lists.infradead.org, lkml <linux-kernel@vger.kernel.org>,
        Eric Cooper <ecc@cmu.edu>
Subject: Re: [PATCH 1/2] ARM: Differentiate SheevaPlugs and DockStars on the
 basis of the memory size.
In-reply-to: <4D9CED15.2010806@ahsoftware.de>
Message-id: <alpine.LFD.2.00.1104061850410.28032@xanadu.home>
References: <1302122121-3652-1-git-send-email-holler@ahsoftware.de>
 <1302122121-3652-2-git-send-email-holler@ahsoftware.de>
 <alpine.LFD.2.00.1104061739100.28032@xanadu.home>
 <4D9CED15.2010806@ahsoftware.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Apr 2011, Alexander Holler wrote:

> On 06.04.2011 23:44, Nicolas Pitre wrote:
> > On Wed, 6 Apr 2011, Alexander Holler wrote:
> > 
> > > It is possible to differentiate a SheevaPlugs and DockStars on the basis
> > > of the memory size.
> > > 
> > > This makes it possible to unify both setup files.
> > 
> > No no no !!!  This is an abomination!
> > 
> > We are not going to reduce the amount of code under arch/arm/ with such
> > fragile hacks.  This would create an even worse maintenance problem the
> > day either of those devices is released with more RAM or whatever.
> 
> DockStars are already obsolet and vanilla Linux was never supported by the
> manufacturer (Seagate). And they never used the machine type in question.

Is the code for DockStar in mainline actually useful?  If no then we may 
simply delete it.

> So I don't think this in any way a fragile hack.

Determining a machine type based on its amount of RAM is fragile, ugly 
and sets up a bad example for even more hacky tricks like this to crop 
up. If someone is experimenting with his SheevaPlug by giving different 
memory information in the kernel cmdline e.g. to create memory holes in 
order to test some memory allocator changes, then the kernel may think 
that it is not running on a SheevaPlug but a DockStar, and the resulting 
behavior will certainly be unexpected.

> Anyway, it was just a suggestion.

Better luck next time.


Nicolas
