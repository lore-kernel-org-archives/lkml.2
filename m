Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756716Ab0ITPNp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 11:13:45 -0400
Received: from mga11.intel.com ([192.55.52.93]:42111 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756707Ab0ITPNo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 11:13:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,394,1280732400"; 
   d="scan'208";a="839242648"
Date: Mon, 20 Sep 2010 15:27:26 +0100
From: Alan Cox <alan@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] x86/mrst: add SFI platform device parsing code
Message-ID: <20100920152726.68ac2d84@linux.intel.com>
In-Reply-To: <20100920150431.GD31167@sirena.org.uk>
References: <20100920140049.31408.67527.stgit@localhost.localdomain>
	<20100920150431.GD31167@sirena.org.uk>
Organization: Intel
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +static void *lis331dl_platform_data(void *info)
> > +{
> > +	static short intr2nd_pdata;
> > +	struct i2c_board_info *i2c_info = (struct i2c_board_info
> > *)info;
> 
> It's rather concerning that the parser here needs to have all this
> knowledge about the specific chips that will be on the boards.  Is
> there a plan for how this will be managed once system integrators
> begin putting other chips onto Moorestown boards?

It depends on the device. The information for the platform device has
to come from somewhere and the kernel has no formal standard structure
for private data passed from platform devices - so in a lot of cases
its really just the needed glue so the platform device code in
drivers/i2c etc stays independent.

For a device that doesn't need any private structure passing it's just
a case of knowing the Linux name that matches the firmware description.
For a chip that already has a Linux driver that expects private data
(or a new driver that needs to) the info has to come from somewhere and
Linux packages it in per device fashion.

The parser has the knowledge precisely because we don't want to put the
knowledge in the driver.

Alan

