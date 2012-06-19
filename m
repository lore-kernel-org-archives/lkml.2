Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192Ab2FSFea (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 01:34:30 -0400
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:44015 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752615Ab2FSFe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 01:34:29 -0400
From: Xiaoguang Chen <chenxg@marvell.com>
To: "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        Xiaoguang Chen <chenxg.marvell@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?ks_c_5601-1987?B?udqw5rnO?= <kyungmin.park@samsung.com>,
        "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
        "myungjoo.ham@gmail.com" <myungjoo.ham@gmail.com>
Date: Mon, 18 Jun 2012 22:30:30 -0700
Subject: RE: RE: Re: [PATCH 1/2] PM: devfreq: add freq table and
 available_freqs
Thread-Topic: RE: Re: [PATCH 1/2] PM: devfreq: add freq table and
 available_freqs
Thread-Index: Ac1N2RDiVycuxMCRR9ObB/DAvMByRgAA0FOQ
Message-ID: <4737A960563B524DA805CA602BE04B3064CBDF740D@SC-VEXCH2.marvell.com>
References: <9923093.588271340082284749.JavaMail.weblogic@epml24>
In-Reply-To: <9923093.588271340082284749.JavaMail.weblogic@epml24>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id q5J5YtYR026044

OK, I get it.
Another question, do you guys ever want to add the devfreq governor dynamic change feature?

I mean we can switch governors for one devfreq driver dynamically in devfreq framework. current framework only supports statically compile the governor and can't change it dynamically. 

Thanks
Xiaoguang


-----Original Message-----
From: ÇÔ¸íÁÖ [mailto:myungjoo.ham@samsung.com] 
Sent: 2012Ò´6êÅ19ìí 13:05
To: Xiaoguang Chen; Xiaoguang Chen
Cc: linux-kernel@vger.kernel.org; ¹Ú°æ¹Î; linux-pm@lists.linux-foundation.org; myungjoo.ham@gmail.com
Subject: Re: RE: Re: [PATCH 1/2] PM: devfreq: add freq table and available_freqs

> Hi, Myungjoo
> 
> the API is optional, but I think one frequency table is better to have.
> if user space want to see what is the supported frequencies for the specific devfreq driver, then where do you think we can see this interface?
> do we have to go to OPP framework to get it ? or we can just add it in 
> our devfreq ? for example: 
> sys/class/devfreq/xxx-devfreq/available_freqs
> I think it is best for us to see this in the same sysfs path.
> 
> Thanks
> Xiaoguang

Hi Xiaoguang,

First of all, both conceptually and practically, devfreq subsystem does not need to hold the list of available frequencies. Devfreq subsystem does not care whether a devfreq device has only two (or even one) frequencies available or several billions frequencies available, which is why OPP is dropped from devfreq subsystem and only helper functions are remaining.

The available frequencies information may be in OPP, clock subsystem, or the device driver itself. The listing of available frequencies should be provided by the one who has the information at first.

Anyway, except for the pure curiosity of users, why do we need to provide the list of available frequencies at the devfreq subsystem? If we are adding it in devfreq subsystem, we are adding an ABI and supporting data structure that are never used by the subsystem, but for printing out via ABI which only satisfies the curiosity of users that may already know what it would list up. There are even cases where the devfreq device driver itself also does not aware of avilable frequencies; when OPP is given outside.


Cheers!
MyungJoo.

> 
> 
> -----Original Message-----
> From: ÇÔ¸íÁÖ [mailto:myungjoo.ham@samsung.com]
> Sent: 2012Ò´6êÅ14ìí 12:44
> To: Xiaoguang Chen
> Cc: Xiaoguang Chen; linux-kernel@vger.kernel.org; ¹Ú°æ¹Î; 
> linux-pm@lists.linux-foundation.org
> Subject: Re: Re: [PATCH 1/2] PM: devfreq: add freq table and 
> available_freqs
> 
> > Hi, Myungjoo
> > 
> > 
> > what's your opinion?
> 
> Hello Xiaoguang,
> 
> Still, I don't think we need additional API and ABI for a simple frequency table. Why a devfreq device driver would want to register a table in struct devfreq while it can hold one either with its dev-data, private data of devfreq, or even OPP.
> 
> 1. Devfreq is not "combined" with OPP. OPP is optional.
> 
> 2. I guess filling voltage column with some arbitrary values in OPP table won't hurt anything if the device does not care voltage values. (just a suggestion and speculation) Thus, you can still use OPP in your case as long as the frequency values are discrete and not too many.
> 
> 3. Devfreq and its governors recommends the base frequency to devfreq drivers. Frequency table is only needed to be visible to devfreq drivers, not to governors or devfreq itself. The frequency table you've suggested is not need to be visible to devfreq subsystem.
> 
> 
> I still object to adding a frequency table (which is already supported by OPP by not specifying voltage or specifying arbitrary voltage values). However, even if I don't, we won't need that API (devfreq_set_freq_table), which should've been added in device profile at devfreq_add_device() time.
> 
> 
> Cheers!
> MyungJoo.
> 
> > 
> > 
> > Thanks
> > Xiaoguang
> > 
> > 
> > > 2012/6/13 Xiaoguang Chen <chenxg.marvell@gmail.com>
> > > 
> > > I think Devfreq should not be combined with OPP, OPP framework 
> > > does contain one frequency table, but the frequency is combined with voltage. some platforms may don't want to use this but handling voltage seperately in their clock driver.
> > > 
> > > 
> > > and some platforms don't use OPP, and they want a frequency list.
> > > then this is necessary. also devfreq should contain a frequency list even without any other frameworks, don't you think so ?
> > > 
> > > 
> > > Thanks
> > > Xiaoguang
> > > 
> > > 
> > > 
> > > 2012/6/13 MyungJoo Ham <myungjoo.ham@samsung.com>
> > > > 
> > > > > Devfreq framework don't have a frequency table, add it for 
> > > > > easy use.
> > > > >
> > > > > Signed-off-by: Xiaoguang Chen <chenxg@marvell.com>
> > > > 
> > > > 
> > > > If you need a predefined data structure to support frequency 
> > > > table, you can simply use OPP, which has helper functions 
> > > > implemented in devfreq subsystem. Is there any reason not to use 
> > > > OPP and to implement another data structure to store a frequency table attached to a device?
> > > > 
> > > > 
> > > > Cheers!
> > > > MyungJoo.
> > > > 
> 
> 
> 
>        
>   
>          
> 
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
