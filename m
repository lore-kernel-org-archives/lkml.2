Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121Ab0KGIEp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 03:04:45 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:51998 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470Ab0KGIEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 03:04:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:from:date:message-id:subject:to:cc
         :content-type;
        b=T+sft7hxHmvRsvGRB4BT0b2cvzs+u3US8l3HYhQYAtK4OUxnWCcIPqMXKiZbS2VtdQ
         R86bs5VwctvAB0ICbkEH8E1OQFm4CaqoRdFa3uodTpwc1eTkwNoum/BrfqAp9YfHfax1
         +98ifVPk2InhvQ4kTZu0YMrpIQ5bc8JgUZHa0=
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
From: Michael Kerrisk <mtk.manpages@gmail.com>
Date: Sun, 7 Nov 2010 09:04:22 +0100
Message-ID: <AANLkTi=mM2GoL=+umHJ6dDCqa7dNmG3=ra8xDOW4QCEV@mail.gmail.com>
Subject: Inconsistent credential checking in prlimit() syscall
To: Neil Horman <nhorman@tuxdriver.com>, Jiri Slaby <jslaby@novell.com>
Cc: marcin.slusarz@gmail.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Morris <jmorris@namei.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Michael Kerrisk <mtk.manpages@googlemail.com>,
        Linux API <linux-api@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Neil, Jiri,

I  started documenting the prlimit() system call added in 2.6.36, and
found the permission checks to be rather inconsistent with any other
kernel-userspace API. They are:

CAP_SYS_RESOURCE ||
(c-uid == t-uid && c0uid == t-euid && c-uid == t-suid) &&
(c-gid == t-gid && c-gid == t-guid && c-gid == t-sgid)

(uid == real UID; euid == effective UID; suid == save set-user-ID; and
analogously for GIDs; c- == caller's ID, and t- == target process's
ID)

In other words, for an unprivileged user, all UIDs of the target
process must match the calling process's real UID *and* all GIDs of
the target process must match the calling process's real GID.

What is the reason that the checks for prlimit() aren't similar to say
setpriority(), whose checks are the much simpler, and make no mention
of GIDs:

c-euid == t-uid || c-euid == t-euid

?

Thanks,

Michael

PS see also http://linux-man-pages.blogspot.com/2010/11/system-call-credential-checking-tale-of.html

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
