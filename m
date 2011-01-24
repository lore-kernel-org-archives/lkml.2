Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153Ab1AXDRh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 22:17:37 -0500
Received: from mail-yi0-f46.google.com ([209.85.218.46]:60110 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940Ab1AXDRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 22:17:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=VTQglSGt+nUnkvt1G5/yBB0i0DJA2XGChsEHlPF+61bfJNYPbhTcHKY0DHI0qZEELw
         ARULnmPXaB1+YAjhXeya+iigtwwB9gGTRCR9qOUxDJKxlolx5meucULdSoiFdxLIgnjf
         dySj++iEfnRMK1nL56MoDwqM8Tfr8nqCozo5s=
MIME-Version: 1.0
In-Reply-To: <AANLkTinShA64ZVH91Rt-jQuX86gKCaezFn_D_m+820We@mail.gmail.com>
References: <4d39ce58.cc7e0e0a.5448.59e4@mx.google.com>
	<alpine.DEB.2.01.1101230243370.7903@trent.utfs.org>
	<20110123145429.GA2523@zhy>
	<20110123150341.GA2643@zhy>
	<AANLkTinShA64ZVH91Rt-jQuX86gKCaezFn_D_m+820We@mail.gmail.com>
Date: Mon, 24 Jan 2011 11:17:34 +0800
Message-ID: <AANLkTimea-ZFP8UzPTHuu9pqghq4+NCP76KsPJMvpwRL@mail.gmail.com>
Subject: Re: [PATCH] sched: fix autogroup nice tune on UP
From: Yong Zhang <yong.zhang0@gmail.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Michael Witten <mfwitten@gmail.com>, linux-kernel@vger.kernel.org,
        Christian Kujau <christian@nerdbynature.de>,
        Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 23, 2011 at 11:16 PM, Pekka Enberg <penberg@kernel.org> wrote:
>> tg->se->load, the reason is update_cfs_shares()
>> do nothing on SMP.
>
> Typo here? You mean UP, right?

Ah, Yeah. Thanks for pointing it.



>
> I'm not an expert on the scheduler but this looks like the wrong thing
> to do. Shouldn't you fix update_cfs_shares() to work on UP properly?
>

I have through about that. No-poking on update_cfs_shares() is because
update_cfs_shares() is called at several hot path, like enqueue_entity()/
dequeue_entity(), but it doesn't make sense on UP.

But I guess you are right. We still need to update the load of cfs_rq
after update_load_set() is called even on UP, so
update_cfs_shares() is the suitable place to do that.

Will take another look at update_cfs_shares().

Thanks,
Yong

-- 
Only stand for myself
