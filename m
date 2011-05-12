Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756438Ab1ELBar (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 21:30:47 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:38723 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755607Ab1ELBaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 21:30:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=vqW8o+Lw7ld7aigT6DZTUWIuv5GOYQRCmrc0IsMq3qHZl4KJuuHfP9AQUCdrI72EbG
         O3tH9CRkYmNMK3iAvwAYINcAQBcszyRpUiK1TqfMq6ViGB0kTbGObmytlEJnJUSfvhQP
         SWrfWuOenxMUPE5ldbj7XIpcYJBCrawpmImFQ=
MIME-Version: 1.0
In-Reply-To: <20110512095243.c57e3e83.kamezawa.hiroyu@jp.fujitsu.com>
References: <20110509182110.167F.A69D9226@jp.fujitsu.com>
	<20110510171335.16A7.A69D9226@jp.fujitsu.com>
	<20110510171641.16AF.A69D9226@jp.fujitsu.com>
	<20110512095243.c57e3e83.kamezawa.hiroyu@jp.fujitsu.com>
Date: Thu, 12 May 2011 10:30:45 +0900
Message-ID: <BANLkTi=ya1rAqC+nMPHkBaMsoXpsCeHH=w@mail.gmail.com>
Subject: Re: [PATCH 2/4] oom: kill younger process first
From: Minchan Kim <minchan.kim@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        CAI Qian <caiqian@redhat.com>, avagin@gmail.com,
        Andrey Vagin <avagin@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        David Rientjes <rientjes@google.com>, Hugh Dickins <hughd@google.com>,
        Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kame,

On Thu, May 12, 2011 at 9:52 AM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Tue, 10 May 2011 17:15:01 +0900 (JST)
> KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
>
>> This patch introduces do_each_thread_reverse() and
>> select_bad_process() uses it. The benefits are two,
>> 1) oom-killer can kill younger process than older if
>> they have a same oom score. Usually younger process
>> is less important. 2) younger task often have PF_EXITING
>> because shell script makes a lot of short lived processes.
>> Reverse order search can detect it faster.
>>
>> Reported-by: CAI Qian <caiqian@redhat.com>
>> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>
> IIUC, for_each_thread() can be called under rcu_read_lock() but
> for_each_thread_reverse() must be under tasklist_lock.

Just out of curiosity.
You mentioned it when I sent forkbomb killer patch. :)
>From at that time, I can't understand why we need holding
tasklist_lock not rcu_read_lock. Sorry for the dumb question.

At present, it seems that someone uses tasklist_lock and others uses
rcu_read_lock. But I can't find any rule for that.

Could you elaborate it, please?
Doesn't it need document about it?

-- 
Kind regards,
Minchan Kim
