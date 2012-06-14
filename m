Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751427Ab2FNFkI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 01:40:08 -0400
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:57720 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750740Ab2FNFkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 01:40:07 -0400
From: Xiaoguang Chen <chenxg@marvell.com>
To: "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        Xiaoguang Chen <chenxg.marvell@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?ks_c_5601-1987?B?udqw5rnO?= <kyungmin.park@samsung.com>,
        "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>
Date: Wed, 13 Jun 2012 22:39:59 -0700
Subject: RE: Re: [PATCH 1/2] PM: devfreq: add freq table and available_freqs
Thread-Topic: Re: [PATCH 1/2] PM: devfreq: add freq table and available_freqs
Thread-Index: Ac1J6CZCZJJPgeVKReyqKbpvswDehwABwxZA
Message-ID: <4737A960563B524DA805CA602BE04B3064CBDF6AA3@SC-VEXCH2.marvell.com>
References: <29439113.474411339649027694.JavaMail.weblogic@epml17>
In-Reply-To: <29439113.474411339649027694.JavaMail.weblogic@epml17>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-CN, en-US
Content-Type: text/plain; charset="ks_c_5601-1987"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q5E5eFLe029423

Hi, Myungjoo

the API is optional, but I think one frequency table is better to have.
if user space want to see what is the supported frequencies for the specific devfreq driver, then where do you think we can see this interface?
do we have to go to OPP framework to get it ? or we can just add it in our devfreq ? for example: sys/class/devfreq/xxx-devfreq/available_freqs
I think it is best for us to see this in the same sysfs path.

Thanks
Xiaoguang


-----Original Message-----
From: ÇÔ¸íÁÖ [mailto:myungjoo.ham@samsung.com] 
Sent: 2012Ò´6êÅ14ìí 12:44
To: Xiaoguang Chen
Cc: Xiaoguang Chen; linux-kernel@vger.kernel.org; ¹Ú°æ¹Î; linux-pm@lists.linux-foundation.org
Subject: Re: Re: [PATCH 1/2] PM: devfreq: add freq table and available_freqs

> Hi, Myungjoo
> 
> 
> what's your opinion?

Hello Xiaoguang,

Still, I don't think we need additional API and ABI for a simple frequency table. Why a devfreq device driver would want to register a table in struct devfreq while it can hold one either with its dev-data, private data of devfreq, or even OPP.

1. Devfreq is not "combined" with OPP. OPP is optional.

2. I guess filling voltage column with some arbitrary values in OPP table won't hurt anything if the device does not care voltage values. (just a suggestion and speculation) Thus, you can still use OPP in your case as long as the frequency values are discrete and not too many.

3. Devfreq and its governors recommends the base frequency to devfreq drivers. Frequency table is only needed to be visible to devfreq drivers, not to governors or devfreq itself. The frequency table you've suggested is not need to be visible to devfreq subsystem.


I still object to adding a frequency table (which is already supported by OPP by not specifying voltage or specifying arbitrary voltage values). However, even if I don't, we won't need that API (devfreq_set_freq_table), which should've been added in device profile at devfreq_add_device() time.


Cheers!
MyungJoo.

> 
> 
> Thanks
> Xiaoguang
> 
> 
> > 2012/6/13 Xiaoguang Chen <chenxg.marvell@gmail.com>
> > 
> > I think Devfreq should not be combined with OPP, OPP framework does 
> > contain one frequency table, but the frequency is combined with voltage. some platforms may don't want to use this but handling voltage seperately in their clock driver.
> > 
> > 
> > and some platforms don't use OPP, and they want a frequency list.
> > then this is necessary. also devfreq should contain a frequency list even without any other frameworks, don't you think so ?
> > 
> > 
> > Thanks
> > Xiaoguang
> > 
> > 
> > 
> > 2012/6/13 MyungJoo Ham <myungjoo.ham@samsung.com>
> > > 
> > > > Devfreq framework don't have a frequency table, add it for easy 
> > > > use.
> > > >
> > > > Signed-off-by: Xiaoguang Chen <chenxg@marvell.com>
> > > 
> > > 
> > > If you need a predefined data structure to support frequency 
> > > table, you can simply use OPP, which has helper functions 
> > > implemented in devfreq subsystem. Is there any reason not to use 
> > > OPP and to implement another data structure to store a frequency table attached to a device?
> > > 
> > > 
> > > Cheers!
> > > MyungJoo.
> > > 
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
