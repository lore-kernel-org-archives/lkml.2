Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087Ab1LMXHT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 18:07:19 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:2154 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909Ab1LMXHQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 18:07:16 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 13 Dec 2011 15:07:09 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "eric.y.miao@gmail.com" <eric.y.miao@gmail.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "arnd@arndb.de" <arnd@arndb.de>
Date: Tue, 13 Dec 2011 15:07:08 -0800
Subject: RE: [PATCH V2 2/2] ARM: mmp: enable pinmux in platform driver
Thread-Topic: [PATCH V2 2/2] ARM: mmp: enable pinmux in platform driver
Thread-Index: Acy560sWcJPhL2jPSNu/kKR5jmDwpQAAFmNg
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF1751860C3C@HQMAIL01.nvidia.com>
References: <1323769253-22580-1-git-send-email-haojian.zhuang@marvell.com>
	<1323769253-22580-3-git-send-email-haojian.zhuang@marvell.com>
 <CACRpkdbqj0zyRP4skGm4EX0Hx1Axe5-wkC14Y6Ee_B9TFzy39g@mail.gmail.com>
In-Reply-To: <CACRpkdbqj0zyRP4skGm4EX0Hx1Axe5-wkC14Y6Ee_B9TFzy39g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Walleij wrote at Tuesday, December 13, 2011 4:02 PM:
> On Tue, Dec 13, 2011 at 10:40 AM, Haojian Zhuang wrote:
...
> > +static struct pinmux_map brownstone_pmx_map[] = {
> > +       {
> > +               .name = "dkin",
> > +               .ctrl_dev_name = "mmp2-pinmux",
> > +               .function = "dkin",
> > +               .group = "dkin-2-pin",
> > +               .hog_on_boot = true,
> > +       }, {
...
> 
> Looks like we want to add
> #define PINMUX_MAP_SYS_HOG_GROUP() or so with four
> arguments, what do you say Stephen? Shall I try to patch  in
> something like that (then this patch will look even better).

Yes, sounds like a good idea. I just realized that I ignored PINMUX_MAP_*
in the stuff I'm working on and implemented exactly that macro as a custom
macro right before the map array. So, having it in the pinctrl header
would be good. 

-- 
nvpublic

