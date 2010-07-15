Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934647Ab0GOUG6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 16:06:58 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:55569 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934613Ab0GOUG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 16:06:56 -0400
Date: Thu, 15 Jul 2010 21:06:18 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Lee Jones <lee.jones@canonical.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] Stop ARM boards crashing when CUPS is loaded -
	2.6.35-rc5
Message-ID: <20100715200618.GA6773@n2100.arm.linux.org.uk>
References: <4C3C72C6.4000005@canonical.com> <20100715130214.4c9303b2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100715130214.4c9303b2.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 15, 2010 at 01:02:14PM -0700, Andrew Morton wrote:
> > BugLink: http://bugs.launchpad.net/bugs/601226
> > 
> > When CUPS loads, it tries to load several drivers that it may need.
> > When one of these drivers, specifically parport_pc is loaded on ARM
> > based systems, it causes a segmentation fault as the ISA addresses
> > which are attempted are not writable on non-PC based architectures.
> > This code prevents ISA addresses from being attempted except on x86.
> > 
> 
> That sounds like a pretty serious problem.  But presumably it isn't -
> otherwise it would have been fixed earlier!
> 
> So what actions are required to trigger this bug and why aren't others
> seeing it?

Note that we have machines which have ISA parallel ports, so it's not
this simple.

Why not just avoid selecting and building parport_pc on these machines?

I mean, the Beagleboard doesn't have PCI nor ISA, so why is parport_pc
being built for production use?
