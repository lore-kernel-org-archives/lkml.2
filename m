Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748Ab0ETWs7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 18:48:59 -0400
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:60469 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753002Ab0ETWs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 18:48:58 -0400
Message-ID: <4BF5BC48.6000809@euromail.se>
Date: Fri, 21 May 2010 00:48:40 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Ping Cheng <pinglinux@gmail.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Mika Kuoppala <mika.kuoppala@nokia.com>,
       Peter Hutterer <peter.hutterer@who-t.net>,
       Benjamin Tissoires <tissoire@cena.fr>, Stephane Chatty <chatty@enac.fr>,
       Rafi Rubin <rafi@seas.upenn.edu>, Michael Poole <mdpoole@troilus.org>
Subject: Re: [PATCH 2/2] input: mt: Document the MT event slot protocol (rev2)
References: <1274213429-22667-1-git-send-email-rydberg@euromail.se>	 <1274213429-22667-2-git-send-email-rydberg@euromail.se>	 <AANLkTikpmYwEYh5Dh-p3478cDMVo9hXOsDkt54ltHW6J@mail.gmail.com>	 <4BF4E00A.30206@euromail.se> <AANLkTinYX96zokFF6Rc-3_gxIrMZmvMS_pw3YdQD6CG4@mail.gmail.com>
In-Reply-To: <AANLkTinYX96zokFF6Rc-3_gxIrMZmvMS_pw3YdQD6CG4@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1OFEXm-0004pp-4Q.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1OFEXm-0004pp-4Q b8c6c74b4db9cf5bf68caa4e2fea5a90
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping Cheng wrote:
> On Thu, May 20, 2010 at 12:08 AM, Henrik Rydberg <rydberg@euromail.se> wrote:
>> Hi Ping,
>>
>> first out, thank you for your detailed analysis, it aids in removing ambiguities
>>  and defining the borders of the protocol.
> 
> Glad to hear from you directly this time :). I have more questions.
> 
>> It helps to think of both TRACKING_ID and BLOB_ID as labels of a single
>> identified contact which occupies one slot.
> 
> I need double check with you although I think I know the answer. From
> your explanation and examples so far, I see MT_SLOT is only associated
> with one (x,y). Is this true?  If yes, can we eliminate the
> requirement for TRACKING_ID? If you think the requirement is
> necessary, can you give me an example where missing the TRACKING_ID
> would bring issue or confusion?

Yes, each slot can only be associated with one (x, y) pair. No, we cannot
disregard the tracking id. A slot tracks a single contact for its entire
lifetime, during which the tracking id serves no purpose, but the slot cannot
tell us when the contact is replaced by a new one. This information is carried
by the tracking id.

> 
>> To represent a set of contacts as an
>> entity, one needs to add a label to the slot, representing that entity.
> 
> Doesn't MT_SLOT itself serves as a label? It has a value.  May be
> ABS_MT_SLOT_ID fits the term more closely.

The slot id tells which slot is currently being modified, and carries no
information about the slot itself. To represent a relation between different
contacts, a value representing that relation needs to be added to the event
stream, there is no doubt about that. The BLOB_ID is such a label, and there
will likely be others in the future as well.

> 
>> As pointed out in a later reply by Peter, the BLOB_ID serves this purpose well. The
>> name is slightly unfortunate, being a bit too generic. Let us use this
>> discussion to pin down a more exact definition:
>>
>> ABS_MT_BLOB_ID is a label which groups contacts in close relation to each other,
>> such as a hand.
> 
> I think I get this part.  However, (too late to regret that you've
> replied to me :)
> 
>> With this in mind, the sequence becomes
>>
>> SYN_MT_SLOT 0
>> ABS_MT_BLOB_ID 11
>> ABS_MT_TRACKING_ID 45
>> ABS_MT_POSITION_X x[0]
>> ABS_MT_POSITION_Y y[0]
>> SYN_MT_SLOT 1
>> ABS_MT_BLOB_ID 11
>> ABS_MT_TRACKING_ID 46
>> ABS_MT_POSITION_X x[1]
>> ABS_MT_POSITION_Y y[1]
>> SYN_MT_SLOT 2
>> ABS_MT_BLOB_ID 11
>> ABS_MT_TRACKING_ID 47
>> ABS_MT_POSITION_X x[2]
>> ABS_MT_POSITION_Y y[2]
>> SYN_MT_SLOT 3
>> ABS_MT_BLOB_ID 89
>> ABS_MT_TRACKING_ID 30
>> ABS_MT_POSITION_X x[3]
>> ABS_MT_POSITION_Y y[3]
>> SYN_REPORT
> 
> I would think something like the following would make sense too:
> 
> ABS_MT_BLOB_ID 11
> ABS_MT_TRACKING_ID 45
> ABS_MT_SLOT_ID 0
> ABS_MT_POSITION_X x[0]
> ABS_MT_POSITION_Y y[0]
> ABS_MT_SLOT_ID 1
> ABS_MT_POSITION_X x[1]
> ABS_MT_POSITION_Y y[1]
> ABS_MT_SLOT_ID 2
> ABS_MT_POSITION_X x[2]
> ABS_MT_POSITION_Y y[2]
> SYN_MT_BLOB
> ABS_MT_BLOB_ID 89
> ABS_MT_SLOT_ID 3
> ABS_MT_TRACKING_ID 30
> ABS_MT_POSITION_X x[3]
> ABS_MT_POSITION_Y y[3]
> SYN_MT_BLOB
> SYN_REPORT
> 
> where we have two blob of data. They represent finger 1 and finger 2.
> Finger 1 has a tracking number 11 while finger 2 has 30.  We do not
> track the three contacts inside the blob since they all belong to the
> same finger.  We could even combine type A and B as:

Well, the way the protocol is defined, SYN_MT_BLOB does not exist, and any
attribute change outside the slot id context simply has no meaning.

> 
> ABS_MT_TRACKING_ID 0      # indicates first finger or hand
> ABS_MT_BLOB 3                     # indicates 3 contacts in the blob
> ABS_MT_POSITION_X x[0]
> ABS_MT_POSITION_Y y[0]
> SYN_MT_REPORT
> ABS_MT_POSITION_X x[1]
> ABS_MT_POSITION_Y y[1]
> SYN_MT_REPORT
> ABS_MT_POSITION_X x[2]
> ABS_MT_POSITION_Y y[2]
> SYN_MT_REPORT
> ABS_MT_TRACKING_ID 1      # indicates second finger or hand
> ABS_MT_BLOB_ID 1               # indicates 1 contact in the blob
> ABS_MT_POSITION_X x[3]
> ABS_MT_POSITION_Y y[3]
> SYN_REPORT
> 
> where SYN_MT_BLOB is unnecessary since we know how many contacts we
> are going to get. I would expect this approach complicates the
> implementation in the kernel. So I am not sure if it makes sense to
> use it or not.  Just to share some random thoughts with you.

Thank you for your random suggestions.

Henrik

