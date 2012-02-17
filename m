Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755784Ab2BQCMA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 21:12:00 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:64085 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753796Ab2BQCL7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 21:11:59 -0500
MIME-Version: 1.0
In-Reply-To: <201202152337.22072.rjw@sisk.pl>
References: <201202070200.55505.rjw@sisk.pl>
	<201202070205.07589.rjw@sisk.pl>
	<CAMP5XgdPmyOp4ECoS3t7NUvQz+cWbq9eMRQSSQn3073w2P4t5w@mail.gmail.com>
	<201202152337.22072.rjw@sisk.pl>
Date: Thu, 16 Feb 2012 18:11:58 -0800
Message-ID: <CAMP5Xgd0Ve=rtwxCAtPrMS9ycbkt+Fo9VDW4sjp2s5oBTm0ZQw@mail.gmail.com>
Subject: Re: [RFC][PATCH 5/8] PM / Sleep: Change wakeup statistics
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, markgross@thegnar.org,
        Matthew Garrett <mjg@redhat.com>, Greg KH <greg@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Brian Swetland <swetland@google.com>, Neil Brown <neilb@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/2/15 Rafael J. Wysocki <rjw@sisk.pl>:
> On Wednesday, February 15, 2012, Arve Hjønnevåg wrote:
>> On Mon, Feb 6, 2012 at 5:05 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> > From: Rafael J. Wysocki <rjw@sisk.pl>
>> >
>> > Wakeup statistics used by Android are slightly different from what we
>> > have at the moment, so modify them to follow Android more closely.
>> ...
>> > @@ -438,6 +444,11 @@ static void wakeup_source_deactivate(str
>> >        if (ktime_to_ns(duration) > ktime_to_ns(ws->max_time))
>> >                ws->max_time = duration;
>> >
>> > +       ws->last_time = now;
>> > +       if (ws->has_timeout && time_after(jiffies, ws->timer_expires))
>>
>> time_after_eq may work better (or increment the count from the timer).
>
> I think incrementing the count from the timer is a better approach.
>

OK.

>> I applied this patch and the expire counts I see for wakeup-sources
>> that always time-out do not match the active count.
>
> I see.  The reason may also be that __pm_wakeup_event() increments
> ws->event_count even if the wakeup source is already active.
>

The active count, which is what I was looking at, only changes if it
was not already active though.

-- 
Arve Hjønnevåg
