Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756749Ab2CEKH1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 05:07:27 -0500
Received: from mx01.sz.bfs.de ([194.94.69.103]:1311 "EHLO mx01.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756476Ab2CEKHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 05:07:25 -0500
Message-ID: <4F54905B.4030705@bfs.de>
Date: Mon, 05 Mar 2012 11:07:23 +0100
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch v2] edac i5000, i5400: fix pointer math in i5000_get_mc_regs()
References: <20120302065441.GB24508@elgon.mountain> <4F508C16.30900@bfs.de> <20120305090109.GM22598@mwanda> <4F548B43.6010802@bfs.de> <20120305095244.GG1003@mwanda>
In-Reply-To: <20120305095244.GG1003@mwanda>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Am 05.03.2012 10:52, schrieb Dan Carpenter:
> On Mon, Mar 05, 2012 at 10:45:39AM +0100, walter harms wrote:
>>
>>
>> Am 05.03.2012 10:01, schrieb Dan Carpenter:
>>> "pvt->ambase" is a u64 datatype.  The intent here is to fill the first
>>> half in the first call to pci_read_config_dword() and the other half in
>>> the second.  Unfortunately the pointer math is wrong so we set the wrong
>>> data.
>>>
>>> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>>> ---
>>> v2: Redid it as with a union as Walter Harms suggested.
>>>     Fixed the same bug in i5400_edac.c as well.
>>>
>>> I don't have this hardware, so please review carefully.
>>>
>>> diff --git a/drivers/edac/i5400_edac.c b/drivers/edac/i5400_edac.c
>>> index 74d6ec34..083e80a 100644
>>> --- a/drivers/edac/i5400_edac.c
>>> +++ b/drivers/edac/i5400_edac.c
>>> @@ -343,7 +343,13 @@ struct i5400_pvt {
>>>  	struct pci_dev *branch_1;		/* 22.0 */
>>>  
>>>  	u16 tolm;				/* top of low memory */
>>> -	u64 ambase;				/* AMB BAR */
>>> +	union {
>>> +		u64 ambase;				/* AMB BAR */
>>> +		struct {
>>> +			u32 ambase_bottom;
>>> +			u32 ambase_top;
>>> +		} u;
>>> +	};
>>>  
>>
>> would this work with alignment=8 ?
> 
> Are you asking or telling?
> 

asking, i am really curious.

re,
 wh

> I guess I'll add a __packed and resend in case it's an issue.
> 
> regards,
> dan carpenter
> 
