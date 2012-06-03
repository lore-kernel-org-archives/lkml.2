Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000Ab2FCXH6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 19:07:58 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:46526 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130Ab2FCXH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 19:07:57 -0400
MIME-Version: 1.0
In-Reply-To: <20120603223617.GB7707@redhat.com>
References: <20120603223617.GB7707@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 3 Jun 2012 16:07:35 -0700
X-Google-Sender-Auth: Icpva8dee3DLkuQV9z12-taxYlE
Message-ID: <CA+55aFwCusEdMq3_3TAXSZ=+kbN7H6AbnngVaagAZw=ZpicckQ@mail.gmail.com>
Subject: Re: processes hung after sys_renameat, and 'missing' processes
To: Dave Jones <davej@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 3, 2012 at 3:36 PM, Dave Jones <davej@redhat.com> wrote:
>
> It's still up and in this state if you want me to gather any further info
> before I reboot it.

You seem to have lockdep enabled, since I see the lock information,
but presumably you didn't get a lockdep splat before this?

Also, sysrq-w is usually way more interesting than 't' when there are
processes stuck on a mutex.

Because yes, it looks like you have a boattload of trinity processes
stuck on an inode mutex. Looks like every single one of them is in
'lock_rename()'. It *shouldn't* be an ABBA deadlock, since lockdep
should have noticed that, but who knows.

It looks like the lock information is somewhat truncated. I suspect
the dmesg buffer had filled up with all the task data.

Can you do just "sysrq-d" for the lock information (and maybe
separately "sysrq-w" for the blocked tasks)? The non-truncated lock
data might tell us more.

               Linus
