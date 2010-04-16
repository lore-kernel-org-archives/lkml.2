Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757749Ab0DPPJu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 11:09:50 -0400
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:39977 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757036Ab0DPPJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 11:09:48 -0400
Message-ID: <4BC87D92.1070507@euromail.se>
Date: Fri, 16 Apr 2010 17:09:06 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: mt: introduce MT event slots
References: <1270685590-2204-1-git-send-email-rydberg@euromail.se> <20100415232523.GA18263@core.coreip.homeip.net>
In-Reply-To: <20100415232523.GA18263@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.129.72
X-Scan-Result: No virus found in message 1O2nAI-0002cB-9Z.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1O2nAI-0002cB-9Z f1f64bfe60bfe4a01521a2fb3d08bdf5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov wrote:
> Hi Henrik,
> 
> On Thu, Apr 08, 2010 at 02:13:10AM +0200, Henrik Rydberg wrote:
>> With the rapidly increasing number of intelligent multi-contact and
>> multi-user devices, the need to send digested, filtered information
>> from a set of different sources within the same device is imminent.
>> This patch adds the concept of slots to the MT protocol. The slots
>> enumerate a set of identified sources, such that all MT events
>> can be passed independently and selectively per identified source.
>>
>> The protocol works like this: Instead of sending a SYN_MT_REPORT
>> event immediately after the contact data, one sends a SYN_MT_SLOT
>> event immediately before the contact data. The input core will only
>> emit events for the slots corresponding to the contacts that have
>> changed. It is assumed that the same slot is used for the duration
>> of an initiated contact.
>>
> 
> I see the reason for doing this however I would like to hold off
> applying it till we get a couple of users and prove that the scheme
> works well for them.

Sounds good.

>>  
>> +/**
>> + * struct input_mt_slot - represents the state of an MT input slot
>> + * @abs: current values from absolute axes for this slot
>> + */
>> +struct input_mt_slot {
>> +	int abs[ABS_MAX + 1];
>> +};
> 
> It would be nice to use abs[ABS_MT_MAX - ABS_MT_TOUCH_MAJOR] to save
> some memory.
> 

Spot on! I was choosing between different strategies here: from a) mapping just
the ABS_MT values to keep memory down (but introduce yet another mapping); to b)
opening up the protocol for all kinds of event types (after all, it is only
backwards compatibility that prevents the slots from being used also for, say,
button events). It seemed best to keep the possibility for new event types to be
used with slots, thus using a straight mapping to the ABS events and ignoring
the extra memory used. However the word "new" is not enforced with this patch,
which your change remedies in the most satisfactory way. Nice.

I will wait for some more implementation test results (I know of one currently
in progress), then I will be back with an updated patch and accompanying
documentation.

Cheers,
Henrik
