Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751196Ab1LOFID (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 00:08:03 -0500
Received: from mga02.intel.com ([134.134.136.20]:4769 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750736Ab1LOFIB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 00:08:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="86744891"
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Pratyush Anand <pratyush.anand@st.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
CC: Viresh KUMAR <viresh.kumar@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Shiraz HASHIM <shiraz.hashim@st.com>,
        Armando VISCONTI <armando.visconti@st.com>,
        Deepak SIKRI <deepak.sikri@st.com>, Vipin KUMAR <vipin.kumar@st.com>,
        Vipul Kumar SAMAR <vipulkumar.samar@st.com>,
        Vincenzo FRASCINO <Vincenzo.FRASCINO@st.com>,
        Mirko GARDI <mirko.gardi@st.com>,
        Rajeev KUMAR <rajeev-dlh.kumar@st.com>, Amit VIRDI <Amit.VIRDI@st.com>,
        Bhupesh SHARMA <bhupesh.sharma@st.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>
Subject: RE: dmaengine/Query: What about scatter/gather for mem to mem
 transfers.
Thread-Topic: dmaengine/Query: What about scatter/gather for mem to mem
 transfers.
Thread-Index: AQHMtV9qqNLGq/tVB02q+2hFm90Q7JXRjdsA//+nQwCACVyNgIABc8SAgABdFCA=
Date: Thu, 15 Dec 2011 05:06:56 +0000
Message-ID: <8D3F6266AEB6384E807C6FFC6FE195E327F2B0@BGSMSX101.gar.corp.intel.com>
References: <4EE038BD.7010705@st.com>
 <1323329870.1641.27.camel@vkoul-udesk3> <4EE06C3C.8080003@st.com>
 <4EE8469B.8050201@st.com> <4EE97E77.8060703@st.com>
In-Reply-To: <4EE97E77.8060703@st.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pBF58GVW006641

> 
> Hello Vinod/Dan,
> 
> Please write your opinion.
I am on vacation, but will reply briefly here, more next week
> 
> Regards
> Pratyush
> 
> On 12/14/2011 12:17 PM, Pratyush Anand wrote:
> > Hello Vinod/Dan,
> >
> > In continuation to the scatter/gather requirement:
> > We might need some generic transfer where source and destination
> > address may be overlapped and also gap between two chunk of source and
> > destination might not be same.
> >
> > For examaple,
> > Transfer size is - -0x4000
> > Our Src is something like this:
> > 0x1000 -- 0x2000
> > 0x3000 -- 0x5000
> > 0x6000 -- 0x7000
> >
> > and dst is something like this:
> > 0x6000 -- 0x8000
> > 0x9000 -- 0xB000
So why can't it be split like:
0x1000--0x2000 => 0x6000 --0x7000
0x3000 -- 0x4000 => 0x7000 - 0x8000
0x4000 -- 0x5000 => 0x9000 - 0xA000
0x6000 -- 0x7000 => 0xA000 - 0xB000

That way existing mechanism would work well for you.
You need to split the chunks properly, which is what dma would do anyway

--
~Vinod
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
