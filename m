Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751407Ab2FNEnw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 00:43:52 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:50397 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926Ab2FNEnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 00:43:51 -0400
X-AuditID: cbfee60b-b7f866d00000631c-64-4fd96c044f71
Date: Thu, 14 Jun 2012 04:43:48 +0000 (GMT)
From: =?euc-kr?B?x9S47cHW?= <myungjoo.ham@samsung.com>
Subject: Re: Re: [PATCH 1/2] PM: devfreq: add freq table and available_freqs
To: Xiaoguang Chen <chenxg.marvell@gmail.com>
Cc: Xiaoguang Chen <chenxg@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>,
        "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20120614044324641@myungjoo.ham
Msgkey: 20120614044324641@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20120614044324641@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <29439113.474411339649027694.JavaMail.weblogic@epml17>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAIsWRmVeSWpSXmKPExsVy+t/tGbosOTf9DVp2mFhc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MpvUr2Aq2SFUsOtPD1sB4Q7KLkZNDSEBdYtGSk2wgtoSAicSd
	PZNYIGwxiQv31gPFuYBq5jNKTLh7hREkwSKgKrFx7QvWLkYODjYBc4n7M4JAwsICPhJXHj8E
	KxER0JdY8Oo7WC+zwC9Gib09F9gglilJrNn3CmwBr4CgxMmZT6CWqUqc+/afCSKuJnHyZj/U
	QRISs6ZfYIWweSVmtD+FqpeTmPZ1DTOELS1xftYGRpijF39/DBXnlzh2ewcTyJ0gvU/uB8OM
	2b35C9R4AYmpZw5CtWpJPF3zlh3C5pNYs/AtC8yYXaeWg41kFlCUmNL9kB3C1pL48mMfG7pX
	eAWcJP49Pcs4gVF2FpLULCTts5C0I6tZwMiyilE0tSC5oDgpPdVQrzgxt7g0L10vOT93EyM4
	np9x72Cc1WBxiFGAg1GJh1cg9qa/EGtiWXFl7iFGCQ5mJRHeZwpAId6UxMqq1KL8+KLSnNTi
	Q4zSHCxK4ryTrC/4CwmkJ5akZqemFqQWwWSZODilGhgbX/pduZJhf4fBMfKuhESdxFuWXUvm
	l8yf1h1V+knjvOC8mf5HteU8LVu2y03RafqwWPbwvb3JBe92Ox3kZOJcKDKJr/nivN03pocL
	sc5SKlhhIuwR/nudt7SmoN9iiTSJee/r7JP69t4qyFaZ/z56tp+g/tsZ53J31rc1/9uvv+Qu
	q5/s/PNKLMUZiYZazEXFiQDZHZiL4wIAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q5E4hv4a029194

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
> > I think Devfreq should not be combined with OPP, 
> > OPP framework does contain one frequency table, but the frequency is combined with voltage. some platforms may don't want to use this but handling voltage seperately in their clock driver.
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
> > > > Devfreq framework don't have a frequency table, add it
> > > > for easy use.
> > > >
> > > > Signed-off-by: Xiaoguang Chen <chenxg@marvell.com>
> > > 
> > > 
> > > If you need a predefined data structure to support frequency table,
> > > you can simply use OPP, which has helper functions implemented in
> > > devfreq subsystem. Is there any reason not to use OPP and to implement
> > > another data structure to store a frequency table attached to a device?
> > > 
> > > 
> > > Cheers!
> > > MyungJoo.
> > > ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
