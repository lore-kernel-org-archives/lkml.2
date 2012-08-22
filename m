Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758784Ab2HVIKc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 04:10:32 -0400
Received: from mga09.intel.com ([134.134.136.24]:16772 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756832Ab2HVIKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 04:10:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,808,1336374000"; 
   d="scan'208";a="183878816"
Date: Wed, 22 Aug 2012 16:04:39 +0800
From: Feng Tang <feng.tang@intel.com>
To: Alexander Stein <alexander.stein@systec-electronic.com>
Cc: <linux-i2c@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: Re: i2c-eg20t: regression since i2c_add_numbered_adapter change
Message-ID: <20120822160439.62c619bf@feng-i7>
In-Reply-To: <3514180.RWySLZuOJm@ws-stein>
References: <4401854.hVfHzgeqjT@ws-stein>
	<20120822152918.3e59616e@feng-i7>
	<3514180.RWySLZuOJm@ws-stein>
Organization: intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexander,

On Wed, 22 Aug 2012 09:57:07 +0200
Alexander Stein <alexander.stein@systec-electronic.com> wrote:

> Hello,
> 
> On Wednesday 22 August 2012 15:29:18, Feng Tang wrote:
> > On Wed, 22 Aug 2012 08:30:35 +0200
> > Alexander Stein <alexander.stein@systec-electronic.com> wrote:
> > 
> > > Hello,
> > > 
> > > I just noticed the 3.4 linux kernel fails to sucessfully probe the i2c-eg20t 
> > > driver. I returns with EBUSY error. It worked on the 3.0 kernel. To my view it 
> > > is caused the commit 07e8a51ff68353e01d795cceafbac9f54c49132b ( i2c-eg20t: use 
> > > i2c_add_numbered_adapter to get a fixed bus number).
> > > The reason it actually fails is that the i2c-isch driver is registered 
> > > beforehand which gets bus number 0. But this one is the bus number the eg20t 
> > > driver wants to register.
> > 
> > Make sense.
> > 
> > > A possibility is that if i2c_add_numbered_adapter failed with EBUSY just use 
> > > i2c_add_adapter to get at least the driver working, but with a non-fixed bus 
> > > number. Opinions?
> > 
> > Or can we give it a fixed offset, like let the i2c_eg20t controller bus number
> > start with 4? I don't expect there will be more than 4 other i2c controllers 
> > on EG20T compatible platforms.
> 
> Why use a fixed one? Give the driver (and maybe every i2c bus driver) a parameter which sets the base bus number it should use.
> E.g. i2c-eg20t.base-bus-num=2 so it will register the bus numbers starting from 2. If this parameter is unset. It would use the first free one, thus simply using i2c_add_adapter.

The reason we need a fixed number is it is easier for platform code
which needs to register dozens of i2c devices to different controllers
with i2c_register_board_info, and they need provide a bus number for
each i2c device, this _binding_ info is not detectable but have to
be fixed.

Yes, your module parameter "base-bus-num" sounds like a plan too,
at the cost of some extra setting in the kernel cmdline. And I'm fine
with all solutions as long as I can get a _fixed_ bus number so that
I can easily write the platform config code (I guess this is same
for device tree, and even ACPI 5.0)

Thanks,
Feng
