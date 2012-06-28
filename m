Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758008Ab2F1CIP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 22:08:15 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:45389 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753785Ab2F1CIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 22:08:13 -0400
X-AuditID: cbfee60c-b7fe66d0000058a5-a1-4febbc8a54ff
Date: Thu, 28 Jun 2012 02:08:10 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH] Extcon: Arizona: Add driver for Wolfson Arizona class
 devices
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>,
        "patches@opensource.wolfsonmicro.com" 
	<patches@opensource.wolfsonmicro.com>,
        "cw00.choi@samsung.com" <cw00.choi@samsung.com>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20120628020732299@myungjoo.ham
Msgkey: 20120628020732299@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20120628020732299@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <30036799.190541340849289982.JavaMail.weblogic@epml02>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHIsWRmVeSWpSXmKPExsVy+t/t6bpde177G8w8rG1xedccNgdGj8+b
	5AIYo7hsUlJzMstSi/TtErgyVq94zlzQY1nxqfMlYwPjGfMuRk4OIQF1iUVLTrKB2BICJhKL
	29cyQdhiEhfurQeKcwHVzGeUWPlzBksXIwcHi4CqRGuHNYjJJqAnMfNzMki5sECQxPbjC1hA
	bBGBcol3/avARjIL/GCU6NwqBbFKSWLNvldgNbwCghInZz5hgVgFNPHnLqi4msSEhn+MEHEJ
	iVnTL7BC2LwSM9qfQtXLSUz7uoYZwpaWOD9rAyPMyYu/P4aK80scu72DCeRMkN4n94Nhxuze
	/AXqWwGJqWcOQrVqSbTemge1ik9izcK3LDBjdp1azgzxiqLElO6H7BC2lsSXH/vY0L3CK+Ak
	8XXhQpYJjLKzkKRmIWmfhaQdWc0CRpZVjKKpBckFxUnpqUZ6xYm5xaV56XrJ+bmbGMGx/Ixn
	B+OcBotDjAIcjEo8vDc2vvYXYk0sK67MPcQowcGsJML7PQ4oxJuSWFmVWpQfX1Sak1p8iFGa
	g0VJnHey9QV/IYH0xJLU7NTUgtQimCwTB6dUAyNH7IdkI/05N/jDmhX3pf6Yubdjos+LivX8
	k7bO1Ol6/fBWsZN/zkURz6JDmxyibm794Rj66Pzpm07PssrsXzksPf3sDJdk8iTPjOsbHXO8
	AhfzFj1sPdnIEc/5cGvRg8bjxx2X/F77KkxdIfZJFvML/4S6rc8q12y5FN+cPMtmpcgsDp7q
	GS+VWIozEg21mIuKEwE/V9Ds4QIAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q5S28K6i016704

> Most Wolfson Arizona class audio hub CODECs include a flexible ultra low
> power accessory detection subsystem. This driver exposes initial support
> for this subsystem via the Extcon framework, implementing support for
> ultra low power detection of headphone and headset with the ability to
> detect the polarity of a headset.
> 
> The functionality of the devices is much richer and more flexible than
> the current driver, future patches will extend the features of the
> driver to more fully exploit this.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>


The driver looks good.

I only have some performance concerns that may be ignored
if you don't care of it for this device.

> ---
>  drivers/extcon/Kconfig          |    8 +
>  drivers/extcon/Makefile         |    1 +
>  drivers/extcon/extcon-arizona.c |  491 +++++++++++++++++++++++++++++++++++++++
>  3 files changed, 500 insertions(+)
>  create mode 100644 drivers/extcon/extcon-arizona.c
> 

[]

> +
> +#define ARIZONA_CABLE_MECHANICAL "Mechanical"
> +#define ARIZONA_CABLE_HEADPHONE  "Headphone"
> +#define ARIZONA_CABLE_HEADSET    "Headset"
> +
> +static const char *arizona_cable[] = {
> +	ARIZONA_CABLE_MECHANICAL,
> +	ARIZONA_CABLE_HEADSET,
> +	ARIZONA_CABLE_HEADPHONE,
> +	NULL,
> +};

For ARIZONA_CABLE_HEADPHONE and ARIZONA_CABLE_MECHANICAL, you can
use extcon_cable_name[EXTCON_HEADPHONE_OUT] and
extcon_cable_name[EXTCON_MECHANICAL].

It appears that I need to rephrase line 38-41 of extcon_class.c. Anyway,
it is not recommended to import the whole list. However, it is strongly
recommended to reuse the corresponding entries from the list.



