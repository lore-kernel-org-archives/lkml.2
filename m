Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015Ab1DKUPp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 16:15:45 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57750 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755946Ab1DKUPn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 16:15:43 -0400
MIME-Version: 1.0
In-Reply-To: <20110405163855.GC4183@core.coreip.homeip.net>
References: <1301727259-5185-1-git-send-email-jeffbrown@android.com>
 <1301727259-5185-4-git-send-email-jeffbrown@android.com> <20110404213659.GC984@core.coreip.homeip.net>
 <BANLkTi=0q6DbXki5RhE8eakermnVixN67g@mail.gmail.com> <20110404224611.GA2783@core.coreip.homeip.net>
 <BANLkTinLcXsZpHm3_uzRUEdrJQsbozgghA@mail.gmail.com> <20110405163855.GC4183@core.coreip.homeip.net>
From: Jeffrey Brown <jeffbrown@android.com>
Date: Mon, 11 Apr 2011 13:15:03 -0700
Message-ID: <BANLkTinw6poJOkFWaJp6paL6rDpwBG-9zA@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] input: evdev: Make device readable only when it
 contains a complete packet.
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: rydberg@euromail.se, djkurtz@google.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On Tue, Apr 5, 2011 at 9:38 AM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
>> Heh, I faced this very same dilemma.  I tried 'last_sync',
>> 'readable_tail', 'read_end', and others before settling on 'end' and a
>> descriptive comment.
>
> 'packet_head' maybe? Similar to the head but for whole event packet?

That sounds good.  It marks the position one past the end of the most
recent packet, or equivalently the beginning of the next packet (if
there is one).  :-)

> Before we started changing tail to advance to SYN_DROPPED position we
> could probably drop the buffer lock and sprinkle memory barriers (to
> ensure, for example, that buffer is written before advancing head).
>
> Now we do need to protect buffer and head/tail but the new field can be
> updated outside the lock.

That sounds kind of complicated.  Memory barriers and volatile
reads/writers aren't free.  Acquiring / releasing the lock already
performs the necessary memory barriers and keeps the code simple since
we can rely on mutual exclusion guarantees to preserve our invariants.
 I doubt the buffer lock is highly contended so although we could
probably do without it, I'm not sure it's worth the necessary
contortions.  *shrug*

Any further progress on this patch?

Thanks,
Jeff.
