Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613Ab1BHLvn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 06:51:43 -0500
Received: from service87.mimecast.com ([94.185.240.25]:38973 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753516Ab1BHLvm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 06:51:42 -0500
Subject: Re: Device Tree on ARM status report
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
        linaro-dev <linaro-dev@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <AANLkTi=dK2qYTH7vThJb8-3wED5F_5Hcmr7nNidxs25c@mail.gmail.com>
References: <AANLkTikLvO0Y44nCxEfCsNxU-Na+PzcLXZUjOsMUM1_A@mail.gmail.com>
	 <20110207084613.GC2723@matterhorn.lan>
	 <AANLkTi=dK2qYTH7vThJb8-3wED5F_5Hcmr7nNidxs25c@mail.gmail.com>
Date: Tue, 08 Feb 2011 11:51:35 +0000
Message-ID: <1297165895.31587.62.camel@e102568-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1
X-OriginalArrivalTime: 08 Feb 2011 11:51:37.0272 (UTC) FILETIME=[8A75EB80:01CBC786]
X-MC-Unique: 111020811513904901
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-02-07 at 14:28 -0700, Grant Likely wrote:
> On Mon, Feb 7, 2011 at 1:46 AM, Amit Kucheria <amit.kucheria@linaro.org> wrote:
> > On 11 Feb 05, Grant Likely wrote:
> >> 2 - Task status
> >> ---------------
> >> Core infrastructure:
> >> [glikely] basic infrastructure to enable dt: DONE
> >> [r-herring] Allow dtb to be located anywhere in RAM: DONE
> >> [bones] Debug dtb corruption during init: INPROGRESS
> >> [glikely] OF clock bindings: INPROGRESS
> >
> > Does this include the common clock framework that Jeremy had been working on?
> > I see no mention of that explicitly, hence the question.
> 
> No, since the common clk patches are taking some time to get right,
> the device tree clock bindings have been decoupled from the common clk
> patches so that dt support doesn't get held up.  When common clk gets
> merged, the dt support will be modified to use it.
> 

Ok Grant, good to know. I did not have time to check how the bindings
changed, but at least for vexpress I was registering and binding clocks
from DT. Here is the vexpress list of tasks updated.

Versatile express tasks:
[lorenzo-pieralisi] enable dtb support in u-boot: DONE within Linaro ?
[lorenzo-pieralisi] enable basic kernel dtb support on versatile
express: DONE
[lorenzo-pieralisi] probe clocks from dt: DONE
[lorenzo-pieralisi] probe irq controllers from device tree: DONE (basic
GIC init - interrupt routing is not there yet)
[lorenzo-pieralisi] register devices from dt: 

Currently all vexpress platform devices are registered from the DT code,
but I have to rebase to see if things changed wrt test-devicetree 
branch.

They include:

smsc911x (mdio inclusive but pending code to probe irq type)
isp1760
flash physmap
amba-pl011
amba-clcd-pl11x
PMU
mmc-pl18x

The GIC and sp804 timers are also initialized from DT (they need not be
platform devices though).

Please let me know if you need further details.

Lorenzo






