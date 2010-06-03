Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932888Ab0FCGMN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 02:12:13 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:57157 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932651Ab0FCGMM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 02:12:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=h2xfW/5Y/SXYqPgs8cyuCdkeJvLIN7wsMa4xJwlDpFL1jWic/YI2qqUvssM0ay6/FZ
         z1eAERkbFBq2v6+OPIphdJ1A2Twlg8GWZYeO/dKbzI9jZQ5aogybQWfyMz+vnwjkFw2l
         B4dW5TDHD1tryepvf5gFjcI30c22TmjSLD5Fs=
MIME-Version: 1.0
In-Reply-To: <20100603144948.724D.A69D9226@jp.fujitsu.com>
References: <20100603135106.7247.A69D9226@jp.fujitsu.com>
	<20100603144948.724D.A69D9226@jp.fujitsu.com>
Date: Thu, 3 Jun 2010 15:12:10 +0900
Message-ID: <AANLkTikF0EAmKsBx28-paTg7DUdOiHLz5KHJbzLW_OBS@mail.gmail.com>
Subject: Re: [PATCH 02/12] oom: introduce find_lock_task_mm() to fix !mm false 
	positives
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Oleg Nesterov <oleg@redhat.com>, David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 3, 2010 at 2:50 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
> From: Oleg Nesterov <oleg@redhat.com>
>
> Almost all ->mm == NUL checks in oom_kill.c are wrong.
>
> The current code assumes that the task without ->mm has already
> released its memory and ignores the process. However this is not
> necessarily true when this process is multithreaded, other live
> sub-threads can use this ->mm.
>
> - Remove the "if (!p->mm)" check in select_bad_process(), it is
>  just wrong.
>
> - Add the new helper, find_lock_task_mm(), which finds the live
>  thread which uses the memory and takes task_lock() to pin ->mm
>
> - change oom_badness() to use this helper instead of just checking
>  ->mm != NULL.
>
> - As David pointed out, select_bad_process() must never choose the
>  task without ->mm, but no matter what badness() returns the
>  task can be chosen if nothing else has been found yet.
>
> Note! This patch is not enough, we need more changes.
>
>        - badness() was fixed, but oom_kill_task() still ignores
>          the task without ->mm
>
> This will be addressed later.
>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> Cc: David Rientjes <rientjes@google.com>
> Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Could you see my previous comment?
http://lkml.org/lkml/2010/6/2/325
Anyway, I added my review sign

Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
-- 
Kind regards,
Minchan Kim
