Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837Ab1E0UMn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 16:12:43 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:42390 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab1E0UMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 16:12:42 -0400
Date: Fri, 27 May 2011 14:12:40 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: David Daney <ddaney@caviumnetworks.com>
Cc: David Gibson <david@gibson.dropbear.id.au>,
        devicetree-discuss@lists.ozlabs.org, linux-mips@linux-mips.org,
        ralf@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v4 1/6] of: Allow scripts/dtc/libfdt to be used from
 kernel code
Message-ID: <20110527201240.GB6645@ponder.secretlab.ca>
References: <1305930343-31259-1-git-send-email-ddaney@caviumnetworks.com>
 <1305930343-31259-2-git-send-email-ddaney@caviumnetworks.com>
 <20110521063345.GB14828@yookeroo.fritz.box>
 <4DDA8FBC.1090904@caviumnetworks.com>
 <20110527032402.GD7793@yookeroo.fritz.box>
 <4DDFD622.1000102@caviumnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DDFD622.1000102@caviumnetworks.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 27, 2011 at 09:49:38AM -0700, David Daney wrote:
> On 05/26/2011 08:24 PM, David Gibson wrote:
> >On Mon, May 23, 2011 at 09:47:56AM -0700, David Daney wrote:
> >>On 05/20/2011 11:33 PM, David Gibson wrote:
> >>>On Fri, May 20, 2011 at 03:25:38PM -0700, David Daney wrote:
> >>>>To use it you need to do this in your Kconfig:
> >>>>
> >>>>	select LIBFDT
> >>>>
> >>>>And in the Makefile of the code using libfdt something like:
> >>>>
> >>>>ccflags-y := -include linux/libfdt_env.h -I$(src)/../../../scripts/dtc/libfdt
> >>>>
> >>>>Signed-off-by: David Daney<ddaney@caviumnetworks.com>
> >>>>---
> >>>>  drivers/of/Kconfig          |    3 +++
> >>>>  drivers/of/Makefile         |    2 ++
> >>>>  drivers/of/libfdt/Makefile  |    3 +++
> >>>>  drivers/of/libfdt/fdt.c     |    2 ++
> >>>>  drivers/of/libfdt/fdt_ro.c  |    2 ++
> >>>>  drivers/of/libfdt/fdt_wip.c |    2 ++
> >>>
> >>>No fdt_sw.c or fdt_rw.c?
> >>>
> >>
> >>I had no immediate need for them.  They could of course be added,
> >>but that would potentially waste space.
> >>
> >>Let's see if I can make it into an archive library.
> >
> >That would be preferable.  It's more or less designed to work that way
> >so that everything is available without using unnecessary space in the
> >binary.
> >
> 
> Well, I was looking at this some more:
> 
> Grant specifically requested that this go in drivers/of/libfdt,
> however I am fairly sure that building archive libraries there will
> require changes to the upper level Makefile infrastructure.
> 
> If I go back to lib/libfdt, like my first version, I can easily
> achieve archive library behavior, but then it is separated from from
> drivers/of.
> 
> Personally I am starting to like the lib/libfdt home more than
> drivers/of.  If Grant doesn't object, I think I will move it back
> there.

okay.

g.

