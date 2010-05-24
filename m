Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756765Ab0EXTTc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 15:19:32 -0400
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:33716 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752526Ab0EXTTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 15:19:30 -0400
Message-ID: <4BFAD12D.1000607@euromail.se>
Date: Mon, 24 May 2010 21:19:09 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Ping Cheng <pinglinux@gmail.com>,
       Peter Hutterer <peter.hutterer@who-t.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Mika Kuoppala <mika.kuoppala@nokia.com>,
       Benjamin Tissoires <tissoire@cena.fr>, Stephane Chatty <chatty@enac.fr>,
       Rafi Rubin <rafi@seas.upenn.edu>, Michael Poole <mdpoole@troilus.org>
Subject: Re: [PATCH 2/2] input: mt: Document the MT event slot protocol (rev2)
References: <1274213429-22667-1-git-send-email-rydberg@euromail.se> <20100524155901.GB3182@core.coreip.homeip.net> <AANLkTin9ahtqL7jrUP4C0zF9-P3rUg7ktN93-hcqdDnj@mail.gmail.com> <201005241021.02731.dmitry.torokhov@gmail.com> <4BFABBD0.9020202@euromail.se> <20100524180411.GA6033@core.coreip.homeip.net>
In-Reply-To: <20100524180411.GA6033@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1OGdBD-0001L2-CZ.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1OGdBD-0001L2-CZ 00f6678791e25ec1cdceb18397108afc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov wrote:
> On Mon, May 24, 2010 at 07:48:00PM +0200, Henrik Rydberg wrote:
>> Dmitry Torokhov wrote:
>> [...]
>>>>>> I think we need to add an ioctl to enable user land driver/client to
>>>>>> signal the kernel driver to send all events without filtering, just
>>>>>> once. Hot-plugged devices and X driver starts after user has contacted
>>>>>> with the device are two examples that the client would miss filtered
>>>>>> events.
>>>>>>
>>>>>> Dmitry, do you think it is a valid suggestion?
>>>>> What about using EVIOCGKEY/EVIOCGSW/EVIOCGABS?
>>>> Those EVIOCs only give us the static values (max/min/supported keys,
>>>> etc.).  We need their dynamic input data here, the actual x, y,
>>>> button, pressure, etc. Am I missing something about those EVIOs?
>>>>
>>> Yes you are ;) Supported events are reported via EVIOCGBIT, EVIOCGKEY and
>>> EVIOCGSW will return current state of keys/switches. As far as EVIOCGABS
>>> goes, it also returns, besides min/max/etc, last reported _values_ of the
>>> ABS_* events.
>>>
>> Ping is not alone. :-)
>>
>> But it does not work for MT events -- yet.
>>
> 
> Yes, this is true.
> 
> I think the most interesting is the switch data, since they may not change
> at all. The rest is transient and should refresh "fairly quickly".
> 

Still, if one allows EVIOCSABS(ABS_MT_SLOT) to set a slot state in evdev instead
of modifying the input_dev, one could extract all ABS_MT events in sequence via
EVIOCGABS.

Henrik
