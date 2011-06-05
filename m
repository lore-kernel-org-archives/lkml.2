Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042Ab1FEGoS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 02:44:18 -0400
Received: from cynthia.allandria.com ([76.245.85.235]:58109 "EHLO
	cynthia.pants.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753494Ab1FEGoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 02:44:17 -0400
X-Greylist: delayed 1019 seconds by postgrey-1.27 at vger.kernel.org; Sun, 05 Jun 2011 02:44:17 EDT
Date: Sat, 4 Jun 2011 23:27:02 -0700
From: Brad Boyer <flar@allandria.com>
To: Finn Thain <fthain@telegraphics.com.au>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: m68k: Convert to genirq (WIP)
Message-ID: <20110605062702.GA2034@cynthia.pants.nu>
References: <alpine.DEB.2.00.1105282010370.16617@ayla.of.borg>
 <alpine.OSX.2.00.1106011300550.199@ibook.intranet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.OSX.2.00.1106011300550.199@ibook.intranet>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 03, 2011 at 09:20:23PM +1000, Finn Thain wrote:
> On Sat, 28 May 2011, Geert Uytterhoeven wrote:
> > Of course any help is welcome, especially for Mac
> 
> What kind of help are you looking for? I read through your patch series 
> but I'm not sure how much work is left. Probably I need to look at a 
> genirq reference implementation to get an idea of the goal...

If there are any good documents on genirq, I would like to look at it
as well. I didn't see anything obvious in Documentation/ in the tree.

> > (with its maze of interrupt controllers)
> 
> Perhaps we do not need to model that complexity in generic irq terms?
> 
> The mac port could probably make good use of the irq startup and shutdown 
> hooks though.

If we could really map all the interrupt controllers, we could probably
cut down on the largest interrupt number. Most Macs really only have
20 or 30 actual interrupt sources. The problem is the two or three
layers of cascaded mess. None of them have just a single layer. Just
getting rid of the fixed global mapping could take us down to 64 since
nothing has both Baboon and PSC, but we have unique numbers for them.
We have 3 whole blocks of 8 just for PSC, even though that's just in
two models. We don't even know what most of those do, if anything.

We would probably need to move everything to platform devices if we
do that so that drivers don't need to use hard-coded interrupts. I
suppose we really should do that anyway.

	Brad Boyer
	flar@allandria.com

