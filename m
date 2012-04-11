Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756491Ab2DKK23 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 06:28:29 -0400
Received: from mga02.intel.com ([134.134.136.20]:53043 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756144Ab2DKK21 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 06:28:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="127672119"
Message-ID: <4F855CD7.1000902@intel.com>
Date: Wed, 11 Apr 2012 13:28:39 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Adrian Hunter <adrian.hunter@intel.com>, linaro-kernel@lists.linaro.org,
        linux-mm@kvack.org, "Luca Porzio (lporzio)" <lporzio@micron.com>,
        Alex Lemberg <alex.lemberg@sandisk.com>, linux-kernel@vger.kernel.org,
        Saugata Das <saugata.das@linaro.org>,
        Venkatraman S <venkat@linaro.org>, Yejin Moon <yejin.moon@samsung.com>,
        Hyojin Jeong <syr.jeong@samsung.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        kernel-team@android.com
Subject: Re: swap on eMMC and other flash
References: <201203301744.16762.arnd@arndb.de> <201203301850.22784.arnd@arndb.de> <4F7C3CE2.5070803@intel.com> <201204041247.53289.arnd@arndb.de>
In-Reply-To: <201204041247.53289.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/12 15:47, Arnd Bergmann wrote:
> On Wednesday 04 April 2012, Adrian Hunter wrote:
>> On 30/03/12 21:50, Arnd Bergmann wrote:
>>> (sorry for the duplicated email, this corrects the address of the android
>>> kernel team, please reply here)
>>>
>>> On Friday 30 March 2012, Arnd Bergmann wrote:
>>>
>>>  We've had a discussion in the Linaro storage team (Saugata, Venkat and me,
>>>  with Luca joining in on the discussion) about swapping to flash based media
>>>  such as eMMC. This is a summary of what we found and what we think should
>>>  be done. If people agree that this is a good idea, we can start working
>>>  on it.
>>
>> There is mtdswap.
> 
> Ah, very interesting. I wasn't aware of that. Obviously we can't directly
> use it on block devices that have their own garbage collection and wear
> leveling built into them, but it's interesting to see how this was solved
> before.
> 
> While we could build something similar that remaps blocks between an
> eMMC device and the logical swap space that is used by the mm code,
> my feeling is that it would be easier to modify the swap code itself
> to do the right thing.
> 
>> Also the old Nokia N900 had swap to eMMC.
>>
>> The last I heard was that swap was considered to be simply too slow on hand
>> held devices.
> 
> That's the part that we want to solve here. It has nothing to do with
> handheld devices, but more with specific incompatibilities of the
> block allocation in the swap code vs. what an eMMC device expects
> to see for fast operation. If you write data in the wrong order on
> flash devices, you get long delays that you don't get when you do
> it the right way. The same problem exists for file systems, and is
> being addressed there as well.
> 
>> As systems adopt more RAM, isn't there a decreasing demand for swap?
> 
> No. You would never be able to make hibernate work, no matter how much
> RAM you add ;-)

Have you considered making hibernate work without swap?
