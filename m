Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758039Ab2IEA3C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 20:29:02 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:19773 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993Ab2IEA27 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 20:28:59 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 04 Sep 2012 17:28:51 -0700
From: Bill Huang <bilhuang@nvidia.com>
To: Bill Huang <bilhuang@nvidia.com>
CC: "'Thierry Reding'" <thierry.reding@avionic-design.de>,
        "'sameo@linux.intel.com'" <sameo@linux.intel.com>,
        "'grant.likely@secretlab.ca'" <grant.likely@secretlab.ca>,
        "'rob.herring@calxeda.com'" <rob.herring@calxeda.com>,
        "'rob@landley.net'" <rob@landley.net>,
        "'broonie@opensource.wolfsonmicro.com'" 
	<broonie@opensource.wolfsonmicro.com>,
        Laxman Dewangan <ldewangan@nvidia.com>, Xin Xie <xxie@nvidia.com>,
        "'lrg@slimlogic.co.uk'" <lrg@slimlogic.co.uk>,
        "'jhovold@gmail.com'" <jhovold@gmail.com>,
        "'kyle.manna@fuel7.com'" <kyle.manna@fuel7.com>,
        Rhyland Klein <rklein@nvidia.com>,
        "'devicetree-discuss@lists.ozlabs.org'" 
	<devicetree-discuss@lists.ozlabs.org>,
        "'linux-doc@vger.kernel.org'" <linux-doc@vger.kernel.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Date: Wed, 5 Sep 2012 08:28:47 +0800
Subject: RE: [PATCH v2 1/2] mfd: dt: tps6586x: Add power off control
Thread-Topic: [PATCH v2 1/2] mfd: dt: tps6586x: Add power off control
Thread-Index: Ac2CcoqX3gqc2V1HRnm59y1GrfvayQBkqeUAAb31yOA=
Message-ID: <A7051F87A141B744BCAF487D48E5B3BDF5BA98285C@HKMAIL02.nvidia.com>
References: <1345424876-4365-1-git-send-email-bilhuang@nvidia.com>
 <1345424876-4365-2-git-send-email-bilhuang@nvidia.com>
 <20120820113423.GA5996@avionic-0098.mockup.avionic-design.de>
 <A7051F87A141B744BCAF487D48E5B3BDF5BA982847@HKMAIL02.nvidia.com>
 <A7051F87A141B744BCAF487D48E5B3BDF5BA98284B@HKMAIL02.nvidia.com>
 <503847C2.3080400@wwwdotorg.org>
 <A7051F87A141B744BCAF487D48E5B3BDF5BA98284E@HKMAIL02.nvidia.com>
In-Reply-To: <A7051F87A141B744BCAF487D48E5B3BDF5BA98284E@HKMAIL02.nvidia.com>
Accept-Language: zh-TW, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-TW, en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> nvpublic
> > On 08/24/2012 06:36 PM, Bill Huang wrote:
> > >>> On Sun, Aug 19, 2012 at 06:07:55PM -0700, Bill Huang wrote:
> > >>>> Add DT property "ti,system-power-controller" telling whether or
> > >>>> not this pmic is in charge of controlling the system power, so
> > >>>> the power off routine can be hooked up to system call "pm_power_off".
> > ...
> > >>> I've seen the following while trying this patch applied on top of next-20120817:
> > >>>
> > >>> [   40.581151] Power down.
> > >>> [   41.583160] ------------[ cut here ]------------
> > >>> [   41.587784] WARNING: at /home/thierry.reding/src/kernel/linux-
> ipmp.git/drivers/i2c/busses/i2c-
> > >>> tegra.c:525 tegra_i2c_xfer+0x21c/0x29c()
> > ...
> > >> Thanks Thierry, I can repro this on Tegra20 inconsistently and
> > >> found, if current cpu is not cpu0 when doing "machine_shutdown" (it
> > >> will call "smp_send_stop"), i2c controller will failed to do any
> > >> transaction (looks like gic interrupt
> > will be disabled), I'll debug further to find out the root cause.
> > >>
> > >> By the way, Tegra30 is good since it will always be cpu0 when doing
> > >> "machine_shutdown", I still don't know why it makes the difference
> > >> against Tegra20 since I'm not familiar with those cpu stuffs and
> > >> what make it behave differently,
> > I'll study a bit, thanks.
> > >
> > > I've sent the shutdown issue for discussion in ARM list: Shutdown
> > > problem in SMP system happened on
> > Tegra20.
> > > The cause of the i2c timeout is pretty clear now and it is not
> > > directly related to this patch, so is this patch series acceptable? Any thoughts or comment?
> Thanks.
> >
> > I tend to agree; power off never worked without this patch, and
> > sometimes does with the patch, due to nothing wrong with this patch.
> >
> > Bill, please do follow up on getting the underlying Tegra issue solved
> > somehow though. IIRC, Joseph Lo or Prashant has a patch which enabled
> > the config option that Russell mentioned, so the fix may just be to wait for that patch to get
> finalized, but please double-check that solves it.
> > Thanks!
> 
> As per the shutdown issue discussion, enabling CONFIG_PM_SLEEP_SMP is the only solution and I've
> confirmed that fix the issue, thanks.

Hi sameo,

Is there any concern on this patch series?

Thanks,
Bill
