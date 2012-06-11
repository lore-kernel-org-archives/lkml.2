Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903Ab2FKPlc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 11:41:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44393 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754006Ab2FKPla (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 11:41:30 -0400
Message-ID: <4FD611A5.6070208@redhat.com>
Date: Mon, 11 Jun 2012 12:41:25 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Chris Metcalf <cmetcalf@tilera.com>
CC: Doug Thompson <dougthompson@xmission.com>, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] edac: Do alignment logic properly in edac_align_ptr()
References: <201206061723.q56HNgtR016254@farm-0002.internal.tilera.com> <4FD6103B.6020901@tilera.com>
In-Reply-To: <4FD6103B.6020901@tilera.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 11-06-2012 12:35, Chris Metcalf escreveu:
> On 6/6/2012 1:24 PM, Chris Metcalf wrote:
>> The logic was checking the sizeof the structure being allocated to
>> determine whether an alignment fixup was required.  This isn't right;
>> what we actually care about is the alignment of the actual pointer that's
>> about to be returned.  This became an issue recently because struct
>> edac_mc_layer has a size that is not zero modulo eight, so we were
>> taking the correctly-aligned pointer and forcing it to be misaligned.
>> On Tile this caused an alignment exception.
>>
>> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
>> ---
>> Mauro, I assume you will push this through your tree?  I am also happy
>> to push it through the tile tree.  Let me know!
> 
> Ping - I see this didn't make it into 3.5-rc2.  I'm happy to push the change
> through the tile tree if that's helpful (and someone wants to give their
> Acked-by).

Sorry, I took some days off to rest. I'll be applying it today on my -next tree
and likely tomorrow upstream, together with a few other EDAC fixes.

Regards,
Mauro
> 
>>
>>   drivers/edac/edac_mc.c |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
>> index 10f3750..de5ba86 100644
>> --- a/drivers/edac/edac_mc.c
>> +++ b/drivers/edac/edac_mc.c
>> @@ -164,7 +164,7 @@ void *edac_align_ptr(void **p, unsigned size, int n_elems)
>>   	else
>>   		return (char *)ptr;
>>   
>> -	r = size % align;
>> +	r = (unsigned long)p % align;
>>   
>>   	if (r == 0)
>>   		return (char *)ptr;
> 


