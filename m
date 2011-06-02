Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217Ab1FBXAy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 19:00:54 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44943 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755142Ab1FBXAw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 19:00:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=VcBtJ9WPduOZDHMyAqr32JjmAv1OlOTIgklMh3h9hJlbkooPxhNm9qDR5muEl3q+OM
         FegCtQ6BWGDmfFQTfgEGmuOpiQvrUXp0+frScdMhiQaTfFHy16nahjS7WeKBLDLrOpdE
         J6//BQ2AjL5PlvbxxpWBnJPFxdcPfr+eFs7N4=
MIME-Version: 1.0
In-Reply-To: <201106030032.17398.richard@nod.at>
References: <20110602210458.23613.24076.stgit@paris.rdu.redhat.com>
	<201106030032.17398.richard@nod.at>
Date: Thu, 2 Jun 2011 16:00:51 -0700
X-Google-Sender-Auth: QgFvRW1CC8YA0kXbdN8JonScQAY
Message-ID: <BANLkTik9kCs_06=7HKo44cWqpS0zB9fr+A@mail.gmail.com>
Subject: Re: [PATCH] Audit: push audit success and retcode into arch ptrace.h
From: Tony Luck <tony.luck@intel.com>
To: Richard Weinberger <richard@nod.at>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, monstr@monstr.eu, ralf@linux-mips.org,
        benh@kernel.crashing.org, paulus@samba.org, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, linux390@de.ibm.com, lethal@linux-sh.org,
        davem@davemloft.net, jdike@addtoit.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        viro@zeniv.linux.org.uk, oleg@redhat.com, akpm@linux-foundation.org,
        linux-ia64@vger.kernel.org, microblaze-uclinux@itee.uq.edu.au,
        linux-mips@linux-mips.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
        sparclinux@vger.kernel.org,
        user-mode-linux-devel@lists.sourceforge.net
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> But there seems to be another problem.
> Why is pt_regs of type void *?
>
> gcc complains:
> In file included from include/linux/fsnotify.h:15:0,
>                 from include/linux/security.h:26,
>                 from init/main.c:32:
> include/linux/audit.h: In function ‘audit_syscall_exit’:
> include/linux/audit.h:440:17: warning: dereferencing ‘void *’ pointer
> include/linux/audit.h:440:3: error: invalid use of void expression
> include/linux/audit.h:441:21: warning: dereferencing ‘void *’ pointer
> include/linux/audit.h:441:21: error: void value not ignored as it ought to be

Perhaps same issue on ia64 - but symptoms are different:

  CC      crypto/cipher.o
In file included from include/linux/fsnotify.h:15,
                 from include/linux/security.h:26,
                 from init/do_mounts.c:8:
include/linux/audit.h: In function ‘audit_syscall_exit’:
include/linux/audit.h:440: warning: dereferencing ‘void *’ pointer
include/linux/audit.h:440: error: request for member ‘r10’ in
something not a structure or union
include/linux/audit.h:441: error: request for member ‘r10’ in
something not a structure or union
include/linux/audit.h:441: error: request for member ‘r8’ in something
not a structure or union
include/linux/audit.h:441: error: request for member ‘r8’ in something
not a structure or union
include/linux/audit.h:441: error: expected ‘;’ before ‘}’ token
include/linux/audit.h:441: error: void value not ignored as it ought to be

-Tony
