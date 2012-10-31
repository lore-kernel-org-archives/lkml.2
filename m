Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827Ab2JaGWK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 02:22:10 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:55178 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817Ab2JaGWF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 02:22:05 -0400
X-AuditID: cbfee61b-b7f616d00000319b-dc-5090c38a9b0d
From: Jonghwan Choi <jhbird.choi@samsung.com>
To: jonghwa3.lee@samsung.com
Cc: "'open list'" <linux-kernel@vger.kernel.org>,
        "'Amit Daniel Kachhap'" <amit.kachhap@linaro.org>,
        "'Zhang Rui'" <rui.zhang@intel.com>,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>
References: <000101cdb660$05e7ded0$11b79c70$%choi@samsung.com>
 <5090B1C9.9050000@samsung.com>
In-reply-to: <5090B1C9.9050000@samsung.com>
Subject: RE: [PATCH 2/2] therma: exynos: Supports thermal tripping
Date: Wed, 31 Oct 2012 15:22:02 +0900
Message-id: <00f301cdb730$0a6ea8f0$1f4bfad0$%choi@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac23JXd9/3SL6a93TDGghTMMhGloPAACklsA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLLMWRmVeSWpSXmKPExsVy+t9jAd2uwxMCDK5t1bC4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZm7d/ZyyYolyxvbmbrYHxrFQXIyeHhICJxM87d1khbDGJC/fW
	s3UxcnEICSxilPh95gAjhDOPSWLd2042kCo2AV2JY+u3gHWICMhIrLz6kwmkiFlgA6PEmnuf
	gIo4gDriJTbNdwGp4RTQltg7fw8jiC0s4CTReGk7M4jNIqAqsXzac7A5vAJ2Esen/WCCsAUl
	fky+xwJiMwuoS0yat4gZwtaWePLuAivIeAmg+KO/uhAnGEkc2b+DDaJERGLfi3eMExiFZiGZ
	NAvJpFlIJs1C0rKAkWUVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnAgP5PewbiqweIQowAH
	oxIPr8G//gAh1sSy4srcQ4wSHMxKIrwlMyYECPGmJFZWpRblxxeV5qQWH2KU5mBREudt9kgJ
	EBJITyxJzU5NLUgtgskycXBKNTCavmx3/pBVm9h0/6+74rwwqf3mOkcvbr61RsX376EJ/2Vf
	sTT+m8vmfkVjOstODdl+ptqa0qS334KKmmMyeNd63J2QkOzlun1+wC+BzpXHf3NXRB8XdFNd
	w1dsx1OXw+T4flf0rjtKJhdj+H7MZP68UmHOry98PjMnlrBMsUtr1u0UnsK457gSS3FGoqEW
	c1FxIgA1BLtkYAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks.
Let me check.

> -----Original Message-----
> From: jonghwa3.lee@samsung.com [mailto:jonghwa3.lee@samsung.com]
> Sent: Wednesday, October 31, 2012 2:06 PM
> To: Jonghwan Choi
> Cc: 'open list'; 'Amit Daniel Kachhap'; 'Zhang Rui'; 'Sachin Kamat'
> Subject: Re: [PATCH 2/2] therma: exynos: Supports thermal tripping
> 
> On 2012년 10월 30일 14:32, Jonghwan Choi wrote:
> > TMU urgently sends active-high signal (thermal trip) to PMU,
> > and thermal tripping by hardware logic i.e PMU is performed.
> > Thermal tripping means that PMU cut off the whole power of SoC
> > by controlling external voltage regulator.
> >
> > Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
> > ---
> >  drivers/thermal/exynos_thermal.c             |    7 ++++++-
> >  include/linux/platform_data/exynos_thermal.h |    4 ++++
> >  2 files changed, 10 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/thermal/exynos_thermal.c
> > b/drivers/thermal/exynos_thermal.c
> > index 6ce6667..edac601 100644
> > --- a/drivers/thermal/exynos_thermal.c
> > +++ b/drivers/thermal/exynos_thermal.c
> > @@ -53,6 +53,7 @@
> >  #define EXYNOS_TMU_TRIM_TEMP_MASK      0xff
> >  #define EXYNOS_TMU_GAIN_SHIFT          8
> >  #define EXYNOS_TMU_REF_VOLTAGE_SHIFT   24
> > +#define EXYNOS_TMU_TRIP_EN             BIT(12)
> >  #define EXYNOS_TMU_CORE_ON             1
> >  #define EXYNOS_TMU_CORE_OFF            0
> >  #define EXYNOS_TMU_DEF_CODE_TO_TEMP_OFFSET     50
> > @@ -656,6 +657,8 @@ static void exynos_tmu_control(struct
> platform_device
> > *pdev, bool on)
> >         if (data->soc == SOC_ARCH_EXYNOS) {
> >                 con |= pdata->noise_cancel_mode <<
> > EXYNOS_TMU_TRIP_MODE_SHIFT;
> >                 con |= (EXYNOS_MUX_ADDR_VALUE << EXYNOS_MUX_ADDR_SHIFT);
> > +               if (pdata->trip_en)
> > +                       con |= EXYNOS_THERMAL_TRIP_EN;
> >         }
> >
> >         if (on) {
> > @@ -762,10 +765,12 @@ static struct exynos_tmu_platform_data const
> > exynos_default_tmu_data = {
> >         .trigger_levels[0] = 85,
> >         .trigger_levels[1] = 103,
> >         .trigger_levels[2] = 110,
> > +       .trigger_levels[3] = 120,
> >         .trigger_level0_en = 1,
> >         .trigger_level1_en = 1,
> >         .trigger_level2_en = 1,
> > -       .trigger_level3_en = 0,
> > +       .trigger_level3_en = 1,
> > +       .trip_en = 1,
> >         .gain = 8,
> >         .reference_voltage = 16,
> >         .noise_cancel_mode = 4,
> > diff --git a/include/linux/platform_data/exynos_thermal.h
> > b/include/linux/platform_data/exynos_thermal.h
> > index a7bdb2f..9e44aac 100644
> > --- a/include/linux/platform_data/exynos_thermal.h
> > +++ b/include/linux/platform_data/exynos_thermal.h
> > @@ -79,6 +79,9 @@ struct freq_clip_table {
> >   * @trigger_level3_en:
> >   *     1 = enable trigger_level3 interrupt,
> >   *     0 = disable trigger_level3 interrupt
> > + * @trip_en:
> > + *     1 = enable thermal tripping
> > + *     0 = disable thermal tripping
> >   * @gain: gain of amplifier in the positive-TC generator block
> >   *     0 <= gain <= 15
> >   * @reference_voltage: reference voltage of amplifier
> > @@ -102,6 +105,7 @@ struct exynos_tmu_platform_data {
> >         bool trigger_level1_en;
> >         bool trigger_level2_en;
> >         bool trigger_level3_en;
> > +       bool trip_en;
> I think this variable addition is not necessary. It's enough to use
> trigger_level3_en variable
> to determine hardware thermal tripping enable or not. Since exynos4210
> has different register map from
> other exynos SOC's, trigger level 3 enable is existed different region.
> exynos4210 has it in
> interrupt enable register and others has it in TMU core control register
> (exynos4x12 and exynos5
> doesn't have trigger_level3_en bit in interrupt enable register).
> Thus it's better to use trigger_level3_en variable to enable hardware
> thermal tripping support for compatibility.
> 
> Thanks,
> Jonghwa Lee.
> >
> >         u8 gain;
> >         u8 reference_voltage;
> > --
> > 1.7.4.1
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel"
> in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >

