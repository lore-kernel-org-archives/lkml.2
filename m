Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751500Ab2LUJiL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 04:38:11 -0500
Received: from mga09.intel.com ([134.134.136.24]:7918 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750983Ab2LUJiH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 04:38:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,329,1355126400"; 
   d="scan'208";a="260656635"
Subject: Re: [PATCH] spi: Add the flag indicate to registe new device as
 children of master or not.
From: Jun Chen <jun.d.chen@intel.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Bi Chao <chao.bi@intel.com>,
        spi-devel-general@lists.sourceforge.net, jun.zhang@intel.com
In-Reply-To: <20121219162142.9E1123E0B72@localhost>
References: <1355848174.1435.25.camel@chenjun-workstation>
	 <20121218152623.GA26077@sirena.org.uk>
	 <1355910243.1435.39.camel@chenjun-workstation>
	 <20121219090416.GK4985@opensource.wolfsonmicro.com>
	 <20121219162142.9E1123E0B72@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 21 Dec 2012 12:39:52 -0500
Message-ID: <1356111592.731.4.camel@chenjun-workstation>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-12-19 at 16:21 +0000, Grant Likely wrote:
> On Wed, 19 Dec 2012 09:04:16 +0000, Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:
> > On Wed, Dec 19, 2012 at 04:44:03AM -0500, Jun Chen wrote:
> > 
> > > This spi_alloc_device function will be called in the spi_new_device
> > > function to alloc new device as the master. But other way, it is called
> > > by the of_register_spi_devices function to register new device as the
> > > children of the master. I will update changlog to add it. 
> > 
> > But why is this a bad thing?  You've said what's happening but not why
> > it's a problem.
> 
> spi_devices should always be children of the spi_master. If that is not
> the case then it is a bug to be fixed.
> 

When many boards initializing, boards will call function
spi_register_board_info to create bi->board_info,Then spi driver probe
to call spi_register_master to register the driver and in the function
spi_match_master_to_boardinfo To create new spi device, and this cases
the spi_devices are not children of the spi_master.
Many drivers do these steps. If all spi_devices must be children of the
spi_master, Do spi core have plan to delete this way? 
Or spi core can hold this way for many drivers. 
Thanks! 


