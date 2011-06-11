Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758451Ab1FKAqm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 20:46:42 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61917 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758354Ab1FKAql convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 20:46:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SjC2HZJcBVPCCM2BJe00JBU8DAD9tKkCxbUU3sTcO9SWIBbsYqRYVdQ+Wnohu8v5Gg
         jxdbLpbOeHxk97zkTtTstUGxMhqUJLr4KgnyncEZvE8BcphcstoCajPE+yZP7FB/bnwJ
         MZFjL2aIaOn7bUpgRhYb9JkYyNOpxKoSiFHcY=
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.00.1106101425400.28334@sister.anvils>
References: <20110609212956.GA2319@redhat.com>
	<BANLkTikCfWhoLNK__ringzy7KjKY5ZEtNb3QTuX1jJ53wNNysA@mail.gmail.com>
	<BANLkTikF7=qfXAmrNzyMSmWm7Neh6yMAB8EbBp7oLcfQmrbDjA@mail.gmail.com>
	<20110610091355.2ce38798.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.LSU.2.00.1106091812030.4904@sister.anvils>
	<20110610113311.409bb423.kamezawa.hiroyu@jp.fujitsu.com>
	<20110610121949.622e4629.kamezawa.hiroyu@jp.fujitsu.com>
	<20110610125551.385ea7ed.kamezawa.hiroyu@jp.fujitsu.com>
	<20110610133021.2eaaf0da.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.LSU.2.00.1106101425400.28334@sister.anvils>
Date: Sat, 11 Jun 2011 09:46:40 +0900
Message-ID: <BANLkTi=bBSeMFtUDyz+px1Kt34HDU=DEcw@mail.gmail.com>
Subject: Re: [PATCH] [BUGFIX] update mm->owner even if no next owner.
From: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
To: Hugh Dickins <hughd@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Ying Han <yinghan@google.com>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Oleg Nesterov <oleg@redhat.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/6/11 Hugh Dickins <hughd@google.com>:
> On Fri, 10 Jun 2011, KAMEZAWA Hiroyuki wrote:
>>
>> I think this can be a fix.
>
> Sorry, I think not: I've not digested your rationale,
> but three things stand out:
>
> 1. Why has this only just started happening?  I may not have run that
>   test on 3.0-rc1, but surely I ran it for hours with 2.6.39;
>   maybe not with khugepaged, but certainly with ksmd.
>
Not sure. I pointed this just by review because I found "charge" in
khugepaged is out of mmap_sem now.

> 2. Your hunk below:
>> -     if (!mm_need_new_owner(mm, p))
>> +     if (!mm_need_new_owner(mm, p)) {
>> +             rcu_assign_pointer(mm->owner, NULL);
>   is now setting mm->owner to NULL at times when we were sure it did not
>   need updating before (task is not the owner): you're damaging mm->owner.
>
Ah, yes. It's my mistake.

> 3. There's a patch from Andrea in 3.0-rc1 which looks very likely to be
>   relevant, 692e0b35427a "mm: thp: optimize memcg charge in khugepaged".
>   I'll try reproducing without that tonight (I crashed in 20 minutes
>   this morning, so it's not too hard).
>

Thanks,
-Kame
