Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959Ab0JCKCA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 06:02:00 -0400
Received: from smtp1.extricom.com ([212.235.17.194]:50305 "HELO
	smtp.extricom.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with SMTP id S1752919Ab0JCKB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 06:01:59 -0400
X-Greylist: delayed 1598 seconds by postgrey-1.27 at vger.kernel.org; Sun, 03 Oct 2010 06:01:58 EDT
Message-ID: <4CA84DA1.1070206@extricom.com>
Date: Sun, 03 Oct 2010 11:32:17 +0200
From: Eran Liberty <liberty@extricom.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: emin ak <eminak71@gmail.com>
CC: David Miller <davem@davemloft.net>, galak@kernel.crashing.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] gainfar.c : skb_over_panic (kernel-2.6.32.15)
References: <4C232B13.5000706@extricom.com>	<20100624.145225.70206491.davem@davemloft.net>	<4C2855D4.5050507@extricom.com>	<20100628.113336.112593735.davem@davemloft.net>	<4C2A145D.1000702@extricom.com> <AANLkTikXj3cAkrMMUP2_TGSFYQY9=oPg8QxOU-jYUjnR@mail.gmail.com>
In-Reply-To: <AANLkTikXj3cAkrMMUP2_TGSFYQY9=oPg8QxOU-jYUjnR@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Amin Ak,

A patch has been posted both to the most recent kernel tree at the time 
and to the long term 2.6.32.X branch. At which point it is out of mine 
and in the capable hands of the maintainers.

If needs be, I am willing to repost the patches even though they are 
still out there and probably still fresh enough.

If you apply them and solve your own private overpanic maybe "ack"ing 
the patch will expedite its trip into the kernel kingdom.

-- Liberty

emin ak wrote:
> Hi Eran, David
> This bug still exits on current both stable and rc kernel releases
> reported on the mail list.
> http://lkml.org/lkml/2010/9/28/178
> Is there any merge plan this patch to current kernel.
> Regards
>
>
> 2010/6/29 Eran Liberty <liberty@extricom.com>:
>   
>> David Miller wrote:
>>     
>>> From: Eran Liberty <liberty@extricom.com>
>>> Date: Mon, 28 Jun 2010 10:57:08 +0300
>>>
>>>       
>>>> This code has proved to be insufficient and produce
>>>> skb_over_panic. The proposed patch fix this.
>>>>         
>>> Then you have to post a patch relative to the current code, rather than
>>> against the code as it was several releases ago.
>>>
>>> Your patch didn't apply, so I can't use it.
>>>
>>>       
>> Upon cleaning up my patch for the latest kernel I realized I do not
>> like: the previous partial fix, the fix in ucc_geth.c, the fix in the
>> current latest kernel, and my own previously proposed patch. They all
>> tried to undo the alignment skb_reserve done in gfar_new_skb() before
>> queuing the skb into the rw_recycle, because upon getting a new one in
>> gfar_new_skb() if the skb is from the rx_recycle pool rather then newly
>> allocated it is reserved twice.
>>
>> Instead of trying to undo the skb_reserve this proposed patch will make
>> sure the alignment skb_reserve is done once, upon allocating the skb and
>> not when taken out of the rx_recycle pool. Eliminating the need to undo
>> anything before queue skb back to the pool.
>>
>> This patch will apply cleanly against the 2.6.32.15. Another patch will
>> be submitted separately for the current Linus tree.
>>
>> -- Liberty
>>
>> Signed-off-by: Eran Liberty <liberty@extricom.com>
>>     

