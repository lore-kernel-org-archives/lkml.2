Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567Ab1BQHKe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 02:10:34 -0500
Received: from smtp-out.google.com ([74.125.121.67]:12674 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971Ab1BQHKb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 02:10:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=l7wlURiwFpVAdMOO+qtllLhx2JOOxeTPdD3IbMwKZcZR4ZO3dUqP3cGst2LkjfbWat
         mIKW0RFjaOvPM6XD0DrA==
MIME-Version: 1.0
In-Reply-To: <20110217144116.58d71a7d.kamezawa.hiroyu@jp.fujitsu.com>
References: <1297920842-17299-1-git-send-email-gthelen@google.com>
 <1297920842-17299-2-git-send-email-gthelen@google.com> <20110217143315.858dd090.kamezawa.hiroyu@jp.fujitsu.com>
 <20110217144116.58d71a7d.kamezawa.hiroyu@jp.fujitsu.com>
From: Greg Thelen <gthelen@google.com>
Date: Wed, 16 Feb 2011 23:10:03 -0800
Message-ID: <AANLkTi=UG3HcuvS0VEgUt27EX9rYguzmhRk4NtNeXfci@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] memcg: break out event counters from other stats
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 16, 2011 at 9:41 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Thu, 17 Feb 2011 14:33:15 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>
>> On Wed, 16 Feb 2011 21:34:01 -0800
>> Greg Thelen <gthelen@google.com> wrote:
>>
>> > From: Johannes Weiner <hannes@cmpxchg.org>
>> >
>> > For increasing and decreasing per-cpu cgroup usage counters it makes
>> > sense to use signed types, as single per-cpu values might go negative
>> > during updates.  But this is not the case for only-ever-increasing
>> > event counters.
>> >
>> > All the counters have been signed 64-bit so far, which was enough to
>> > count events even with the sign bit wasted.
>> >
>> > The next patch narrows the usage counters type (on 32-bit CPUs, that
>> > is), though, so break out the event counters and make them unsigned
>> > words as they should have been from the start.
>> >
>> > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
>> > Signed-off-by: Greg Thelen <gthelen@google.com>
>>
>> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>>
>
> Hmm..but not mentioning the change "s64 -> unsigned long(may 32bit)" clearly
> isn't good behavior.
>
> Could you clarify both of changes in patch description as
> ==
> This patch
>  - devides counters to signed and unsigned ones(increase only).
>  - makes unsigned one to be 'unsigned long' rather than 'u64'
> and
>  - then next patch will make 'signed' part to be 'long'
> ==
> for changelog ?
>
> Thanks,
> -Kame

Thanks for the review.

I will resent patches with the enhanced description.
