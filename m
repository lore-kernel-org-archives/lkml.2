Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500Ab0EWW2D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 18:28:03 -0400
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:34963 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754890Ab0EWW2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 18:28:00 -0400
Message-ID: <4BF9ABC7.9090208@euromail.se>
Date: Mon, 24 May 2010 00:27:19 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Mika Kuoppala <mika.kuoppala@nokia.com>,
       Peter Hutterer <peter.hutterer@who-t.net>,
       Benjamin Tissoires <tissoire@cena.fr>, Stephane Chatty <chatty@enac.fr>,
       Rafi Rubin <rafi@seas.upenn.edu>, Michael Poole <mdpoole@troilus.org>
Subject: Re: [PATCH 2/2] input: mt: Document the MT event slot protocol (rev4)
References: <1274567437-2818-1-git-send-email-rydberg@euromail.se>	<1274567437-2818-2-git-send-email-rydberg@euromail.se> <20100523102413.2fee3f4c.rdunlap@xenotime.net>
In-Reply-To: <20100523102413.2fee3f4c.rdunlap@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1OGJdo-0005By-Ae.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1OGJdo-0005By-Ae 7112102b085a0c9879bc6f7cfaf322cf
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
[...]
>> +Protocol Usage
>> +--------------
>> +
>> +Contact details are sent sequentially as separate packets of ABS_MT
>> +events. Only the ABS_MT events are recognized as part of a contact
>> +packet. Since these events are ignored by current single-touch (ST)
>> +applications, the MT protocol can be implemented on top of the ST protocol
>> +in an existing driver.
>> +
>> +Drivers for type A devices mark the end of a packet by calling the
> 
> end?
> 
>> +input_mt_sync() function, which generates a SYN_MT_REPORT event. This
>> +instructs the receiver to accept the data for the current contact and
>> +prepare to receive another. Drivers for type B devices mark the beginning
> 
> vs. beginning?  Seems incongruous.  And not just to the doc, but to
> producers and consumers as well.

Perhaps this modification makes it clearer?

Drivers for type A devices separate contact packets by calling
input_mt_sync() at the end of each packet. This generates a SYN_MT_REPORT
event, which instructs the receiver to accept the data for the current
contact and prepare to receive another.

Drivers for type B devices separate contact packets by calling
input_mt_slot(), with a slot as argument, at the beginning of each packet.
This generates an ABS_MT_SLOT event, which instructs the receiver to
prepare for updates of the given slot.

>> +of a packet by calling the input_mt_slot() function with a slot as
>> +argument, which generates an ABS_MT_SLOT event. This instructs the receiver
>> +to prepare for updates of the given slot.
>> +
>> +The end of a multi-touch transfer is marked by calling the usual
> 
> The end method is done for Types A and B, right?

How about this line instead?

All drivers mark the end of a multi-touch transfer by calling the usual

>                                                                        is

Changed, thanks.

Henrik

