Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751286Ab1IUVtL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 17:49:11 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:35764 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750962Ab1IUVtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 17:49:08 -0400
Message-ID: <4E7A5BD2.40502@xenotime.net>
Date: Wed, 21 Sep 2011 14:49:06 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110907 SUSE/3.1.14 Thunderbird/3.1.14
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [PATCH -next] bcma: main.c and driver_mips.c need linux/export.h
References: <20110920173102.d38155c7defbbc29beaae7c0@canb.auug.org.au>	<4E78CFC0.4020003@xenotime.net>	<CACna6rxGrd-ORWZrc0xsAOKptU_Xj3eGh9qSfX9vJYCPTZrCRg@mail.gmail.com>	<4E78FCDB.1010002@xenotime.net>	<CACna6rywFitSNkkwo6tNy887vdsoyHG5Cadk6Bb8_qBJ+gc42w@mail.gmail.com>	<4E7A084C.3000304@xenotime.net> <CACna6ryNw+YgTiO5dBSGcTfUabM_yO0LaSsbGpC_X6JrQudnBQ@mail.gmail.com> <4E7A521B.50104@xenotime.net> <4E7A5A2F.7030402@lwfinger.net>
In-Reply-To: <4E7A5A2F.7030402@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/2011 02:42 PM, Larry Finger wrote:
> On 09/21/2011 04:07 PM, Randy Dunlap wrote:
>> From: Randy Dunlap<rdunlap@xenotime.net>
>>
>> main.c and driver_mips.c use EXPORT_SYMBOL() etc.
>> so they should include<linux/export.h>.
>>
>> Signed-off-by: Randy Dunlap<rdunlap@xenotime.net>
> 
> From this commit message, it appears that every routine that uses EXPORT_SYMBOL() will need to include this header. I looked at modifying rtlwifi and friends to include this header, but found that include/linux/export.h does not exist in any of my source trees. From that I assume that the change will happen in 3.2.
> 
> I have prepared a patch, but cannot use it at the moment. Is there somewhere that I should send it?

Hi Larry,

linux/export.h is only in linux-next.  I think that you should just prepare
a linux-next patch for rtlwifi and then push it after Paul Gortmaker's
module.h-split git tree has been merged (it splits module.h into module.h
and export.h), or maybe you could ask Paul to merge your patch into his tree.

[I added Paul to the cc: list.]

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
