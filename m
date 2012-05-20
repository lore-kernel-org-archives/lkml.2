Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212Ab2ETHY1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 03:24:27 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:6305 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096Ab2ETHYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 03:24:25 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Sun, 20 May 2012 00:23:10 -0700
Message-ID: <4FB89AEF.3080107@nvidia.com>
Date: Sun, 20 May 2012 12:49:11 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "lrg@ti.com" <lrg@ti.com>, Stephen Warren <swarren@nvidia.com>,
        "olof@lixom.net" <olof@lixom.net>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH V3 2/4] regulator: tps62360: add dt support
References: <1336718325-8372-1-git-send-email-ldewangan@nvidia.com> <1336718325-8372-3-git-send-email-ldewangan@nvidia.com> <20120511145833.GG3960@opensource.wolfsonmicro.com> <4FAD31A5.7090006@nvidia.com> <20120511213001.GD29835@opensource.wolfsonmicro.com>
In-Reply-To: <20120511213001.GD29835@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 12 May 2012 03:00 AM, Mark Brown wrote:
> * PGP Signed by an unknown key
>
> On Fri, May 11, 2012 at 09:05:01PM +0530, Laxman Dewangan wrote:
>
>> I think this is not require to enable always otherwise there may be
>> power dissipation from this path always, just when we off the rail
>> (disable rail or when go to shutdown so that the voltage output can
>> go down faster).
>> Should we add "unsigned en_discharge:1" in regulator init data but
>> did not get how core driver can use this flag specially when
>> shutdown?
> Oh, now you say this I think I remember discussing this with you before!
> This is pretty unusual for such hardware.  Normally there's something in
> the digital block so that the discharge is only enabled if the regulator
> is disabled, if it's enabled then the discharge would automatically be
> taken off since actively discharging while enabled doesn't make sense
> and may in fact be actively harmful.
>

Just to share  here with our new pmu which we got recently, the 
discharge path behavior is exactly same as what Mark mentioned
It need to be enable always. The pmu auto disable the DISC path in 
normal operation so there is no power dissipation but when it detects 
the en_bit is written 0 or any external control is making the rail to be 
off, it automatically turn on the path so that ramp-down can happen faster.
Just we need to enable this always.

> If the hardware doesn't do that then I'd expect the driver to take care
> of this if it implements the framework feature (once the framework
> feature is added).

