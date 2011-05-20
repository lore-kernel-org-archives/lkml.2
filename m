Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935298Ab1ETIm0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 04:42:26 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:38418 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S934797Ab1ETImU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 04:42:20 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1+bwqps0UebLmMFBIAMqQ9HMaMbdNnPp7Fb3fgeG4
	yfn7PGy3HbaeN4
From: Toralf =?iso-8859-1?q?F=F6rster?= <toralf.foerster@gmx.de>
To: "richard -rw- weinberger" <richard.weinberger@gmail.com>
Subject: Re: kernel 2.6.39 (user mode linux) crashes (2.6.38 works fine)
Date: Fri, 20 May 2011 10:42:14 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.38.6; KDE/4.6.3; i686; ; )
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        user-mode-linux-devel@lists.sourceforge.net
References: <201105191526.31904.toralf.foerster@gmx.de> <201105200937.15322.toralf.foerster@gmx.de> <BANLkTik0oz6ppJvRpufaaiBL1pqcAxNHuA@mail.gmail.com>
In-Reply-To: <BANLkTik0oz6ppJvRpufaaiBL1pqcAxNHuA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201105201042.15410.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


richard -rw- weinberger wrote at 09:56:02
> 2011/5/20 Toralf Förster <toralf.foerster@gmx.de>:
> > ...
> > Kernel panic - not syncing: Kernel mode fault at addr 0x0, ip 0x80a9f6b
> 
> Looks like a NULL-pointer bug.
> What code is at address 80a9f6b?
> Use "objdump -d -S | less" to find it.
        if (unlikely(ret != 0))
 80a9f3a:       85 c0                   test   %eax,%eax
 80a9f3c:       75 ca                   jne    80a9f08 <futex_wake+0x18>
                goto out;

        hb = hash_futex(&key);
 80a9f3e:       8d 45 e8                lea    -0x18(%ebp),%eax
 80a9f41:       e8 aa f6 ff ff          call   80a95f0 <hash_futex>
 80a9f46:       89 c2                   mov    %eax,%edx
        spin_lock(&hb->lock);
        head = &hb->chain;

        plist_for_each_entry_safe(this, next, head, list) {
 80a9f48:       8b 48 08                mov    0x8(%eax),%ecx
 80a9f4b:       83 c2 08                add    $0x8,%edx
 80a9f4e:       8d 41 f4                lea    -0xc(%ecx),%eax
 80a9f51:       39 ca                   cmp    %ecx,%edx
 80a9f53:       8b 70 0c                mov    0xc(%eax),%esi
 80a9f56:       74 6a                   je     80a9fc2 <futex_wake+0xd2>
 80a9f58:       89 d9                   mov    %ebx,%ecx
 80a9f5a:       83 ee 0c                sub    $0xc,%esi
 80a9f5d:       89 d3                   mov    %edx,%ebx
 80a9f5f:       89 fa                   mov    %edi,%edx
 80a9f61:       89 cf                   mov    %ecx,%edi
 80a9f63:       eb 12                   jmp    80a9f77 <futex_wake+0x87>
 80a9f65:       8d 76 00                lea    0x0(%esi),%esi
 80a9f68:       8d 46 0c                lea    0xc(%esi),%eax
 80a9f6b:       8b 4e 0c                mov    0xc(%esi),%ecx
 80a9f6e:       39 c3                   cmp    %eax,%ebx
 80a9f70:       74 4e                   je     80a9fc0 <futex_wake+0xd0>
 80a9f72:       89 f0                   mov    %esi,%eax
 80a9f74:       8d 71 f4                lea    -0xc(%ecx),%esi
                if (match_futex (&this->key, &key)) {
 80a9f77:       83 f8 e4                cmp    $0xffffffe4,%eax
 80a9f7a:       74 ec                   je     80a9f68 <futex_wake+0x78>
 80a9f7c:       8b 48 1c                mov    0x1c(%eax),%ecx
 80a9f7f:       3b 4d e8                cmp    -0x18(%ebp),%ecx
 80a9f82:       75 e4                   jne    80a9f68 <futex_wake+0x78>
/*
 * Return 1 if two futex_keys are equal, 0 otherwise.
 */

> Is this really 2.6.39?
No, but I didn't want to change the subject line, the bisected version is :
v2.6.38-rc8-1-g2e12978


-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
