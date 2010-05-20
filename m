Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317Ab0ETWTl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 18:19:41 -0400
Received: from mail-pz0-f185.google.com ([209.85.222.185]:56787 "EHLO
	mail-pz0-f185.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754808Ab0ETWTj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 18:19:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ml/LdwV3EVtgYDR6LI4y8QTartG0muNEYvbHHaNpLYPBy5lOsvVnnii7pyGc4qQNcr
         sGzoFMouN3GIm0QReWW/BVpYSuLIlLNn2NtMmC3qvf082q3q+XG5CZwK+ntsGI2eFk3z
         XvxMuSlW8xUArUWMDX7JXAmc03Mo6Sj95NNgA=
MIME-Version: 1.0
In-Reply-To: <4BF4E00A.30206@euromail.se>
References: <1274213429-22667-1-git-send-email-rydberg@euromail.se>
	 <1274213429-22667-2-git-send-email-rydberg@euromail.se>
	 <AANLkTikpmYwEYh5Dh-p3478cDMVo9hXOsDkt54ltHW6J@mail.gmail.com>
	 <4BF4E00A.30206@euromail.se>
Date: Thu, 20 May 2010 15:19:37 -0700
Message-ID: <AANLkTinYX96zokFF6Rc-3_gxIrMZmvMS_pw3YdQD6CG4@mail.gmail.com>
Subject: Re: [PATCH 2/2] input: mt: Document the MT event slot protocol (rev2)
From: Ping Cheng <pinglinux@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Mika Kuoppala <mika.kuoppala@nokia.com>,
       Peter Hutterer <peter.hutterer@who-t.net>,
       Benjamin Tissoires <tissoire@cena.fr>, Stephane Chatty <chatty@enac.fr>,
       Rafi Rubin <rafi@seas.upenn.edu>, Michael Poole <mdpoole@troilus.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 20, 2010 at 12:08 AM, Henrik Rydberg <rydberg@euromail.se> wrote:
> Hi Ping,
>
> first out, thank you for your detailed analysis, it aids in removing ambiguities
>  and defining the borders of the protocol.

Glad to hear from you directly this time :). I have more questions.

> It helps to think of both TRACKING_ID and BLOB_ID as labels of a single
> identified contact which occupies one slot.

I need double check with you although I think I know the answer. From
your explanation and examples so far, I see MT_SLOT is only associated
with one (x,y). Is this true?  If yes, can we eliminate the
requirement for TRACKING_ID? If you think the requirement is
necessary, can you give me an example where missing the TRACKING_ID
would bring issue or confusion?

>To represent a set of contacts as an
> entity, one needs to add a label to the slot, representing that entity.

Doesn't MT_SLOT itself serves as a label? It has a value.  May be
ABS_MT_SLOT_ID fits the term more closely.

> As pointed out in a later reply by Peter, the BLOB_ID serves this purpose well. The
> name is slightly unfortunate, being a bit too generic. Let us use this
> discussion to pin down a more exact definition:
>
> ABS_MT_BLOB_ID is a label which groups contacts in close relation to each other,
> such as a hand.

I think I get this part.  However, (too late to regret that you've
replied to me :)

> With this in mind, the sequence becomes
>
> SYN_MT_SLOT 0
> ABS_MT_BLOB_ID 11
> ABS_MT_TRACKING_ID 45
> ABS_MT_POSITION_X x[0]
> ABS_MT_POSITION_Y y[0]
> SYN_MT_SLOT 1
> ABS_MT_BLOB_ID 11
> ABS_MT_TRACKING_ID 46
> ABS_MT_POSITION_X x[1]
> ABS_MT_POSITION_Y y[1]
> SYN_MT_SLOT 2
> ABS_MT_BLOB_ID 11
> ABS_MT_TRACKING_ID 47
> ABS_MT_POSITION_X x[2]
> ABS_MT_POSITION_Y y[2]
> SYN_MT_SLOT 3
> ABS_MT_BLOB_ID 89
> ABS_MT_TRACKING_ID 30
> ABS_MT_POSITION_X x[3]
> ABS_MT_POSITION_Y y[3]
> SYN_REPORT

I would think something like the following would make sense too:

ABS_MT_BLOB_ID 11
ABS_MT_TRACKING_ID 45
ABS_MT_SLOT_ID 0
ABS_MT_POSITION_X x[0]
ABS_MT_POSITION_Y y[0]
ABS_MT_SLOT_ID 1
ABS_MT_POSITION_X x[1]
ABS_MT_POSITION_Y y[1]
ABS_MT_SLOT_ID 2
ABS_MT_POSITION_X x[2]
ABS_MT_POSITION_Y y[2]
SYN_MT_BLOB
ABS_MT_BLOB_ID 89
ABS_MT_SLOT_ID 3
ABS_MT_TRACKING_ID 30
ABS_MT_POSITION_X x[3]
ABS_MT_POSITION_Y y[3]
SYN_MT_BLOB
SYN_REPORT

where we have two blob of data. They represent finger 1 and finger 2.
Finger 1 has a tracking number 11 while finger 2 has 30.  We do not
track the three contacts inside the blob since they all belong to the
same finger.  We could even combine type A and B as:

ABS_MT_TRACKING_ID 0      # indicates first finger or hand
ABS_MT_BLOB 3                     # indicates 3 contacts in the blob
ABS_MT_POSITION_X x[0]
ABS_MT_POSITION_Y y[0]
SYN_MT_REPORT
ABS_MT_POSITION_X x[1]
ABS_MT_POSITION_Y y[1]
SYN_MT_REPORT
ABS_MT_POSITION_X x[2]
ABS_MT_POSITION_Y y[2]
SYN_MT_REPORT
ABS_MT_TRACKING_ID 1      # indicates second finger or hand
ABS_MT_BLOB_ID 1               # indicates 1 contact in the blob
ABS_MT_POSITION_X x[3]
ABS_MT_POSITION_Y y[3]
SYN_REPORT

where SYN_MT_BLOB is unnecessary since we know how many contacts we
are going to get. I would expect this approach complicates the
implementation in the kernel. So I am not sure if it makes sense to
use it or not.  Just to share some random thoughts with you.

Ping
