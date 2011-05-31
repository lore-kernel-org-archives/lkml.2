Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757417Ab1EaD6m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 23:58:42 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:46730 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756334Ab1EaD6l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 23:58:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=k6G499ttWll16KBZ4VuXS7UYniumP7XtrA8piGqtFa5f0CjYOflNTZIEvBQpx3pJ4B
         +4/rytMg+JHkpPJKpOHIKllU/OJbNNkzyF7y6JVAsiFU7XVs+ucoHQ88dV5nV3dMlJgu
         XIVs/UOkCdn1rV7ugF86Wr7137RIvcMpl7zyw=
MIME-Version: 1.0
In-Reply-To: <20110531121815.67523361.kamezawa.hiroyu@jp.fujitsu.com>
References: <1306774744.4061.5.camel@localhost.localdomain>
	<20110531083859.98e4ff43.kamezawa.hiroyu@jp.fujitsu.com>
	<BANLkTinTqijGxCpZ_nRwWZHYsR-u2zojZA@mail.gmail.com>
	<20110531121815.67523361.kamezawa.hiroyu@jp.fujitsu.com>
Date: Tue, 31 May 2011 09:58:40 +0600
Message-ID: <BANLkTiksAjyCBAPdCB58tAWhXcdqXM4EcA@mail.gmail.com>
Subject: Re: [PATCH] mm, vmstat: Use cond_resched only when !CONFIG_PREEMPT
From: Rakib Mullick <rakib.mullick@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Christoph Lameter <cl@linux.com>,
        Mel Gorman <mel@csn.ul.ie>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 31, 2011 at 9:18 AM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Tue, 31 May 2011 09:13:47 +0600
> Rakib Mullick <rakib.mullick@gmail.com> wrote:
>
>> On Tue, May 31, 2011 at 5:38 AM, KAMEZAWA Hiroyuki
>> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>> > On Mon, 30 May 2011 22:59:04 +0600
>> > Rakib Mullick <rakib.mullick@gmail.com> wrote:
>> >
>> >> commit 468fd62ed9 (vmstats: add cond_resched() to refresh_cpu_vm_stats()) added cond_resched() in refresh_cpu_vm_stats. Purpose of that patch was to allow other threads to run in non-preemptive case. This patch, makes sure that cond_resched() gets called when !CONFIG_PREEMPT is set. In a preemptiable kernel we don't need to call cond_resched().
>> >>
>> >> Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
>> >
>> > Hmm, what benefit do we get by adding this extra #ifdef in the code directly ?
>> > Other cond_resched() callers are not guilty in !CONFIG_PREEMPT ?
>> >
>> Well, in preemptible kernel this context will get preempted if
>> requires, so we don't need cond_resched(). If you checkout the git log
>> of the mentioned commit, you'll find the explanation. It says:
>>         "Adding a cond_resched() to allow other threads to run in the
>> non-preemptive
>>     case."
>>
>
> IOW, my question is "why only this cond_resched() should be fixed ?"

cond_resched() forces this thread to be scheduled. I'm just trying
pointing out the use of cond_resched(), until unless I'm not missing
anything.

> What's bad with all cond_resched() in the kernel as no-op in CONFIG_PREEMPT ?
>
cond_resched() basically checks whether it needs to be scheduled or
not. But, we know in advance that we don't need cond_resched in
CONFIG_PREEMPT.

Thanks,
Rakib

> Thanks,
> -Kame
>
>
>
