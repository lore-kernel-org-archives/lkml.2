Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771Ab0FPOzi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 10:55:38 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:49424 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189Ab0FPOzg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 10:55:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=fBVIbrAzKZ5iMueQDv+LCXB6YS8va/c/89g6Em34ZgEglKPRpT8q7u20fgTNPISqX6
         xgy1UWz10xfKyqjyHUGwOFG+sICDD674ATMT2uh65ZK8YJ+YJ6gVSM1F8jV+Wz9G67Ua
         o8K8KbwB0vwhb659TuD5H/9/1K4Qqza4gKkgw=
MIME-Version: 1.0
In-Reply-To: <20100616143659.GA14616@elliptictech.com>
References: <E1OMQ88-0002a1-Gb@closure.thunk.org>
	<AANLkTilqc0jpwnIwe3OIQvB9avaXXzrBK4Hz0huESygy@mail.gmail.com>
	<20100613194949.GC8055@thunk.org>
	<AANLkTilQLk7ofSJBm9KIa2g1KQ35GC1D1vOZlPrv1VRv@mail.gmail.com>
	<20100614184244.GA11480@elliptictech.com>
	<20100614214646.GF6666@thunk.org>
	<AANLkTikxOwYQYSzNjEqRduTQvoUandnAsZzm5Auzgnaz@mail.gmail.com>
	<18402.1276625268@redhat.com>
	<AANLkTilZElLEBJDjfpZVx72uDR-x_3t14Jkga5eHy3wf@mail.gmail.com>
	<20100616143659.GA14616@elliptictech.com>
Date: Wed, 16 Jun 2010 15:55:30 +0100
X-Google-Sender-Auth: QrWqnS7T1BPG8aqsnfRc8diEQFU
Message-ID: <AANLkTikasMn4s1-VgQstblkfP1sy-grJC8NVEUwJ9qKF@mail.gmail.com>
Subject: Re: Why is kslowd accumulating so much CPU time?
From: Andy Whitcroft <apw@canonical.com>
To: Andy Whitcroft <apw@canonical.com>, David Howells <dhowells@redhat.com>,
       tytso@mit.edu, Dave Airlie <airlied@gmail.com>,
       Dave Airlie <airlied@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 16, 2010 at 3:36 PM, Nick Bowler <nbowler@elliptictech.com> wrote:
> On 12:37 Wed 16 Jun     , Andy Whitcroft wrote:
>> > Can you see what they're doing?
>> >
>> >        watch -n0 cat /sys/kernel/debug/slow_work/runqueue
>>
>> Turned on the debugging and applied the patch from Ted, and when
>> things are bad I see constant cycling of all four threads in the
>> output showing similar to the below, note only one thread shows at a
>> time:
>>
>> Every 0.1s: cat /sys/kernel/debug/slow_work/runqueue    Wed Jun 16 12:34:52 2010
>>
>> THR PID   ITEM ADDR        FL MARK  DESC
>> === ===== ================ == ===== ==========
>>    0   897 ffff88012bb07510 12  20ms DRM_CRTC_HELPER: i915@pci:0000:00:02.0
>
> Indeed, this looks very similar to mine, except my DESC field is blank
> for some reason.  The FL value is sometimes 12, sometimes 2.

DESC is only filled in if you have Ted's patch applied (earlier in this thread).

> When things are bad, all four of the kslowd threads are pegged at 16%
> CPU usage.  On my T500, they _never_ calm down once they're pegged.
> However, things seem to be working normally at boot.  It seems that
> there is some initial trigger which pegs the threads, then the cursor
> lag and other problems are just fallout after that.  The system is
> essentially unusable after this point.
>
> The threads sometimes get pegged immediately after booting the system,
> sometimes it can last an hour or more before showing any problems.
> Unfortunately, this is making bisection essentially impossible.
>
> This seems to have been introduced somewhere between 2.6.35-rc1 and

I suspect this is introduced by the commit which pulled polling of DRM
connectors into the core.

-apw
