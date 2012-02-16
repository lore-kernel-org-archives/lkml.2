Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932433Ab2BPJNA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 04:13:00 -0500
Received: from kamaji.grokhost.net ([87.117.218.43]:46274 "EHLO
	kamaji.grokhost.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932239Ab2BPJMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 04:12:51 -0500
Message-ID: <4F3CC88D.3020701@bootc.net>
Date: Thu, 16 Feb 2012 09:12:45 +0000
From: Chris Boot <bootc@bootc.net>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: linux1394-devel@lists.sourceforge.net, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, agrover@redhat.com, clemens@ladisch.de,
        nab@linux-iscsi.org
Subject: Re: [PATCH v2 01/11] firewire: Add function to get speed from opaque
 struct fw_request
References: <1328989452-20921-1-git-send-email-bootc@bootc.net> <1329317248-94128-1-git-send-email-bootc@bootc.net> <1329317248-94128-2-git-send-email-bootc@bootc.net> <20120215200919.10d9e2eb@stein> <4F3C0333.6060306@bootc.net> <20120215230151.3467cd8a@stein>
In-Reply-To: <20120215230151.3467cd8a@stein>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/02/2012 22:01, Stefan Richter wrote:
> On Feb 15 Chris Boot wrote:
>> On 15/02/2012 19:09, Stefan Richter wrote:
>>> On Feb 15 Chris Boot wrote:
>>>> --- a/drivers/firewire/core-transaction.c
>>>> +++ b/drivers/firewire/core-transaction.c
>>>> @@ -820,6 +820,22 @@ void fw_send_response(struct fw_card *card,
>>>>    }
>>>>    EXPORT_SYMBOL(fw_send_response);
>>>>
>>>> +/**
>>>> + * fw_get_request_speed() - Discover bus speed used for this request
>>>> + * @request:	The struct fw_request from which to obtain the speed.
>>>> + *
>>>> + * In certain circumstances it's important to be able to obtain the speed at
>>>> + * which a request was made to an address handler, for example when
>>>> + * implementing an SBP-2 or SBP-3 target. This function inspects the response
>>>> + * object to obtain the speed, which is copied from the request packet in
>>>> + * allocate_request().
>>>> + */
>>>> +int fw_get_request_speed(struct fw_request *request)
>>>> +{
>>>> +	return request->response.speed;
>>>> +}
>>>> +EXPORT_SYMBOL(fw_get_request_speed);
>>>
>>> Uh oh, what have I done by asking for a comment? :-)
>>>
>>> Can you tell what's wrong with this API documentation?
>>
>> Better to have too much than too little? :-)
>>
>> Linux 3.4, now with added Enterprise.
>>
>> Shall I cut it down a bit?
>
> a)  The implementation of the function should not be explained here;
> after all it is meant to be opaque to API users.  Besides, if somebody
> changes the implementation he will for sure forget to change the comment.
>
> b)  It is fairly self-evident at which occasions an API user would want
> to use this function.  (Everytime when he needs to know that speed.)
>
> c)  The function call argument does not really need to be explained
> either as soon as the purpose of the function has been made known.
>
> So in my first response where I already acked your patch I should have
> simply asked for
>
> /**
>   * fw_get_request_speed() - returns speed at which the @request was received
>   */
>
> to be added to your patch.  :-)
>
> Patch review could be so easy for everyone involved if the reviewer knew
> how to express himself...

I guess it comes from me just trying too hard... Will fix for v3.

Cheers,
Chris

-- 
Chris Boot
bootc@bootc.net
