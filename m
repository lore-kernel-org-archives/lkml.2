Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387Ab2KTPCp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 10:02:45 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:27384 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858Ab2KTPCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 10:02:44 -0500
Message-id: <50AB9B90.1030404@samsung.com>
Date: Tue, 20 Nov 2012 16:02:40 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121026
 Thunderbird/16.0.2
MIME-version: 1.0
To: Kevin Liu <keyuan.liu@gmail.com>
Cc: Chris Ball <cjb@laptop.org>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>, lrg@ti.com,
        Philip Rakity <prakity@nvidia.com>
Subject: Re: FW: [PATCH v2] mmc: sdhci: apply voltage range check only for
 non-fixed regulators
References: <25B60CDC2F704E4E9D88FFD52780CB4C060FBEA29A@SC-VEXCH1.marvell.com>
 <CADz5_gLC=z_VYrNq8q3dU7L6im7shSz-Sn6Tzym2mRZONwpgUg@mail.gmail.com>
 <50AB34E2.1010206@samsung.com>
 <CADz5_gKdUq8bjuMr1=yo65ysHzLNvKnrfVuSpLk-Q6ek-TWpNA@mail.gmail.com>
 <50AB587F.3040405@samsung.com>
 <CADz5_gJ1hV3n-4BPgBNT9LDp2-E=vNNzMGx=_9PmzT0RJ9+TsA@mail.gmail.com>
 <50AB81C8.4090300@samsung.com>
 <CADz5_gL3uHbvhb2ccp03=9P88u1Catxe9+Xffs3KmJsZGWmWvA@mail.gmail.com>
