Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639Ab2BGTlK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 14:41:10 -0500
Received: from kamaji.grokhost.net ([87.117.218.43]:36688 "EHLO
	kamaji.grokhost.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447Ab2BGTlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 14:41:09 -0500
Message-ID: <4F317E54.9060607@bootc.net>
Date: Tue, 07 Feb 2012 19:41:08 +0000
From: Chris Boot <bootc@bootc.net>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Clemens Ladisch <clemens@ladisch.de>
Subject: Re: [RFC][PATCH] firewire: Add function to get speed from opaque
 struct fw_request
References: <1328566661-80768-1-git-send-email-bootc@bootc.net> <20120207191517.7b73978c@stein>
In-Reply-To: <20120207191517.7b73978c@stein>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2012 18:15, Stefan Richter wrote:
> On Feb 06 Chris Boot wrote:
>> [ Would something like the following be acceptable as an addition to the
>> FireWire stack? This would be enough for me to get the speed of the
>> request for my work on the SBP-2 target code. ]
> [...]
>> --- a/drivers/firewire/core-transaction.c
>> +++ b/drivers/firewire/core-transaction.c
>> @@ -820,6 +820,12 @@ void fw_send_response(struct fw_card *card,
>>   }
>>   EXPORT_SYMBOL(fw_send_response);
>>
>> +int fw_request_speed(struct fw_request *request)
>> +{
>> +	return request->response.speed;
>> +}
>> +EXPORT_SYMBOL(fw_request_speed);
>> +
>>   static void handle_exclusive_region_request(struct fw_card *card,
>>   					    struct fw_packet *p,
>>   					    struct fw_request *request,
>> diff --git a/include/linux/firewire.h b/include/linux/firewire.h
>> index 84ccf8e..eded4e4 100644
>> --- a/include/linux/firewire.h
>> +++ b/include/linux/firewire.h
>> @@ -340,6 +340,7 @@ int fw_core_add_address_handler(struct fw_address_handler *handler,
>>   void fw_core_remove_address_handler(struct fw_address_handler *handler);
>>   void fw_send_response(struct fw_card *card,
>>   		      struct fw_request *request, int rcode);
>> +int fw_request_speed(struct fw_request *request);
>>   void fw_send_request(struct fw_card *card, struct fw_transaction *t,
>>   		     int tcode, int destination_id, int generation, int speed,
>>   		     unsigned long long offset, void *payload, size_t length,
>
> Whenever you add a new exported function, please add a brief kerneldoc
> comment right above its definition.  Can be a one-liner in this case.
> Apart from this,
>
> Acked-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
>
> You can queue this via your SBP-2 target patch series (at which I haven't
> looked yet), followed right away by a change to your driver which uses the
> new symbol.  Or even better, fold these two changes into one.

I'll add some kerneldoc to it before I make it part of my series, it 
might as well be part of the same thing. Thanks for the ack!

> Not sure if four more characters should be spent on the symbol's name
> (fw_get_request_speed).  If you already thought about it and preferred
> fw_request_speed, keep it that way.

I did briefly consider it but I came up with 'fw_request_get_speed()' 
and didn't like it. fw_get_request_speed() makes sense to me though so 
I'll make the change before I send it out again.

> There are at least two alternatives to your proposal:
>
>    - We could move the definition of struct fw_request from
>      drivers/firewire/core-transaction.c to include/linux/firewire.h.
>      That would make for a rather bad driver API though.
>
>    - We could expand the function type fw_address_callback_t() by a speed
>      argument.  The other users of the API (firewire-core itself,
>      firewire-sbp2, firewire-net, firedtv, snd-firewire-lib, and other
>      as yet unmerged firewire sound drivers) and any other perceivable
>      future user of the API would not care of that speed though.
>
> I.e. the proposed "get speed of request" helper seems better.

Great!

Thanks,
Chris

-- 
Chris Boot
bootc@bootc.net
