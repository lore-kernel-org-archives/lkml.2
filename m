Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759565Ab0FJQ3e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 12:29:34 -0400
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:44027 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750989Ab0FJQ3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 12:29:32 -0400
Message-ID: <4C1112B0.8070806@euromail.se>
Date: Thu, 10 Jun 2010 18:28:32 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Mika Kuoppala <mika.kuoppala@nokia.com>,
       Peter Hutterer <peter.hutterer@who-t.net>,
       Benjamin Tissoires <tissoire@cena.fr>, Stephane Chatty <chatty@enac.fr>,
       Rafi Rubin <rafi@seas.upenn.edu>, Michael Poole <mdpoole@troilus.org>
Subject: Re: [PATCH 2/2] input: mt: Document the MT event slot protocol (rev4)
References: <1274567437-2818-1-git-send-email-rydberg@euromail.se> <1274567437-2818-2-git-send-email-rydberg@euromail.se> <20100610135634.GD4514@ucw.cz>
In-Reply-To: <20100610135634.GD4514@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1OMkcQ-0008KN-75.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1OMkcQ-0008KN-75 e5fdacfcb28bc85da2daefed65022423
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Hi!
> 
>> +Protocol Example A
>> +------------------
>> +
>> +Here is what a minimal event sequence for a two-contact touch would look
>> +like for a type A device:
>> +
>> +   ABS_MT_POSITION_X x[0]
>> +   ABS_MT_POSITION_Y y[0]
>> +   SYN_MT_REPORT
>> +   ABS_MT_POSITION_X x[1]
>> +   ABS_MT_POSITION_Y y[1]
>> +   SYN_MT_REPORT
>> +   SYN_REPORT
> ...
>> -Usage
>> ------
>> +Here is the sequence after lifting the first contact:
>> +
>> +   ABS_MT_POSITION_X x[1]
>> +   ABS_MT_POSITION_Y y[1]
>> +   SYN_MT_REPORT
>> +   SYN_REPORT
> 
> ...
> 
>> +Protocol Example B
>> +------------------
>> +
>> +Here is what a minimal event sequence for a two-contact touch would look
>> +like for a type B device:
>> +
>> +   ABS_MT_SLOT 0
>> +   ABS_MT_TRACKING_ID 45
>> +   ABS_MT_POSITION_X x[0]
>> +   ABS_MT_POSITION_Y y[0]
>> +   ABS_MT_SLOT 1
>> +   ABS_MT_TRACKING_ID 46
>> +   ABS_MT_POSITION_X x[1]
>> +   ABS_MT_POSITION_Y y[1]
>> +   SYN_REPORT
>> +
>> +Here is the sequence after moving contact 45 in the x direction:
>> +
>> +   ABS_MT_SLOT 0
>> +   ABS_MT_POSITION_X x[0]
>> +   SYN_REPORT
> 
> With this proposed system, protocol A is *very* different from
> protocol B. Is there way to make them more similar?

Hello,

unfortunately, the two protocols are different for a reason. Given the point of
the type B protocol, to reduce bandwidth and accommodate filtering in the input
core, the major difference is that type A receivers always expect all data
between synchronizations, whereas type B devices never send all data. This alone
means a receiver wishing to support both type of streams will need to know what
type of stream to expect. This is accomplished by the presence of ABS_MT_SLOT.
Secondly, in order to not break the established semantics of events, ABS_MT_SLOT
is used instead SYN_MT_REPORT. This also makes type B devices in type A
applications stop working in a somewhat graceful fashion.

The usage of SYN_MT_REPORT versus ABS_MT_SLOT is the only syntactic difference
between the protocols, and it stems from the different interpretation of what
comes through the wire. IMHO, it means the way the type B protocol is formulated
is the smallest possible change that accommodates the required effect.

Thanks,
Henrik

