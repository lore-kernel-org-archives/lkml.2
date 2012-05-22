Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932682Ab2EVVR2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 17:17:28 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:55560 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932438Ab2EVVRY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 17:17:24 -0400
MIME-Version: 1.0
In-Reply-To: <20120522210704.GK11775@ZenIV.linux.org.uk>
References: <CACLa4puRJLUd6hAHO6zFYiqa5dFVum8eLmNMk_ef+=r8OGhjRg@mail.gmail.com>
 <CAB=4xho2b5fZV_jC15XW3mhOD9Z0QUMnV_UHy-P5EmQWfX59dA@mail.gmail.com>
 <5d6179f59222155b72d9aa9f171e883c.squirrel@webmail.greenhost.nl>
 <CABqD9hbzatHerMA1Nq57Qn8SKSZzZf=5t6aLumG9ZpAafgX=UQ@mail.gmail.com>
 <20120522173942.GJ11775@ZenIV.linux.org.uk> <CABqD9hbwnp-Kob0-Uc9L=qgJfS88po=RHNPkhQFcSf4RTrFCmQ@mail.gmail.com>
 <4FBBF84A.4070308@zytor.com> <CABqD9haSh=Tof9n2m8PHBaoqac1kcUZq-f5BcjDBv++5APGTCg@mail.gmail.com>
 <20120522210704.GK11775@ZenIV.linux.org.uk>
From: Roland McGrath <mcgrathr@google.com>
Date: Tue, 22 May 2012 14:17:03 -0700
Message-ID: <CAB=4xhrEhX9BX2bsn1P=dFhmXTafVuEXDKJb87a6ftDkJqJs7A@mail.gmail.com>
Subject: Re: seccomp and ptrace. what is the correct order?
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Will Drewry <wad@chromium.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Indan Zupancic <indan@nul.nu>, Eric Paris <netdev@parisplace.org>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        kernel-hardening@lists.openwall.com, mingo@redhat.com, oleg@redhat.com,
        peterz@infradead.org, rdunlap@xenotime.net, tglx@linutronix.de,
        luto@mit.edu, eparis@redhat.com, serge.hallyn@canonical.com,
        pmoore@redhat.com, akpm@linux-foundation.org, corbet@lwn.net,
        eric.dumazet@gmail.com, markus@chromium.org, coreyb@linux.vnet.ibm.com,
        keescook@chromium.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2012 at 2:07 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> FWIW, I'd prefer to have all that done inside __audit_syscall_entry(),
> with
>        context->arch       = syscall_get_arch(current, regs);
>        context->major      = syscall_get_nr(current, regs);
>        syscall_get_arguments(current, regs, 0, 4, context->argv);
> done instead of initializations from arguments we are doing there now.
> I seriously doubt that it would lead to worse code than what we currently
> have.  If nothing else, we won't be passing that pile of arguments around.

I always felt the same way about the audit code.  (As a bonus, if the audit
folks ever decide they want all six syscall arguments instead of just four,
they wouldn't have to touch every arch.)  But it will certainly produce
drastically worse code for ia64.  (Not that anybody cares about ia64.)


Thanks,
Roland
