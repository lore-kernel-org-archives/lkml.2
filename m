Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211Ab0EXHOB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 03:14:01 -0400
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:60976 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755808Ab0EXHN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 03:13:59 -0400
Message-ID: <4BFA272B.7090602@euromail.se>
Date: Mon, 24 May 2010 09:13:47 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Ping Cheng <pinglinux@gmail.com>
CC: Randy Dunlap <rdunlap@xenotime.net>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Mika Kuoppala <mika.kuoppala@nokia.com>,
       Peter Hutterer <peter.hutterer@who-t.net>,
       Benjamin Tissoires <tissoire@cena.fr>, Stephane Chatty <chatty@enac.fr>,
       Rafi Rubin <rafi@seas.upenn.edu>, Michael Poole <mdpoole@troilus.org>
Subject: Re: [PATCH 2/2] input: mt: Document the MT event slot protocol (rev4)
References: <1274567437-2818-1-git-send-email-rydberg@euromail.se>	 <1274567437-2818-2-git-send-email-rydberg@euromail.se>	 <20100523102413.2fee3f4c.rdunlap@xenotime.net>	 <4BF9ABC7.9090208@euromail.se> <AANLkTimQIIPiah962ar_TRZvJZpqCFvh-KLXxakbUHmZ@mail.gmail.com>
In-Reply-To: <AANLkTimQIIPiah962ar_TRZvJZpqCFvh-KLXxakbUHmZ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1OGRrD-000291-CU.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1OGRrD-000291-CU 6460ae0ce11c10775ad9c3f1d9698cf7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping Cheng wrote:
> On Sun, May 23, 2010 at 3:27 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
>> Randy Dunlap wrote:
>> [...]
>>>> +Protocol Usage
>>>> +--------------
>>>> +
>>>> +Contact details are sent sequentially as separate packets of ABS_MT
>>>> +events. Only the ABS_MT events are recognized as part of a contact
>>>> +packet. Since these events are ignored by current single-touch (ST)
>>>> +applications, the MT protocol can be implemented on top of the ST protocol
>>>> +in an existing driver.
>>>> +
>>>> +Drivers for type A devices mark the end of a packet by calling the
>>> end?
> 
> Since Randy brought this question up, I feel the urge to say
> something.  I know there are X drivers and clients using the type A
> format so I am not suggesting that we need to change this format.

It is tempting to try to make type B backwards compatible, but unfortunately,
that is not possible. A type A receiver will always expect all data, and a type
B device will never send all data.

> 
> What I am thinking is that we only need one SYN_ call for both _MT_
> and regular data combined, which is a call to input_sync() at the end
> of the whole packet. The SYN_MT_ can be replaced by the following
> example, which I think is more "client-friendly". This solution is
> based on the fact that the major difference between type A and type B
> is whether we need to filter the data or not:
> 
> ABS_MT_RANDOM 0
> ABS_MT_POSITION_X x[0]
> ABS_MT_POSITION_Y y[0]
> ABS_MT_ RANDOM 1
> ABS_MT_POSITION_X x[1]
> ABS_MT_POSITION_Y y[1]
> SYN_REPORT
> 
> input_set_abs_params(input_dev, ABS_MT_RANDOM, 0, 2, 0, 0);
> 
> would tell the clients that they can expect two random touches.

And if you do s/RANDOM/SLOT/, you end up with what? ;-)

Henrik

