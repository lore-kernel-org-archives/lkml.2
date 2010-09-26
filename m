Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757896Ab0IZRST (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 13:18:19 -0400
Received: from mx01.sz.bfs.de ([194.94.69.103]:13154 "EHLO mx01.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754759Ab0IZRSS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 13:18:18 -0400
Message-ID: <4C9F804E.8010902@bfs.de>
Date: Sun, 26 Sep 2010 19:18:06 +0200
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Thunderbird 2.0.0.24 (X11/20100302)
MIME-Version: 1.0
To: Belisko Marek <marek.belisko@gmail.com>
CC: Dan Carpenter <error27@gmail.com>, kernel-janitors@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: ft1000: fix error path
References: <1285491595-377-1-git-send-email-segooon@gmail.com>	<20100926131151.GC6134@bicker> <AANLkTin_4D6fF85+4dFe+qN9-nEBS8+oDMKRCtixMCPU@mail.gmail.com>
In-Reply-To: <AANLkTin_4D6fF85+4dFe+qN9-nEBS8+oDMKRCtixMCPU@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


hi Marek,
IMHO the alloc sequencs is building a linked list of allocated buffer.
And if  kfree() does no magiclly follow the list this is not working.

re,
 wh


Belisko Marek schrieb:
> On Sun, Sep 26, 2010 at 3:11 PM, Dan Carpenter <error27@gmail.com> wrote:
>> On Sun, Sep 26, 2010 at 12:59:55PM +0400, Vasiliy Kulikov wrote:
>>> +err_free:
>>> +     for (i--; i>=0; i--) {
>>> +             kfree(pdpram_blk->pbuffer);
>>> +             kfree(pdpram_blk);
>>> +     }
>> This is wrong.  I don't have linux-next so I can't see the context, why
>> are we looping here?  The second iteration through the loop will cause a
>> NULL dereference.
> Some lines upper there is allocation of structure and it's internal
> buffer in loop:
> for (i=0; i<NUM_OF_FREE_BUFFERS; i++) {
>     // Get memory for DPRAM_DATA link list
>     pdpram_blk = kmalloc ( sizeof(DPRAM_BLK), GFP_KERNEL );
>     // Get a block of memory to store command data
>     pdpram_blk->pbuffer = kmalloc ( MAX_CMD_SQSIZE, GFP_KERNEL );
>     // link provisioning data
>     list_add_tail (&pdpram_blk->list, &freercvpool);
> }
> 
> Free loop is correct in my opinion but kfree should be extended by checking
> of NULL pointer because allocation of pdpram_blk could fail and we free also
> pdpram_blk->pbuffer.
>> Also there should be spaces before and after the ">=".
>>
>> regards,
>> dan carpenter
>>
>>> +     return STATUS_FAILURE;
>>>  }
>>>
>>
> 
> marek
> 
