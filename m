Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755773Ab2CYKhq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 06:37:46 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:56551 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755676Ab2CYKhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 06:37:45 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 25 Mar 2012 12:37:40 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: On patch "device.h: audit and cleanup users in main include
 dir"
Message-ID: <20120325123740.7cab722b@stein>
In-Reply-To: <20120325010513.GC12203@windriver.com>
References: <20120324212125.460c89d3@stein>
	<20120325010513.GC12203@windriver.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mar 24 Paul Gortmaker wrote:
> [On patch "device.h: audit and cleanup users in main include dir"] On 24/03/2012 (Sat 21:21) Stefan Richter wrote:
[...]
> > struct fw_device and struct fw_unit, defined in include/firewire.h,
> > incorporate struct device.
> 
> Hi Stefan,
> 
> You are correct.  I did read them all and check instances of device, so
> I'm not sure how I misread this file.  Did you have a specific build
> that triggered a failure, or you just happened to spot it? I'm guessing
> that it gets device.h by another path and hence won't show up in build
> coverage.

I just saw the commit coming in; there is no build failure.  (I should have
test-built before posting.)  All files which include linux/firewire.h
evidently include linux/device.h before it.

> If so I'll definitely get it fixed, but I might wait a day or two to see
> if anything else pops up, if it isn't explicitly causing any breakage.

If you don't receive any issues with the rest of your tree-wide commit,
just do nothing and I will add a trivial firewire.h correction myself for
the next merge window.

> > Furthermore, the inline function definitions
> >     fw_device,
> >     fw_unit,
> >     fw_unit_get,
> >     fw_unit_put,
> >     fw_parent_device
> > all require definitions from linux/device.h.

Correcting myself:  Only the the latter three of these use linux/device.h.
-- 
Stefan Richter
-=====-===-- --== ==--=
http://arcgraph.de/sr/
