Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751918Ab1GTVPJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 17:15:09 -0400
Received: from smtp-out.google.com ([74.125.121.67]:21598 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab1GTVPI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 17:15:08 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=FgdZUn0sE5K6kVe/JxRDrLFY3BnXxovaZOJeI2jvaEY8zYoWDxt8k1zeoe+HQ3Yhg
	YdmNdVGjsBhsW8qirrLUQ==
MIME-Version: 1.0
In-Reply-To: <20110720210704.GF3400@redhat.com>
References: <1310760670-32232-1-git-send-email-zakmagnus@google.com>
	<20110718122820.GB1808@redhat.com>
	<CAAuSN9106qmYF27oRrfUBtqwOmSQgDJWwv3iz_NmTTuYNEymHA@mail.gmail.com>
	<20110720154124.GS3765@redhat.com>
	<CAAuSN9362PvjiJCQti=GAKGjZNnptV3e9Ot0kBpo40b8L7u0mA@mail.gmail.com>
	<20110720210704.GF3400@redhat.com>
Date: Wed, 20 Jul 2011 14:15:02 -0700
Message-ID: <CAAuSN90cv8iz+EMaVP5QQREs8sQC+m4u55nMLOFXKuFXxpX8Cw@mail.gmail.com>
Subject: Re: [PATCH v2] Track hard and soft "short lockups" or "stalls."
From: ZAK Magnus <zakmagnus@google.com>
To: Don Zickus <dzickus@redhat.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 20, 2011 at 2:07 PM, Don Zickus <dzickus@redhat.com> wrote:
> On Wed, Jul 20, 2011 at 12:41:39PM -0700, ZAK Magnus wrote:
>> Are the stack traces very different? I don't understand in what sense
>> it's confusing.
>
> The fact that there are 3 of them telling me the samething.  Most people
> look at the first stack trace to figure out what is going on and will just
> notice the warning.  They might completely miss the HARDLOCKUP message on
> the third stack trace down.
>
> It just looked odd when I ran it the first time.  I feel like I would
> constantly be trying to educate people on why we do it like that.
Oh, okay. So, maybe the stall warnings should say something like, "a
lockup might happen soon?" Would that help? I don't know.

>> I don't think that exact patch would work (wouldn't it cause
>> update_hardstall to only ever be called with 0 as its first argument?)
>> but I hope I still understand what you're saying. You're saying stalls
>> should only be recorded once they're finished, right? I don't know if
>> this is the best approach. If we wait until interrupts stop being
>> missed, it means the code could have exited whatever section caused
>> the stall to begin with. Maybe your data indicates otherwise, but I
>> would think this means the stack trace would not really be
>
> Crap.  good point.
Which part, exactly?

>> informative. It's one thing to know a stall occurs, but its occurrence
>> is generally reflective of a bug or a suboptimal section, so it would
>> be good to know where that is in order to try and fix it.
>>
>> For soft stalls, I think the same is true. Also, since the soft lockup
>> system just relies on checking a timestamp compared to now, it can't
>> know how long a stall was after it has already finished. The hard
>> system only knows because it keeps a running count of the number of
>> failed checks. An additional timestamp could be introduced and the
>> difference between the two retroactively checked in order to reproduce
>> this, but the stack trace issue would still apply. Also, while not
>> hugely complex, the change would be more significant than the sort
>> your patch presents.
>>
>> The bottom line is that I think catching a stall in progress is the
>> most informative thing to do, and I don't understand the downsides of
>> doing so. Could you please explain them?
>>
>> On another note, I'm working on a patch on top of this one which would
>> change the hard lockup system to be more like the soft lockup system.
>> It would use a timestamp as well, so it can have a more exact read on
>> how long the timer has been delayed. This adds resolution and gets rid
>> of that problem where it can only report missed = 3 or 4. Any
>> preliminary comments? Or should I just put the patch up before
>> discussing it?
>
> That might work.  I would have to see the patch.  What clock would you use
> to read the time?  I don't think you can use 'now' if interrupts are
> disabled.
Okay, I will send it when it seems ready. For the timestamp, I was
just using the get_timestamp function that's defined in the file,
which calls cpu_clock(). Is there a better way?
