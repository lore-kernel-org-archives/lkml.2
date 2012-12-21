Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751212Ab2LVJvy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2012 04:51:54 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:47176 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832Ab2LVJvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2012 04:51:51 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] spi: Add the flag indicate to registe new device as children of master or not.
To: Jun Chen <jun.d.chen@intel.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Bi Chao <chao.bi@intel.com>,
        spi-devel-general@lists.sourceforge.net, jun.zhang@intel.com
In-Reply-To: <1356111592.731.4.camel@chenjun-workstation>
References: <1355848174.1435.25.camel@chenjun-workstation> <20121218152623.GA26077@sirena.org.uk> <1355910243.1435.39.camel@chenjun-workstation> <20121219090416.GK4985@opensource.wolfsonmicro.com> <20121219162142.9E1123E0B72@localhost> <1356111592.731.4.camel@chenjun-workstation>
Date: Fri, 21 Dec 2012 19:06:18 +0000
Message-Id: <20121221190618.6D6D03E0C98@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Dec 2012 12:39:52 -0500, Jun Chen <jun.d.chen@intel.com> wrote:
> On Wed, 2012-12-19 at 16:21 +0000, Grant Likely wrote:
> > On Wed, 19 Dec 2012 09:04:16 +0000, Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:
> > > On Wed, Dec 19, 2012 at 04:44:03AM -0500, Jun Chen wrote:
> > > 
> > > > This spi_alloc_device function will be called in the spi_new_device
> > > > function to alloc new device as the master. But other way, it is called
> > > > by the of_register_spi_devices function to register new device as the
> > > > children of the master. I will update changlog to add it. 
> > > 
> > > But why is this a bad thing?  You've said what's happening but not why
> > > it's a problem.
> > 
> > spi_devices should always be children of the spi_master. If that is not
> > the case then it is a bug to be fixed.
> > 
> 
> When many boards initializing, boards will call function
> spi_register_board_info to create bi->board_info,Then spi driver probe
> to call spi_register_master to register the driver and in the function
> spi_match_master_to_boardinfo To create new spi device, and this cases
> the spi_devices are not children of the spi_master.
> Many drivers do these steps. If all spi_devices must be children of the
> spi_master, Do spi core have plan to delete this way? 
> Or spi core can hold this way for many drivers. 

Let me make sure I understand what you're saying...

Right now, every spi_device object is registered as a child of an
spi_master object.

With this proposed patch, spi_devices registered via spi_register_board_info
will be siblings of the spi_master instead of children.

Do I understand correctly so far?

The problem is that I don't understand why this change is necessary.
spi_devices should always be children of an spi_master, not siblings.
What is the problem you're trying to solve with this change?

g.

