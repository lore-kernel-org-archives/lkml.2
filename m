Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757973Ab0EXRB6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 13:01:58 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:47477 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757828Ab0EXRB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 13:01:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=LLeQYqODzF5FeInBvvuXz4sWvF/f1Jp9F1KaWZI79N4YDaLUDYhLT+Y4Yb0f3TecAh
         gNCX8e49OKNjJcfX2ssm/UUA97VnI2F6pS49o8vwS9fkagjZEmUKsiUzo1GK6XogSmID
         uMkoBheXdKQS8s6Tbqmq6wP3NPoO0D2ReuVGw=
MIME-Version: 1.0
In-Reply-To: <4BFA272B.7090602@euromail.se>
References: <1274567437-2818-1-git-send-email-rydberg@euromail.se>
	 <1274567437-2818-2-git-send-email-rydberg@euromail.se>
	 <20100523102413.2fee3f4c.rdunlap@xenotime.net>
	 <4BF9ABC7.9090208@euromail.se>
	 <AANLkTimQIIPiah962ar_TRZvJZpqCFvh-KLXxakbUHmZ@mail.gmail.com>
	 <4BFA272B.7090602@euromail.se>
Date: Mon, 24 May 2010 10:01:56 -0700
Message-ID: <AANLkTimro6rna8MTqylaE2cnr_7Fif68Ldc6czLk7UDG@mail.gmail.com>
Subject: Re: [PATCH 2/2] input: mt: Document the MT event slot protocol (rev4)
From: Ping Cheng <pinglinux@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Mika Kuoppala <mika.kuoppala@nokia.com>,
       Peter Hutterer <peter.hutterer@who-t.net>,
       Benjamin Tissoires <tissoire@cena.fr>, Stephane Chatty <chatty@enac.fr>,
       Rafi Rubin <rafi@seas.upenn.edu>, Michael Poole <mdpoole@troilus.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 24, 2010 at 12:13 AM, Henrik Rydberg <rydberg@euromail.se> wrote:
> Ping Cheng wrote:
>> What I am thinking is that we only need one SYN_ call for both _MT_
>> and regular data combined, which is a call to input_sync() at the end
>> of the whole packet. The SYN_MT_ can be replaced by the following
>> example, which I think is more "client-friendly". This solution is
>> based on the fact that the major difference between type A and type B
>> is whether we need to filter the data or not:
>>
>> ABS_MT_RANDOM 0
>> ABS_MT_POSITION_X x[0]
>> ABS_MT_POSITION_Y y[0]
>> ABS_MT_ RANDOM 1
>> ABS_MT_POSITION_X x[1]
>> ABS_MT_POSITION_Y y[1]
>> SYN_REPORT
>>
>> input_set_abs_params(input_dev, ABS_MT_RANDOM, 0, 2, 0, 0);
>>
>> would tell the clients that they can expect two random touches.
>
> And if you do s/RANDOM/SLOT/, you end up with what? ;-)

Haha, I know what you are thinking :).

Maybe I didn't make my point clear.  I didn't mean to make SLOT
backward compatible.  I meant to replace SYN_MT_REPORT event with the
ABS_MT_ RANDOM label so we only sync the whole packet once at the end.
This way both types of MT_ data follow the same input event reporting
flow....

SLOT and RANDOM are both needed since they deal with two different
types of MT data, filtered (type B) and unfiltered (type A). There is
no midunderstanding there.

Ping