In-reply-to: <CADz5_gL3uHbvhb2ccp03=9P88u1Catxe9+Xffs3KmJsZGWmWvA@mail.gmail.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 11/20/2012 3:14 PM, Kevin Liu wrote:
> 2012/11/20 Marek Szyprowski <m.szyprowski@samsung.com>:
> > Hello,
> >
> >
> > On 11/20/2012 12:36 PM, Kevin Liu wrote:
> >>
> >> 2012/11/20 Marek Szyprowski <m.szyprowski@samsung.com>:
> >> > On 11/20/2012 9:59 AM, Kevin Liu wrote:
> >> >> 2012/11/20 Marek Szyprowski <m.szyprowski@samsung.com>:
> >> >> > On 11/14/2012 8:11 AM, Kevin Liu wrote:
> >> >> >>
> >> >> >> > From: linux-mmc-owner@vger.kernel.org
> >> >> >> > [mailto:linux-mmc-owner@vger.kernel.org] On Behalf Of Chris Ball
> >> >> >> > Sent: Tuesday, November 13, 2012 10:14 PM
> >> >> >> > To: Marek Szyprowski
> >> >> >> > Cc: linux-kernel@vger.kernel.org; linux-mmc@vger.kernel.org;
> >> >> >> > Kyungmin
> >> >> >> > Park; Mark Brown; Liam Girdwood; Philip Rakity
> >> >> >> > Subject: Re: [PATCH v2] mmc: sdhci: apply voltage range check only
> >> >> >> > for non-fixed regulators
> >> >> >> > On Tue, Nov 13 2012, Marek Szyprowski wrote:
> >> >> >> >>> On Tue, Nov 13 2012, Marek Szyprowski wrote:
> >> >> >> >>> > Fixed regulators cannot change their voltage, so disable all
> >> >> >> >>> > voltage
> >> >> >> >>> > range checking for them, otherwise the driver fails to operate
> >> >> >> >>> > with
> >> >> >> >>> > fixed regulators. Up to now it worked only by luck, because
> >> >> >> >>> > regulator_is_supported_voltage() function returned incorrect
> >> >> >> >>> > values.
> >> >> >> >>> > Commit "regulator: fix voltage check in
> >> >> >> >>> > regulator_is_supported_voltage()"
> >> >> >> >>> > fixed that function and now additional check is needed for
> >> >> >> >>> > fixed
> >> >> >> >>> > regulators.
> >> >> >> >>> >
> >> >> >> >>> > Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> >> >> >> >>> > ---
> >> >> >> >>> >  drivers/mmc/host/sdhci.c |    2 +-
> >> >> >> >>> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >> >> >> >>> >
> >> >> >> >>> > diff --git a/drivers/mmc/host/sdhci.c
> >> >> >> >>> > b/drivers/mmc/host/sdhci.c
> >> >> >> >>> > index c7851c0..6f6534e 100644
> >> >> >> >>> > --- a/drivers/mmc/host/sdhci.c
> >> >> >> >>> > +++ b/drivers/mmc/host/sdhci.c
> >> >> >> >>> > @@ -2923,7 +2923,7 @@ int sdhci_add_host(struct sdhci_host
> >> >> >> >>> > *host)
> >> >> >> >>> >            regulator_enable(host->vmmc);
> >> >> >> >>> >
> >> >> >> >>> >  #ifdef CONFIG_REGULATOR
> >> >> >> >>> > -  if (host->vmmc) {
> >> >> >> >>> > +  if (host->vmmc && regulator_count_voltages(host->vmmc) > 1)
> >> >> >> >>> > {
> >> >> >> >>> >            ret = regulator_is_supported_voltage(host->vmmc,
> >> >> >> >>> > 3300000,
> >> >> >> >>> >                    3300000);
> >> >> >> >>> >            if ((ret <= 0) || (!(caps[0] & SDHCI_CAN_VDD_330)))
> >> >> >> >>>
> >> >> >> >>> Thanks for the longer explanation.  I'm still missing something,
> >> >> >> >>> though;
> >> >> >> >>> what's wrong with running the check as it was with the new
> >> >> >> >>> regulator
> >> >> >> >>> code?
> >> >> >> >>> (I haven't tried it yet.)
> >> >> >> >>>
> >> >> >> >>> #ifdef CONFIG_REGULATOR
> >> >> >> >>>          if (host->vmmc) {
> >> >> >> >>>                  ret =
> >> >> >> >>> regulator_is_supported_voltage(host->vmmc,
> >> >> >> >>> 3300000,
> >> >> >> >>>                          3300000);
> >> >> >> >>>                  if ((ret <= 0) || (!(caps[0] &
> >> >> >> >>> SDHCI_CAN_VDD_330)))
> >> >> >> >>>                          caps[0] &= ~SDHCI_CAN_VDD_330;
> >> >> >> >>>                  ret =
> >> >> >> >>> regulator_is_supported_voltage(host->vmmc,
> >> >> >> >>> 3000000,
> >> >> >> >>>                          3000000);
> >> >> >> >>>                  if ((ret <= 0) || (!(caps[0] &
> >> >> >> >>> SDHCI_CAN_VDD_300)))
> >> >> >> >>>                          caps[0] &= ~SDHCI_CAN_VDD_300;
> >> >> >> >>>                  ret =
> >> >> >> >>> regulator_is_supported_voltage(host->vmmc,
> >> >> >> >>> 1800000,
> >> >> >> >>>                          1800000);
> >> >> >> >>>                  if ((ret <= 0) || (!(caps[0] &
> >> >> >> >>> SDHCI_CAN_VDD_180)))
> >> >> >> >>>                          caps[0] &= ~SDHCI_CAN_VDD_180;
> >> >> >> >>>          }
> >> >> >> >>> #endif /* CONFIG_REGULATOR */
> >> >> >> >>>
> >> >> >> >>> The point is to remove unsupported voltages, so if someone sets
> >> >> >> >>> up
> >> >> >> >>> a
> >> >> >> >>> fixed regulator at 3300000, all of the other caps are disabled.
> >> >> >> >>> Why
> >> >> >> >>> wouldn't that work without this change, and how are we supposed
> >> >> >> >>> to
> >> >> >> >>> remove those caps on a fixed regulator after your patchset?
> >> >> >> >>>
> >> >> >> >>> Thanks, sorry if I'm missing something obvious,
> >> >> >> >>
> >> >> >> >> On our boards eMMC is connected to fixed 2.8V regulator, what
> >> >> >> >> results
> >> >> >> >> in
> >> >> >> >> clearing all available voltages and fail. The same situation is
> >> >> >> >> when
> >> >> >> >> one
> >> >> >> >> enable dummy regulator and try to use sdhci with it. My patch
> >> >> >> >> fixes
> >> >> >> >> this
> >> >> >> >> and restores sdhci to working state as it was before (before
> >> >> >> >> fixing
> >> >> >> >> regulator regulator_is_supported_voltage() function and earlier
> >> >> >> >> when
> >> >> >> >> MMC_BROKEN_VOLATGE capability was used).
> >> >> >> >
> >> >> >> > I see.  Sounds like a separate bug -- Philip (or anyone else), any
> >> >> >> > idea how we should be treating eMMCs with a fixed voltage here?
> >> >> >> >
> >> >> >>
> >> >> >> I think we should check the voltage range rather than the voltage
> >> >> >> point accoring to the spec.
> >> >> >> Otherwise some valid voltage like 2.8v will be discarded by mistake.
> >> >> >> My below old patch aim to fix this issue.
> >> >> >> How do you think?
> >> >> >>
> >> >> >> -----Original Message-----
> >> >> >> From: Kevin Liu [mailto:keyuan.liu@gmail.com]
> >> >> >> Sent: Friday, September 28, 2012 3:56 PM
> >> >> >> To: linux-mmc@vger.kernel.org; cjb@laptop.org; pierre@ossman.eu;
> >> >> >> ulf.hansson@linaro.org; Zhangfei Gao
> >> >> >> Cc: Haojian Zhuang; Chao Xie; Philip Rakity; Kevin Liu; Jialing Fu
> >> >> >> Subject: [PATCH v5 03/13] mmc: sdhci: use regulator min/max voltage
> >> >> >> range according to spec
> >> >> >>
> >> >> >> From: Kevin Liu <kliu5@marvell.com>
> >> >> >>
> >> >> >> For regulator vmmc/vmmcq, use voltage range as below
> >> >> >> 3.3v/3.0v: (2.7v, 3.6v)
> >> >> >> 1.8v: (1.7v, 1.95v)
> >> >> >> Original code use the specific value which may fail in regulator
> >> >> >> driver if it does NOT support the specific voltage.
> >> >> >>
> >> >> >> Signed-off-by: Jialing Fu <jlfu@marvell.com>
> >> >> >> Signed-off-by: Kevin Liu <kliu5@marvell.com>
> >> >> >
> >> >> >
> >> >> > Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
> >> >> >
> >> >> > This patch restores sdhci devices to working state on Samsung boards
> >> >> > (tested on GONI and UniversalC210) after merging "regulator: fix
> >> >> > voltage
> >> >> > check in regulator_is_supported_voltage()" patch to v3.7-rc6 (commit
> >> >> > f0f98b19e23d4426ca185e3d4ca80e6aff5ef51b). Would be great to have it
> >> >> > merged before the final v3.7 is out.
> >> >> >
> >> >> Marek,
> >> >>
> >> >> thanks a lot for the verification!
> >> >> And your patch "mmc: sdhci: apply voltage range check only for
> >> >> non-fixed regulators" (commit
> >> >> d5b5205f2d480a47863dda0772d2d9dc47c2b51b, which has been merged in
> >> >> mmc-next) can be reverted if this patch merged?
> >> >
> >> >
> >> > Yes, it can be replaced with it, although there is still an issue that
> >> > need
> >> > to be resolved somehow. Right now SDHCI driver fails to initialize if
> >> > support
> >> > for dummy regulator is enabled.
> >> >
> >> Then I think the dummy issue can be resolved with your patch merged
> >> and if you can just update your patch from
> >>       "regulator_count_voltages(host->vmmc) > 1"
> >> to
> >>       "regulator_count_voltages(host->vmmc) > 0"
> >> to let fix regulator work.
> >
> >
> > regulator_count_voltages() returns 1 for both fixed regulators and for
> > virtual dummy regulator, so the above change makes no sense.
>
> I think regulator_count_voltage should return -EINVAL for dummy
> regulator since n_voltages is not defined for dummy regulator:
> int regulator_count_voltages(struct regulator *regulator)
> {
>          struct regulator_dev    *rdev = regulator->rdev;
>
>          return rdev->desc->n_voltages ? : -EINVAL;
> }
> can you double check this?

Err, right. I looked at the wrong SDHCI device :/ I have 3 of them on my
board - one with fixed regulator, one with 'real' and one without (with
virtual dummy regulator). I've applied my earlier patch and noticed that
it cured sdhci driver with dummy regulator, so I concluded that it did
the right job. Sorry for the confusion.

> > However I was so focused on fixing the 2.8V supply case that I missed the
> > fact that my "mmc: sdhci: apply voltage range check only for non-fixed
> > regulators" patch also fixed the dummy regulator case.
> >
> > The conclusion is that applying both patches should finally fix the
> > regulator issues with for the Samsung boards (2.8V supply for eMMC) and
> > 'dummy-regulators' cases.
> >
>
> After thinking again, I think we don't need the check for
> regulator_count_voltages.
> In fact, dummy regulator should NOT be used for the sd/mmc power
> supply. We should use controllable or fixed regulator. If dummy
> regulator is used, then it means we won't control it and we don't know
> its voltage. It's not reasonable for sd/mmc power supply. If dummy
> regulator is used, I think it's ok to return error and disable all
> voltage support caps.

The problem with dummy regulator is the fact that it can be enabled only
globally for all devices in the system. I think that the best solution
would be to introduce regulator_can_change_voltage() as Mark suggested.
I will post patches soon.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


