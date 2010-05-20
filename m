Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351Ab0ETAve (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 20:51:34 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:62144 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752895Ab0ETAvc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 20:51:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nuR1HXDzOEIP58pJgM5COLgPCPF5vae6y3i/AFoS6pj9N5d6xLZ7Q24l9VPzRacN2x
         hmgcmly/o8MqfGIOcLlpGO4bElYNzHmlvs4lJ9S6E4QhmOlvJVgQemBaR8QJb1u5qxiA
         SnyNWOFsrTerv+84d4PBrt+Z3Il0zLzCVKYZU=
MIME-Version: 1.0
In-Reply-To: <4BF48198.4090300@seas.upenn.edu>
References: <1274213429-22667-1-git-send-email-rydberg@euromail.se>
	 <1274213429-22667-2-git-send-email-rydberg@euromail.se>
	 <AANLkTikpmYwEYh5Dh-p3478cDMVo9hXOsDkt54ltHW6J@mail.gmail.com>
	 <4BF4756C.8030204@seas.upenn.edu>
	 <AANLkTinLNuyDDR0ISjOcXDatdXWEN4RIyuXc-3aSz2b3@mail.gmail.com>
	 <4BF48198.4090300@seas.upenn.edu>
Date: Wed, 19 May 2010 17:51:31 -0700
Message-ID: <AANLkTik3wNaTCh5JBI7A69QWh9RXvZo0UcuoZ-rQTDlz@mail.gmail.com>
Subject: Re: [PATCH 2/2] input: mt: Document the MT event slot protocol (rev2)
From: Ping Cheng <pinglinux@gmail.com>
To: Rafi Rubin <rafi@seas.upenn.edu>
Cc: Henrik Rydberg <rydberg@euromail.se>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Mika Kuoppala <mika.kuoppala@nokia.com>,
       Peter Hutterer <peter.hutterer@who-t.net>,
       Benjamin Tissoires <tissoire@cena.fr>, Stephane Chatty <chatty@enac.fr>,
       Michael Poole <mdpoole@troilus.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 19, 2010 at 5:26 PM, Rafi Rubin <rafi@seas.upenn.edu> wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> On 05/19/10 20:13, Ping Cheng wrote:
>> On Wed, May 19, 2010 at 4:34 PM, Rafi Rubin <rafi@seas.upenn.edu> wrote:
>>> My understanding is that it would be more like
>>> +   SYN_MT_SLOT 0
>>> +   ABS_MT_POSITION_X x
>>> +   ABS_MT_POSITION_Y y
>>> +   SYN_REPORT
>>> +   SYN_MT_SLOT 0
>>> +   ABS_MT_POSITION_X x
>>> +   ABS_MT_POSITION_Y y
>>> +   SYN_REPORT
>>> +   SYN_MT_SLOT 0
>>> +   ABS_MT_POSITION_X x
>>> +   ABS_MT_POSITION_Y y
>>> +   SYN_MT_SLOT 1
>>> +   ABS_MT_POSITION_X x
>>> +   ABS_MT_POSITION_Y y
>>> +   SYN_REPORT
>>
>> You are right if one slot only has or is only allowed to have one
>> point. My scenario is that one slot can have more than one point.
>> Basically, my intention is to utilize the MT_SLOT and MT_TRACKING_ID
>> in such a way that it avoids as much overlap as possible.
>>
>> And hopefully it makes sesne in the reality too.
>
> Please clarify by what you mean by more than one point.

I might have been confused myself by ABS_MT_BLOB_ID and SYN_MT_SLOT
here.  What I meant by "more than one point" is a contact (or touch, I
am not sure which one is the right term :) is represented by a few
(x,y) coordinates. Maybe we should use SYN_MT_SLOT for my case?

> I may be misunderstanding, but I thought that these slots are basically a
> superior replacement to tracking id.
>
> one finger -> one slot

This is what I needed to understand. Is slot for one (x,y) only or can
it also be used for more than one set of (x,y)?

> But with slots we can use the filtering that input provides, which we've been
> by-passing with the existing MT protocol (at least that's what I think Henrik's
> goal is).

Good to know that filtering has already been considered. I know I must
be out of sync with Henrik's goal.  That's why I wanted to show my
ignorance :).

Ping
