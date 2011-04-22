Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039Ab1DVI7q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 04:59:46 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:61103 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718Ab1DVI7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 04:59:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=wUjxrzN/97FQZxHH5oQeTHxjSOcRJcN6KJV7wGAEG+nw2AgJIWbe5vgNckWWsShOp/
         36AMQxtmpxdlsYqb4RFOyKJiNnV59TIIGKWLCcRomCaV8d1RA4PHwbJKWoYQhO+aYGba
         1fedByP40pMyYdSP88AD9ywCSsG0qRN+2vNcU=
MIME-Version: 1.0
In-Reply-To: <201104220831.p3M8VgAO017323@www262.sakura.ne.jp>
References: <20110417094505.865828233@chello.nl>
	<201104180341.p3I3fnxc000638@www262.sakura.ne.jp>
	<BANLkTikYwWe6E6mb3PLE3L7a3VHWdtEvfQ@mail.gmail.com>
	<201104220744.p3M7indA004922@www262.sakura.ne.jp>
	<BANLkTikXSz-AK6BFvnDGEr6Qhx-dekzOQg@mail.gmail.com>
	<201104220831.p3M8VgAO017323@www262.sakura.ne.jp>
Date: Fri, 22 Apr 2011 16:59:42 +0800
Message-ID: <BANLkTikaU-2g-p676+a6aMdk+CPdSBQE1g@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/7] lockdep: Support recurise-read locks
From: Yong Zhang <yong.zhang0@gmail.com>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: a.p.zijlstra@chello.nl, rostedt@goodmis.org, tglx@linutronix.de,
        mingo@elte.hu, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/22 Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>:
>> But if you call locktest1/locktest2 firstly, the chain will not be established
>> just because recursive read is not added to prev->after.
>
> This part is not OK. At least, I think lockdep should be able to establish the
> chain when locktest1 is called AGAIN after locktest2 is called (i.e.
> "cat /proc/locktest1 /proc/locktest2 /proc/locktest1" case).

I guess lockdep will warn on "cat /proc/locktest1 /proc/locktest2
/proc/locktest1"

> But lockdep can
> establish the chain for only "cat /proc/locktest2 /proc/locktest1" case.
> I think there is a bug that prevents the lockdep from establishing the chain
> when locktest1 is called AGAIN after locktest2 is called.

If we want to fully support recursive read validation, it's a bug; but that
also mean some head-burning work :)

> If we can't fix the
> bug, we should consider periodically (or upon printing stall warning messages)
> revalidating already established chains.

I don't think periodically revalidating make sense; because lockdep do
validate everything real-time.

Thanks,
Yong



-- 
Only stand for myself
