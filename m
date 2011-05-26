Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758349Ab1EZSuG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 14:50:06 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:60023 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755440Ab1EZSuE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 14:50:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fDCuN3n5pL/AIfXD584rG0w+5ppwwlQLTbzRnU3IpscQuWKo+gzz7IlsCOOSwObB09
         JFkmmiyPtI1ClcQ59z7Tg/rtu9xdEb24zxDzKOlDWdBuBM/7K2UhyJxLsZlr5+VyXI/U
         Z7b2LP1IyxFoFr8Rfev4En/9wFV6vFZivKwgM=
MIME-Version: 1.0
In-Reply-To: <BANLkTi=znC18PAbpDfeVO+=Pat_EeXddjw@mail.gmail.com>
References: <4DDE2873.7060409@jp.fujitsu.com>
	<BANLkTi=znC18PAbpDfeVO+=Pat_EeXddjw@mail.gmail.com>
Date: Thu, 26 May 2011 20:50:02 +0200
Message-ID: <BANLkTikgXhmgzQYfSWKDoxVyNuCzSM7Qxw@mail.gmail.com>
Subject: Re: [PATCH] mm: don't access vm_flags as 'int'
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, benh@kernel.crashing.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org, hughd@google.com,
        akpm@linux-foundation.org, dave@linux.vnet.ibm.com,
        kamezawa.hiroyu@jp.fujitsu.com
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26, 2011 at 7:53 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> 2011/5/26 KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>:
>> The type of vma->vm_flags is 'unsigned long'. Neither 'int' nor
>> 'unsigned int'. This patch fixes such misuse.
>
> I applied this, except I also just made the executive decision to
> replace things with "vm_flags_t" after all.
>
> Which leaves a lot of "unsigned long" users that aren't converted, but
> right now it doesn't matter, and it can be converted piecemeal as
> people notice users..
>

This breaks kernel builds with CONFIG_HUGETLBFS=n. :-(

In file included from fs/proc/meminfo.c:2:0:
include/linux/hugetlb.h:195:3: error: expected declaration specifiers
or ‘...’ before ‘vm_flags_t’
  CC      drivers/ata/libata-pmp.o
make[2]: *** [fs/proc/meminfo.o] Fehler 1
make[1]: *** [fs/proc] Fehler 2
make: *** [fs] Fehler 2
make: *** Warte auf noch nicht beendete Prozesse...


-- 
Thanks,
//richard
