Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935151Ab1ETQY6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 12:24:58 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:35911 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934561Ab1ETQY4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 12:24:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wXnwGSvmYpxuh4lxtcVpMypIAbr3C2/3CIlMaGpxDxTLu3Wcntg3fJxipKdtg5SPW2
         XVbf6BXvwMn3GdEoE/jMd2QJu5mI2EdPwFXzhleFyAD+w+D/w7ZAMoUj3cWPJEt4k2p/
         zFS8Lc5IFCH7mBV6URhvfgU0vNKonfaukzMg4=
MIME-Version: 1.0
In-Reply-To: <201105201042.15410.toralf.foerster@gmx.de>
References: <201105191526.31904.toralf.foerster@gmx.de>
	<201105200937.15322.toralf.foerster@gmx.de>
	<BANLkTik0oz6ppJvRpufaaiBL1pqcAxNHuA@mail.gmail.com>
	<201105201042.15410.toralf.foerster@gmx.de>
Date: Fri, 20 May 2011 18:24:56 +0200
Message-ID: <BANLkTikfaKJfnDwQoFi9WLX6q+2HHe90HQ@mail.gmail.com>
Subject: Re: kernel 2.6.39 (user mode linux) crashes (2.6.38 works fine)
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: =?ISO-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        user-mode-linux-devel@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/20 Toralf Förster <toralf.foerster@gmx.de>:
>
> richard -rw- weinberger wrote at 09:56:02
>> 2011/5/20 Toralf Förster <toralf.foerster@gmx.de>:
>> > ...
>> > Kernel panic - not syncing: Kernel mode fault at addr 0x0, ip 0x80a9f6b
>>
>> Looks like a NULL-pointer bug.
>> What code is at address 80a9f6b?
>> Use "objdump -d -S | less" to find it.
>        if (unlikely(ret != 0))
>  80a9f3a:       85 c0                   test   %eax,%eax
>  80a9f3c:       75 ca                   jne    80a9f08 <futex_wake+0x18>
>                goto out;
>
>        hb = hash_futex(&key);
>  80a9f3e:       8d 45 e8                lea    -0x18(%ebp),%eax
>  80a9f41:       e8 aa f6 ff ff          call   80a95f0 <hash_futex>
>  80a9f46:       89 c2                   mov    %eax,%edx
>        spin_lock(&hb->lock);
>        head = &hb->chain;
>
>        plist_for_each_entry_safe(this, next, head, list) {
>  80a9f48:       8b 48 08                mov    0x8(%eax),%ecx
>  80a9f4b:       83 c2 08                add    $0x8,%edx
>  80a9f4e:       8d 41 f4                lea    -0xc(%ecx),%eax
>  80a9f51:       39 ca                   cmp    %ecx,%edx
>  80a9f53:       8b 70 0c                mov    0xc(%eax),%esi
>  80a9f56:       74 6a                   je     80a9fc2 <futex_wake+0xd2>
>  80a9f58:       89 d9                   mov    %ebx,%ecx
>  80a9f5a:       83 ee 0c                sub    $0xc,%esi
>  80a9f5d:       89 d3                   mov    %edx,%ebx
>  80a9f5f:       89 fa                   mov    %edi,%edx
>  80a9f61:       89 cf                   mov    %ecx,%edi
>  80a9f63:       eb 12                   jmp    80a9f77 <futex_wake+0x87>
>  80a9f65:       8d 76 00                lea    0x0(%esi),%esi
>  80a9f68:       8d 46 0c                lea    0xc(%esi),%eax
>  80a9f6b:       8b 4e 0c                mov    0xc(%esi),%ecx


Here in futex_wake() happens a NULL pointer dereference.
Steve, any ideas?

-- 
Thanks,
//richard
