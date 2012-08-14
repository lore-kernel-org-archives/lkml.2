Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757615Ab2HNVGt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 17:06:49 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:36243 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757486Ab2HNVGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 17:06:47 -0400
MIME-Version: 1.0
In-Reply-To: <20120814200153.GA3525@polaris.bitmath.org>
References: <1344807757-2217-1-git-send-email-rydberg@euromail.se>
	<1344807757-2217-3-git-send-email-rydberg@euromail.se>
	<CAF8JNhJzu9wW52PbydVuH9y8TwOs=mPO0DJn0aJBpsh-wETzuQ@mail.gmail.com>
	<20120814200153.GA3525@polaris.bitmath.org>
Date: Tue, 14 Aug 2012 14:06:45 -0700
Message-ID: <CAF8JNhJVUitsxQXTZAMSszzXXb_QG2oxVTdcJN40JTycmQNOrA@mail.gmail.com>
Subject: Re: [PATCH 02/19] Input: Improve the events-per-packet estimate
From: Ping Cheng <pinglinux@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2012 at 1:01 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
> Hi Ping,
>
> Long time no see. :-)
>
>> > +       /* Make room for KEY and MSC events */
>> > +       events += 7;
>>
>> It is nice to get rid of the redundant pieces and to incorporate
>> common functions. Thank you.
>>
>> I have a question about the code above though.  Why do we use 7
>> instead of going through the keys like:
>>
>>       for (i = 0; i < KEY_MAX; i++)
>>               if (test_bit(i, dev->keybit))
>>                       events++;
>
> Keyboards register a large amount of different keys, but seldom send
> more than one or two at a time. The value 7 is ad hoc, admittedly, but
> it makes the default buffer 8 bytes, which happens to precisely match
> the default buffer in evdev.

That can be a valid reason until we need to report more keys
simultaneously. Please update the comments so we know why we end up
with 7.

Thank you.

Ping
