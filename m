Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728Ab1FKXEY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jun 2011 19:04:24 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48425 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730Ab1FKXEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jun 2011 19:04:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=LAZabpksxnCy61LgSueBbFLvRPu6S9I7kcTONzPVvKsL33NJ/5mTLZT+kuV1vumewX
         78F1pQF2W1nLDLBEJCAQ82+3Kq7c7A8pXZJU6jLppJ0J80+jzaI8G8mmgHEzWI7CmU96
         0aZhGAU7uCkE56ytDFgXKZcR41LwqLoMFBk2k=
MIME-Version: 1.0
In-Reply-To: <20110611184416.GB3238@redhat.com>
References: <BANLkTikF7=qfXAmrNzyMSmWm7Neh6yMAB8EbBp7oLcfQmrbDjA@mail.gmail.com>
	<20110610091355.2ce38798.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.LSU.2.00.1106091812030.4904@sister.anvils>
	<20110610113311.409bb423.kamezawa.hiroyu@jp.fujitsu.com>
	<20110610121949.622e4629.kamezawa.hiroyu@jp.fujitsu.com>
	<20110610125551.385ea7ed.kamezawa.hiroyu@jp.fujitsu.com>
	<20110610133021.2eaaf0da.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.LSU.2.00.1106101425400.28334@sister.anvils>
	<20110610235442.GA21413@cmpxchg.org>
	<20110611175136.GA31154@cmpxchg.org>
	<20110611184416.GB3238@redhat.com>
Date: Sun, 12 Jun 2011 08:04:21 +0900
Message-ID: <BANLkTikJONQ2tL_L=QtMv9qsOmJj3dD+Rg@mail.gmail.com>
Subject: Re: [PATCH] [BUGFIX] update mm->owner even if no next owner.
From: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Ying Han <yinghan@google.com>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Oleg Nesterov <oleg@redhat.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/6/12 Andrea Arcangeli <aarcange@redhat.com>:
> On Sat, Jun 11, 2011 at 07:51:36PM +0200, Johannes Weiner wrote:
>> This is a problem with the patch, but I think Kame's analysis and
>> approach to fix it are still correct.
>
> I agree with Kame's analysis too. This explains why removing the
> mmap_sem read mode introduced the problem, it was quite some
> unexpected subtleness not apparent to the naked eye, as memcg didn't
> explicitly relay on mmap_sem but it did implicitly during exit because
> of the __khugepaged_exit waiting if we were collapsing an hugepage...
>
> So the fix is safe because the task struct is freed with
> delayed_put_task_struct and that won't run until we rcu_read_unlock
> after mem_cgroup_from_task.
>
> Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
>

Thank you all.

Regards,
-Kame
