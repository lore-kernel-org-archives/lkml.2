Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752403Ab1A0Gzd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 01:55:33 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56746 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164Ab1A0Gzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 01:55:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=uAX0cTYyxSHplPT/yK/xno7YIi+lLHBhKFauwUXd6U6k3ULBQ3P5GHpm3lakggCT3W
         u9erIhY7WURzGdrSUp/mT8szMaRcadtHUIEzYBPPT5kEyisO8xpLbSYIrnTaar8cAuX3
         TV+Hb1PhzwmisDHzzVDkQQqfl2cCj73c6cgoo=
MIME-Version: 1.0
In-Reply-To: <1296072183.15234.12.camel@laptop>
References: <tip-18a57c3b43781ea83c3bb21c3add84ba890d5fb3@git.kernel.org>
	<20110126122900.GA8387@zhy>
	<1296072183.15234.12.camel@laptop>
Date: Thu, 27 Jan 2011 14:55:30 +0800
Message-ID: <AANLkTinM8oeCSxRfj=WQPc1-6W05O0XmvDK0Hde6zckL@mail.gmail.com>
Subject: Re: [tip:sched/core] sched: Untangle cpu-load and timekeeping code
From: Yong Zhang <yong.zhang0@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@elte.hu, linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 27, 2011 at 4:03 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>> We should not do this checking any more. In normal case,
>> it will always return false.
>> If it indeed returns true for some reason, we will lose the
>> timer forever.
>
> Its needed for the nohz case, arguably we could move it inside
> calc_global_nohz().

I have no idea why we need that checking in  calc_global_nohz().

Before this patch, time_before(jiffies, calc_load_update) is
needed in calc_global_nohz() because it will reduce the ovehead
on dealing with calc_load_fold_idle if we have idle dance in one
LOAD_FREQ.

Now we have calc_global_load() called at every LOAD_FREQ
instead of every tick, that problem is gone.

But maybe I have missed something ;)

Thanks,
Yong


-- 
Only stand for myself
