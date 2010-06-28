Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639Ab0F1OMw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 10:12:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:49298 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751284Ab0F1OMv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 10:12:51 -0400
Message-ID: <4C28ADC9.1050706@kernel.org>
Date: Mon, 28 Jun 2010 18:12:25 +0400
From: Denis Kirjanov <dkirjanov@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Kulikov Vasiliy <segooon@gmail.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>, Lior Dotan <liodot@gmail.com>,
       charrer@alacritech.com, "David S. Miller" <davem@davemloft.net>,
       Jiri Pirko <jpirko@redhat.com>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] staging: slicoss: Change return codes to -EYYY.
References: <1277644847-16292-1-git-send-email-segooon@gmail.com> <AANLkTil3gkyn5vY9o0JYluRB4qUp1hdyfOHbX97OZfGJ@mail.gmail.com> <20100628111409.GA20103@shinshilla>
In-Reply-To: <20100628111409.GA20103@shinshilla>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 28 Jun 2010 14:12:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2010 03:14 PM, Kulikov Vasiliy wrote:
>>> @@ -1206,7 +1206,7 @@ static void slic_link_event_handler(struct adapter *adapter)
>>>   #else
>>>         Stop compilation;
>>>   #endif
>>> -       ASSERT((status == STATUS_SUCCESS) || (status == STATUS_PENDING));
>>> +       ASSERT(status == 0);
>>>   }
>>>
>>
>> Now that looks useless since slic_upr_request can return STATUS_PENDING
>> or -ENOMEM. Same for slic_config_get
> Yes, it seems that slic_link_event_handler&  slic_config_get have to return error codes.
>
>>> @@ -2267,7 +2267,7 @@ static u32 slic_card_locate(struct adapter *adapter)
>>>
>>>         ASSERT(card);
>>>         if (!card)
>>> -               return STATUS_FAILURE;
>>> +               return -ENOMEM;
>>
>> Is -ENOMEM correct for this case?
>>
> Right, maybe ENXIO?
>
Yes, I'm fine with this.
