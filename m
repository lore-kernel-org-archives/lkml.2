Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933389Ab0DHWNK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 18:13:10 -0400
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:54533 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758917Ab0DHWNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 18:13:07 -0400
Message-ID: <4BBE54E1.9020608@euromail.se>
Date: Fri, 09 Apr 2010 00:12:49 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: Rafi Rubin <rafi@seas.upenn.edu>
CC: Michael Poole <mdpoole@troilus.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: mt: introduce MT event slots
References: <1270685590-2204-1-git-send-email-rydberg@euromail.se> <87tyrmiqw2.fsf@troilus.org> <4BBDA555.1020003@euromail.se> <4BBE2B4D.9040808@seas.upenn.edu> <4BBE3BC4.2030503@euromail.se> <4BBE4969.60802@seas.upenn.edu>
In-Reply-To: <4BBE4969.60802@seas.upenn.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1Nzzy1-0006vl-7d.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1Nzzy1-0006vl-7d 3fa09acbfd93239b10bd55013aa1fe02
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafi Rubin wrote:
[...]

>>> Is there any particular downside to defaulting to implicit slot ids?
>> Yes. The device driver should not have to update every slot between
>> synchronizations, or the point would be lost.
>>
>>> For drivers/hardware that don't handle tracking, SYN_MT_REPORT could
>>> just result in dev->slot++ and a SYN_REPORT resets dev->slot to 0;
>> Drivers that do not handle tracking should not use the slots at all. The slot
>> concept requires that whatever gets communicated over it is identifiable, or
>> else it would not be possible to send changes. Drivers without tracking
>> capabilities should stick to the current MT protocol, for which it was designed.
> 
> That's unfortunate.
> 
> I think tracking upsets are generally quite rare (at least for the n-trig
> hardware), and we would see most of the benefit of jitter and bandwidth
> reduction even if we use contact ordering for slots.  Tracking upsets would
> still flow downstream, a large state change should cause the slot to emit the
> new position.
> 
> I was also hoping the slotting mechanism might be a good place to inject generic
> tracking support later.

But it is! It was not my intention to discourage the slot protocol for a driver
that *wants* to track contacts, only the ones that do not. As you already
guessed, there is a natural migration path towards using the slot extension and
kernel-provided software finger tracking.

Cheers,
Henrik

