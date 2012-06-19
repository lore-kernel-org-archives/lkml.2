Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810Ab2FSFEz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 01:04:55 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:16424 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951Ab2FSFEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 01:04:53 -0400
X-AuditID: cbfee60c-b7fe66d0000058a5-1e-4fe0086d2f4e
Date: Tue, 19 Jun 2012 05:04:45 +0000 (GMT)
From: =?euc-kr?B?x9S47cHW?= <myungjoo.ham@samsung.com>
Subject: Re: RE: Re: [PATCH 1/2] PM: devfreq: add freq table and available_freqs
To: Xiaoguang Chen <chenxg@marvell.com>,
        Xiaoguang Chen <chenxg.marvell@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>,
        "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
        "myungjoo.ham@gmail.com" <myungjoo.ham@gmail.com>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20120619044949893@myungjoo.ham
Msgkey: 20120619044949893@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20120619044949893@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <9923093.588271340082284749.JavaMail.weblogic@epml24>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLIsWRmVeSWpSXmKPExsVy+t/tmbq5HA/8DbYeMLO4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZB/dHFXwzqHg39SR7A+MF/S5GTg4hAXWJRUtOsoHYEgImEi2v
	2tkhbDGJC/fWA8W5gGrmM0rc33MZLMEioCrxf+Y31i5GDg42AXOJ+zOCQExhgQCJlhlgI0UE
	IiTW7vjMDNLKLNDGJNHbe4INYpeSxJp9r1hAbF4BQYmTM5+wQOxSlbi56jETRFxN4sbqKVA3
	SEjMmn6BFcLmlZjR/hSqXk5i2tc1zBC2tMT5WRsYYW5e/P0xVJxf4tjtHUwgt4H0PrkfDDNm
	9+YvUO8KSEw9cxCqVUti4ZQDTBA2n8SahW9ZYMbsOrUcbCSzgKLElO6H7BC2lsSXH/vYUL3C
	AWQ7Slx+nzeBUXYWkswsJN2zkHQjq1nAyLKKUTS1ILmgOCk91UivODG3uDQvXS85P3cTIziS
	n/HsYJzTYHGIUYCDUYmHdwHTA38h1sSy4srcQ4wSHMxKIryr/t/3F+JNSaysSi3Kjy8qzUkt
	PsQozcGiJM472fqCv5BAemJJanZqakFqEUyWiYNTqoExL9tG+9HGis06Apd7Eu44bojbqzdD
	s9uMs4p14pItR+at8eWam/JQ4+Ci06wP3mqoOimadXvICdVb/FPS87IWiAretuhg98dUwSbt
	1efP5GxZfUzHbq14ZssxueCeqCr/+AWcWh81Jhy93K65d7a70ALO+BvrDzDUTjM5cmtR7yT9
	IIEzv/8psRRnJBpqMRcVJwIA+jkcTuACAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q5J5505n025951

> Hi, Myungjoo
> 
> the API is optional, but I think one frequency table is better to have.
> if user space want to see what is the supported frequencies for the specific devfreq driver, then where do you think we can see this interface?
> do we have to go to OPP framework to get it ? or we can just add it in our devfreq ? for example: sys/class/devfreq/xxx-devfreq/available_freqs
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
> From: «‘∏Ì¡÷ [mailto:myungjoo.ham@samsung.com] 
> Sent: 2012“¥6Í≈14ÏÌ 12:44
> To: Xiaoguang Chen
> Cc: Xiaoguang Chen; linux-kernel@vger.kernel.org; π⁄∞ÊπŒ; linux-pm@lists.linux-foundation.org
> Subject: Re: Re: [PATCH 1/2] PM: devfreq: add freq table and available_freqs
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
> > > I think Devfreq should not be combined with OPP, OPP framework does 
> > > contain one frequency table, but the frequency is combined with voltage. some platforms may don't want to use this but handling voltage seperately in their clock driver.
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
> > > > > Devfreq framework don't have a frequency table, add it for easy 
> > > > > use.
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
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
