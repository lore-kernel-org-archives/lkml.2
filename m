Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129Ab2HOAyM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 20:54:12 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:57171 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751044Ab2HOAyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 20:54:10 -0400
MIME-Version: 1.0
In-Reply-To: <20120814211200.GA32249@core.coreip.homeip.net>
References: <1344807757-2217-1-git-send-email-rydberg@euromail.se>
	<1344807757-2217-3-git-send-email-rydberg@euromail.se>
	<CAF8JNhJzu9wW52PbydVuH9y8TwOs=mPO0DJn0aJBpsh-wETzuQ@mail.gmail.com>
	<2226930.JeU38gc4Sp@dtor-d630.eng.vmware.com>
	<CAF8JNh+sLixXBw7zLFnLSnhR8rq+=cxXm724yJoF9+v9-4fOyA@mail.gmail.com>
	<20120814211200.GA32249@core.coreip.homeip.net>
Date: Tue, 14 Aug 2012 17:54:08 -0700
Message-ID: <CAF8JNhJZC5QBW7mMTCag613zeC8ST-b1U1EhosxesPmPO2f1qQ@mail.gmail.com>
Subject: Re: [PATCH 02/19] Input: Improve the events-per-packet estimate
From: Ping Cheng <pinglinux@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2012 at 2:12 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> >> On Sun, Aug 12, 2012 at 2:42 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
> >> > Many MT devices send a number of keys along with the mt information.
> >> > This patch makes sure that there is room for them in the packet
> >> > buffer.
>>
>> So, what device are we talking about here? I thought it is a touch
>> device with a few extra buttons, which are reported as key events. Am
>> I missing something?
>
> I was talking about a bog-standard computer keyboard here.
>
>>
>> If it is a touch device, we won't have too many buttons. So,
>> test_bit(i, dev->keybit) won't be true for more than the number of
>> buttons that declared by __set_bit().
>
> input_estimate_events_per_packet() is a generic routine that is used for
> all devices, not only [multi]touch.

I understand you are talking about standard keyboard. And I know this
routine is for all devices.

However, from the commit comments, the patch is to address an MT
issue. If it is not just for MT, we need either to make it clear in
the comments or to verify the type of the device in the code.

>> I would think we could play a keyboard (this keyboard does not have
>> letters on it ;-) with ten fingers.
>
> But even that keyboard would have more than 10 keys, right? So even
> though max_events should be 10 + 10 + 1 (10 keys, 10 msc, syn) your loop
> would produce what 88 + 88 + 1 for full size music keyboard?

No, I was not talking about implementing full music keyboard functions
in the kernel. My point was: why do we take 7 instead of 10, or
another number?

In fact, 7 works for me as long as we explain the rationale behind the
decision. I do not have a device that needs to post 10 button events
simultaneously, yet ;-).

Ping
