Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932503Ab2CBTVE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 14:21:04 -0500
Received: from mx01.sz.bfs.de ([194.94.69.103]:32147 "EHLO mx01.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753130Ab2CBTVC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 14:21:02 -0500
Message-ID: <4F511D9B.10401@bfs.de>
Date: Fri, 02 Mar 2012 20:20:59 +0100
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] edac i5000: fix pointer math in i5000_get_mc_regs()
References: <20120302065441.GB24508@elgon.mountain> <4F508C16.30900@bfs.de> <20120302190932.GI22598@mwanda>
In-Reply-To: <20120302190932.GI22598@mwanda>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Am 02.03.2012 20:09, schrieb Dan Carpenter:
> On Fri, Mar 02, 2012 at 10:00:06AM +0100, walter harms wrote:
>>> diff --git a/drivers/edac/i5000_edac.c b/drivers/edac/i5000_edac.c
>>> index 4dc3ac2..fcdc4ab 100644
>>> --- a/drivers/edac/i5000_edac.c
>>> +++ b/drivers/edac/i5000_edac.c
>>> @@ -1130,7 +1130,7 @@ static void i5000_get_mc_regs(struct mem_ctl_info *mci)
>>>  	pci_read_config_dword(pvt->system_address, AMBASE,
>>>  			(u32 *) & pvt->ambase);
>>>  	pci_read_config_dword(pvt->system_address, AMBASE + sizeof(u32),
>>> -			((u32 *) & pvt->ambase) + sizeof(u32));
>>> +			(u32 *)((char *) &pvt->ambase + sizeof(u32)));
>>>  
>>>  	maxdimmperch = pvt->maxdimmperch;
>>>  	maxch = pvt->maxch;
>>
>> i think this is hard to understand. personally i would prefer a union or other
>> more obvious solutions. my suggestion would be to get rid of this.
>>
>> u32 bottom,top;
>>  	pci_read_config_dword(pvt->system_address, AMBASE,
>>   			&bottom);
>> 	pci_read_config_dword(pvt->system_address, AMBASE+ sizeof(u32),
>>   			&top);
>> 	maxdimmperch=(u64)top<<32|bottom;
>> 	
>> you can find this pattern in other parts of the kernel also.
>>
> 
> Sure.  I want to do this again anyway because I see I've missed some
> other parts which have the same bug.  I'll resend a patch later.
> 
> regards,
> dan carpenter

I have no idea how ofter a64bit value is need but perhaps is pci_read_config_qword()
an option ?

re,
 wh