Anyway, the HEADSET appears to be a pair of HEADPHONE and MIC.
You may replace HEADSET with MIC in arizona_cable and remove exclusive[]
and regard HEADPHONE | MIC as "HEADSET".

> +
> +static irqreturn_t arizona_micdet(int irq, void *data)
> +{
> +	struct arizona_extcon_info *info = data;
> +	struct arizona *arizona = info->arizona;
> +	unsigned int val;
> +	int ret;
> +
> +	mutex_lock(&info->lock);
> +
> +	ret = regmap_read(arizona->regmap, ARIZONA_MIC_DETECT_3, &val);
> +	if (ret != 0) {
> +		dev_err(arizona->dev, "Failed to read MICDET: %d\n", ret);
> +		return IRQ_NONE;
> +	}
> +
> +	dev_dbg(arizona->dev, "MICDET: %x\n", val);
> +
> +	if (!(val & ARIZONA_MICD_VALID)) {
> +		dev_warn(arizona->dev, "Microphone detection state invalid\n");
> +		mutex_unlock(&info->lock);
> +		return IRQ_NONE;
> +	}
> +
> +	/* Due to jack detect this should never happen */
> +	if (!(val & ARIZONA_MICD_STS)) {
> +		dev_warn(arizona->dev, "Detected open circuit\n");
> +		info->detecting = false;
> +		goto handled;
> +	}
> +
> +	/* If we got a high impedence we should have a headset, report it. */
> +	if (info->detecting && (val & 0x400)) {
> +		ret = extcon_set_cable_state(&info->edev,
> +					     ARIZONA_CABLE_HEADSET, true);

You may use extcon_set_cable_state_ for the performance
as you already know the index of HEADSET. Or extcon_update_state();

> +
> +		if (ret != 0)
> +			dev_err(arizona->dev, "Headset report failed: %d\n",
> +				ret);
> +
> +		info->mic = true;
> +		info->detecting = false;
> +		goto handled;
> +	}
> +
> +	/* If we detected a lower impedence during initial startup
> +	 * then we probably have the wrong polarity, flip it.  Don't
> +	 * do this for the lowest impedences to speed up detection of
> +	 * plain headphones.  If both polarities report a low
> +	 * impedence then give up and report headphones.
> +	 */
> +	if (info->detecting && (val & 0x3f8)) {
> +		info->jack_flips++;
> +
> +		if (info->jack_flips >= info->micd_num_modes) {
> +			dev_dbg(arizona->dev, "Detected headphone\n");
> +			info->detecting = false;
> +			ret = extcon_set_cable_state(&info->edev,
> +						     ARIZONA_CABLE_HEADPHONE,
> +						     true);

Same for here.

[]

> +
> +	/*
> +	 * If we're still detecting and we detect a short then we've
> +	 * got a headphone.  Otherwise it's a button press, the
> +	 * button reporting is stubbed out for now.
> +	 */
> +	if (val & 0x3fc) {
> +		if (info->mic) {
> +			dev_dbg(arizona->dev, "Mic button detected\n");
> +
> +		} else if (info->detecting) {
> +			dev_dbg(arizona->dev, "Headphone detected\n");
> +			info->detecting = false;
> +			arizona_stop_mic(info);
> +
> +			ret = extcon_set_cable_state(&info->edev,
> +						     ARIZONA_CABLE_HEADPHONE,
> +						     true);

Here, too.

[]

> +
> +static irqreturn_t arizona_jackdet(int irq, void *data)
> +{
> +	struct arizona_extcon_info *info = data;
> +	struct arizona *arizona = info->arizona;
> +	unsigned int val;
> +	int ret;
> +
> +	pm_runtime_get_sync(info->dev);
> +
> +	mutex_lock(&info->lock);
> +
> +	ret = regmap_read(arizona->regmap, ARIZONA_AOD_IRQ_RAW_STATUS, &val);
> +	if (ret != 0) {
> +		dev_err(arizona->dev, "Failed to read jackdet status: %d\n",
> +			ret);
> +		mutex_unlock(&info->lock);
> +		pm_runtime_put_autosuspend(info->dev);
> +		return IRQ_NONE;
> +	}
> +
> +	if (val & ARIZONA_JD1_STS) {
> +		dev_dbg(arizona->dev, "Detected jack\n");
> +		ret = extcon_set_cable_state(&info->edev,
> +					     ARIZONA_CABLE_MECHANICAL, true);

Here.




Cheers!
MyungJoo

ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
