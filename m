Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757041Ab0CaCyl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 22:54:41 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:65237 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756383Ab0CaCyj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 22:54:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fMR78S1/ZhmmfkCQYry6NKd391qLF7HFgLppRKla+hZ7qeonlv0/pjeVMuOfXjT89i
         QMj4O06P6u9NkSzHFPMMFaxo3RiFMVaLgdiIU8z6jfY0wrdhyviRLqt00ZtoRsGdyFzK
         pjB+7OsszX69op9xnsE1V9k5TjPokhcRI0R2g=
MIME-Version: 1.0
In-Reply-To: <20100331111202.a94b233a.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100316170808.GA29400@redhat.com>
	 <20100330135634.09e6b045.akpm@linux-foundation.org>
	 <20100331092815.c8b9d89c.kamezawa.hiroyu@jp.fujitsu.com>
	 <20100330173721.cbd442cb.akpm@linux-foundation.org>
	 <20100331094124.43c49290.kamezawa.hiroyu@jp.fujitsu.com>
	 <z2t28c262361003301857l77db88dbv7d025b5c5947ad72@mail.gmail.com>
	 <20100331111202.a94b233a.kamezawa.hiroyu@jp.fujitsu.com>
Date: Wed, 31 Mar 2010 11:48:20 +0900
Message-ID: <z2z28c262361003301948h64378b8bkbbd29ed810862ce5@mail.gmail.com>
Subject: Re: [PATCH] exit: fix oops in sync_mm_rss
From: Minchan Kim <minchan.kim@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Michael S. Tsirkin" <mst@redhat.com>, cl@linux-foundation.org,
       lee.schermerhorn@hp.com, rientjes@google.com,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
       "David S. Miller" <davem@davemloft.net>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Troels Liebe Bentsen <tlb@rapanden.dk>,
       linux-bluetooth@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 31, 2010 at 11:12 AM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Wed, 31 Mar 2010 10:57:18 +0900
> Minchan Kim <minchan.kim@gmail.com> wrote:
>
>> On Wed, Mar 31, 2010 at 9:41 AM, KAMEZAWA Hiroyuki
>
>> > Doesn't make sense ?
>> >
>>
>> Nitpick.
>> How about moving sync_mm_rss into after check !mm of exit_mm?
>>
> Hmm.
> ==
>        sync_mm_rss(tsk, tsk->mm);
>        group_dead = atomic_dec_and_test(&tsk->signal->live);
>        if (group_dead) {
>                hrtimer_cancel(&tsk->signal->real_timer);
>                exit_itimers(tsk->signal);
>                if (tsk->mm)
>                        setmax_mm_hiwater_rss(&tsk->signal->maxrss, tsk->mm); ---(**)
>        }
>        acct_collect(code, group_dead);
>        if (group_dead)
>                tty_audit_exit();
>        if (unlikely(tsk->audit_context))
>                audit_free(tsk);
>
>        tsk->exit_code = code;
>        taskstats_exit(tsk, group_dead); --------(*)
>
>        exit_mm(tsk);
> ==
> task_acct routine has to handle mm information (*).

Indeed. I missed that.
Thanks, Kame.


-- 
Kind regards,
Minchan Kim
