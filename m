Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751512Ab2CLPz2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 11:55:28 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:41306 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188Ab2CLPzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 11:55:25 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6646"; a="169380291"
X-IronPort-AV: E=Sophos;i="4.73,569,1325491200"; 
   d="scan'208";a="282357813"
Message-ID: <4F5E1C66.1010604@qca.qualcomm.com>
Date: Mon, 12 Mar 2012 21:25:18 +0530
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: Willy Tarreau <w@1wt.eu>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>, Pavel Roskin <proski@gnu.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [ 08/12] mac80211: zero initialize count field in ieee80211_tx_rate
References: <20120312002046.282831520@1wt.eu>	 <1331517472.3022.150.camel@deadeye> <4F5D7D47.102@qca.qualcomm.com>	 <20120312063412.GD8971@1wt.eu> <4F5D9D3D.6090206@qca.qualcomm.com> <1331565826.3022.156.camel@deadeye>
In-Reply-To: <1331565826.3022.156.camel@deadeye>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.30.39.5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

On Monday 12 March 2012 08:53 PM, Ben Hutchings wrote:
> On Mon, 2012-03-12 at 12:22 +0530, Mohammed Shafi Shajakhan wrote:
>> Hi Willy,
>>
>>> On Mon, Mar 12, 2012 at 10:06:23AM +0530, Mohammed Shafi Shajakhan wrote:
>>>>> So I'm pretty sure this patch is wrong for 2.6.32; it could be
>>>>> backported but I don't think the change is necessary anyway.
>>>>
>>>> true, but i think its better to initialize the count = 0 rather than
>>>> count = 1, though the older version driver checks for rate[i].idx>= 0
>>>> in ath_rc_tx_status. while the ath_tx_status has no such iteration in
>>>> the older driver code.
>>>
>>> In practice, if the patch brings nothing and not even correctness, I'd
>>> rather drop it than make us believe that some issue is fixed. However
>>> if you think it does happen to fix a real issue in 2.6.32 (possibly
>>> combined with some other missing patch), please tell me so and I will
>>> happily undelete it.
>>>
>>
>> we can drop it. also as there was no driver code checking for
>> rate[i].count in the 2.6.32 driver. i am also not sure this fixes
>> something in 2.6.32 but the patch itself is correct.
> [...]
>
> Please read and answer the *whole* of my earlier message.  The later
> code in the rate_control_get_rate() function in 2.6.32 does appear to
> depend on .count = 1, and there may be code elsewhere that does so too.
>

are you referring to those code in tx.c ieee80211_tx_h_rate_control. 
sorry if i had again missed something.

-- 
thanks,
shafi
