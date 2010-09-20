Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757370Ab0ITTte (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 15:49:34 -0400
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:58805 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753802Ab0ITTtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 15:49:33 -0400
Message-ID: <4C97BAA2.6000309@euromail.se>
Date: Mon, 20 Sep 2010 21:48:50 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100916 Thunderbird/3.1.4
MIME-Version: 1.0
To: =?ISO-8859-1?Q?St=E9phane_Chatty?= <chatty@enac.fr>
CC: Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] hid: 3m: Convert to MT slots
References: <1283005748-3293-1-git-send-email-rydberg@euromail.se> <1283005748-3293-2-git-send-email-rydberg@euromail.se> <FF722ED6-6568-47D0-82D1-99B9E9D5AEAF@enac.fr>
In-Reply-To: <FF722ED6-6568-47D0-82D1-99B9E9D5AEAF@enac.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1OxmML-0001nS-7b.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1OxmML-0001nS-7b 8d8ed4f4fead8c5c815a77f6e2aa61f3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2010 09:43 PM, Stéphane Chatty wrote:

> 
> Le 28 août 10 à 16:29, Henrik Rydberg a écrit :
> 
>> The Microtouch controller is capable of doing finger tracking on
>> up to 60 fingers. To reduce bandwidth and cpu usage, convert the
>> driver to use the MT slots protocol.
> 
> As I understand it, this patch actually has three roles:
>  1. improving the evdev parameters of the device
>  2. cleaning the protocol to get rid of useless MISC/SCANCODE messages
>  3. convert the protocol to MT slots
> 
> 
>> +#define SN_MOVE            2048
>> +#define SN_WIDTH        128
>>
> 
> In the long run, it might be useful to comment these signal/noise constants
> 
> 
> 
>>              hid_map_usage(hi, usage, bit, max, EV_KEY, BTN_TOUCH);
>> +            input_set_capability(hi->input, EV_KEY, BTN_TOUCH);
> 
>>  {
>> +    /* tell hid-input to skip setup of these event types */
>>      if (usage->type == EV_KEY || usage->type == EV_ABS)
>> -        clear_bit(usage->code, *bit);
>> -
>> -    return 0;
>> +        set_bit(usage->type, hi->input->evbit);
>> +    return -1;
>>  }
>>
> 
> I understand this as a trick to get rid of MISC/SCANCODEs that are added for
> every EV_KEY message, consequence of a rule in hid-input.c. Wouldn't it be
> simpler to improve the rule than to work around it?


The main reason is to be able to set the fuzz parameters, which are otherwise
overwritten by hid-input setup.

Henrik
