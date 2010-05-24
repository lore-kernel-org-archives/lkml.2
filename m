Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758086Ab0EXSDX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 14:03:23 -0400
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:46950 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753546Ab0EXSDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 14:03:21 -0400
Message-ID: <4BFABF40.30700@euromail.se>
Date: Mon, 24 May 2010 20:02:40 +0200
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
References: <1274567437-2818-1-git-send-email-rydberg@euromail.se>	 <1274567437-2818-2-git-send-email-rydberg@euromail.se>	 <20100523102413.2fee3f4c.rdunlap@xenotime.net>	 <4BF9ABC7.9090208@euromail.se>	 <AANLkTimQIIPiah962ar_TRZvJZpqCFvh-KLXxakbUHmZ@mail.gmail.com>	 <4BFA272B.7090602@euromail.se> <AANLkTimro6rna8MTqylaE2cnr_7Fif68Ldc6czLk7UDG@mail.gmail.com>
In-Reply-To: <AANLkTimro6rna8MTqylaE2cnr_7Fif68Ldc6czLk7UDG@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1OGbz9-0001rm-3d.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1OGbz9-0001rm-3d 6f7c5cb888a83253e33bf55054a33cd3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping Cheng wrote:
> On Mon, May 24, 2010 at 12:13 AM, Henrik Rydberg <rydberg@euromail.se> wrote:
>> Ping Cheng wrote:
>>> What I am thinking is that we only need one SYN_ call for both _MT_
>>> and regular data combined, which is a call to input_sync() at the end
>>> of the whole packet. The SYN_MT_ can be replaced by the following
>>> example, which I think is more "client-friendly". This solution is
>>> based on the fact that the major difference between type A and type B
>>> is whether we need to filter the data or not:
>>>
>>> ABS_MT_RANDOM 0
>>> ABS_MT_POSITION_X x[0]
>>> ABS_MT_POSITION_Y y[0]
>>> ABS_MT_ RANDOM 1
>>> ABS_MT_POSITION_X x[1]
>>> ABS_MT_POSITION_Y y[1]
>>> SYN_REPORT
>>>
>>> input_set_abs_params(input_dev, ABS_MT_RANDOM, 0, 2, 0, 0);
>>>
>>> would tell the clients that they can expect two random touches.
>> And if you do s/RANDOM/SLOT/, you end up with what? ;-)
> 
> Haha, I know what you are thinking :).
> 
> Maybe I didn't make my point clear.  I didn't mean to make SLOT
> backward compatible.  I meant to replace SYN_MT_REPORT event with the
> ABS_MT_ RANDOM label so we only sync the whole packet once at the end.
> This way both types of MT_ data follow the same input event reporting
> flow....

You mean changing the type A protocol, breaking the current code base? That is a
big no-no.

> SLOT and RANDOM are both needed since they deal with two different
> types of MT data, filtered (type B) and unfiltered (type A). There is
> no midunderstanding there.
> 
> Ping

Henrik
