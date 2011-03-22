Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901Ab1CVXVR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 19:21:17 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42660 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755838Ab1CVXVO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 19:21:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nolxyZgy+pBqXnRMQyugFNluSZgkdxg1JdIvpMLuvVFerzfjubAZG7QKRjRfk4tc+W
         yv22gc+/v8tcH3wgVxKocX9malZEvKWt8cUd5AJ9/dzMeAUy8Vzp9QReTbRuZksPdvbd
         +KapxfUazc2M4vpyk80wz80z9QLTaLqcSkkPE=
MIME-Version: 1.0
In-Reply-To: <20110322200759.B067.A69D9226@jp.fujitsu.com>
References: <20110315153801.3526.A69D9226@jp.fujitsu.com>
	<20110322194721.B05E.A69D9226@jp.fujitsu.com>
	<20110322200759.B067.A69D9226@jp.fujitsu.com>
Date: Wed, 23 Mar 2011 08:21:12 +0900
Message-ID: <AANLkTikN835dfU9xozTWbOh6cjSEG0XgU_Ayn+dRqDug@mail.gmail.com>
Subject: Re: [PATCH 3/5] oom: create oom autogroup
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-mm <linux-mm@kvack.org>, Andrey Vagin <avagin@openvz.org>,
        Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mike Galbraith <efault@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 8:08 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
> When plenty processes (eg fork bomb) are running, the TIF_MEMDIE task
> never exit, at least, human feel it's never. therefore kernel become
> hang-up.
>
> "perf sched" tell us a hint.
>
>  ------------------------------------------------------------------------------
>  Task                  |   Runtime ms  | Average delay ms | Maximum delay ms |
>  ------------------------------------------------------------------------------
>  python:1754           |      0.197 ms | avg: 1731.727 ms | max: 3433.805 ms |
>  python:1843           |      0.489 ms | avg: 1707.433 ms | max: 3622.955 ms |
>  python:1715           |      0.220 ms | avg: 1707.125 ms | max: 3623.246 ms |
>  python:1818           |      2.127 ms | avg: 1527.331 ms | max: 3622.553 ms |
>  ...
>  ...
>
> Processes flood makes crazy scheduler delay. and then the victim process
> can't run enough. Grr. Should we do?
>
> Fortunately, we already have anti process flood framework, autogroup!
> This patch reuse this framework and avoid kernel live lock.

That's cool idea but I have a concern.

You remove boosting priority in [2/5] and move victim tasks into autogroup.
If I understand autogroup right, victim process and threads in the
process take less schedule chance than now.

Could it make unnecessary killing of other tasks?
I am not sure. Just out of curiosity.

Thanks for nice work, Kosaki.
-- 
Kind regards,
Minchan Kim
