Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031604Ab2I1UOD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:14:03 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:35753 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031161Ab2I1UN6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:13:58 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: "mturquette@linaro.org" <mturquette@linaro.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "viresh.linux@gmail.com" <viresh.linux@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Nori, Sekhar" <nsekhar@ti.com>, "Hilman, Kevin" <khilman@ti.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-keystone@list.ti.com - Linux developers for Keystone family of
	devices (May contain non-TIers)" <linux-keystone@list.ti.com>,
        "linux-c6x-dev@linux-c6x.org" <linux-c6x-dev@linux-c6x.org>,
        "Chemparathy, Cyril" <cyril@ti.com>
Subject: RE: [linux-keystone] Re: [PATCH 01/13] clk: davinci - add Main PLL
 clock driver
Thread-Topic: [linux-keystone] Re: [PATCH 01/13] clk: davinci - add Main PLL
 clock driver
Thread-Index: AQHNnLLOv4Iv3gnYoUmEQ/Mf6uRe9ZegMa4w
Date: Fri, 28 Sep 2012 20:12:43 +0000
Message-ID: <3E54258959B69E4282D79E01AB1F32B7041EF93B@DFLE12.ent.ti.com>
References: <1348682889-9509-1-git-send-email-m-karicheri2@ti.com>
	<1348682889-9509-2-git-send-email-m-karicheri2@ti.com>
 <CACRpkdZ=8m+X2KnUPFFhT2LsvTe-jPR_m6oVt_CEFfY-LvFHmg@mail.gmail.com>
In-Reply-To: <CACRpkdZ=8m+X2KnUPFFhT2LsvTe-jPR_m6oVt_CEFfY-LvFHmg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [128.247.5.50]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> -----Original Message-----
>> From: Linus Walleij [mailto:linus.walleij@linaro.org]
>> Sent: Thursday, September 27, 2012 9:20 AM
>> To: Karicheri, Muralidharan
>> Cc: mturquette@linaro.org; arnd@arndb.de; akpm@linux-foundation.org;
>> shawn.guo@linaro.org; rob.herring@calxeda.com; viresh.linux@gmail.com; linux-
>> kernel@vger.kernel.org; Nori, Sekhar; Hilman, Kevin; linux@arm.linux.org.uk; davinci-
>> linux-open-source@linux.davincidsp.com; linux-arm-kernel@lists.infradead.org; linux-
>> keystone@list.ti.com - Linux developers for Keystone family of devices (May contain non-
>> TIers); linux-c6x-dev@linux-c6x.org; Chemparathy, Cyril
>> Subject: [linux-keystone] Re: [PATCH 01/13] clk: davinci - add Main PLL clock driver
>> 
>> On Wed, Sep 26, 2012 at 8:07 PM, Murali Karicheri <m-karicheri2@ti.com> wrote:
>> 
>> > +struct clk_davinci_pll_data {
>> > +       /* physical addresses set by platform code */
>> > +       u32 phy_pllm;
>> > +       /* if PLL has a prediv register this should be non zero */
>> > +       u32 phy_prediv;
>> > +       /* if PLL has a postdiv register this should be non zero */
>> > +       u32 phy_postdiv;
>> > +       /* mapped addresses. should be initialized by  */
>> > +       void __iomem *pllm;
>> > +       void __iomem *prediv;
>> > +       void __iomem *postdiv;
>> > +       u32 pllm_mask;
>> > +       u32 prediv_mask;
>> > +       u32 postdiv_mask;
>> > +       u32 num;
>> > +       /* framework flags */
>> > +       u32 flags;
>> > +       /* pll flags */
>> > +       u32 pll_flags;
>> > +       /* use this value for prediv */
>> > +       u32 fixed_prediv;
>> > +       /* multiply PLLM by this factor. By default most SOC set this to zero
>> > +        * that translates to a multiplier of 1 and incrementer of 1.
>> > +        * To override default, set this factor
>> > +        */
>> > +       u32 pllm_multiplier;
>> > +};
>> > +
>> 
>> No, that's not what I meant.
>> 
>> I meant like this:
>> 
>> /**
>>  * struct clk_davinci_pll_data - struct holding the PLL data
>>  * phy_pllm: physical addresses set by platform code
>>  * phy_prediv: ...
>> (...)
>>  */
>> struct clk_davinci_pll_data {
>>       u32 phy_pllm;
>>       u32 phy_prediv;
>> (...)
>> };
>> 
Ok. Will do in the next revision.

Murali Karicheri
Software Design Engineer

>> Yours,
>> Linus Walleij
