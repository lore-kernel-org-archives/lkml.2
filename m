Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752242Ab2AYUWO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 15:22:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:65337 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101Ab2AYUWM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 15:22:12 -0500
Message-ID: <4F206420.5080200@redhat.com>
Date: Wed, 25 Jan 2012 20:20:48 +0000
From: Pedro Alves <palves@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Indan Zupancic <indan@nul.nu>, Andi Kleen <andi@firstfloor.org>,
        Jamie Lokier <jamie@shareable.org>, Andrew Lutomirski <luto@mit.edu>,
        Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
        keescook@chromium.org, john.johansen@canonical.com,
        serge.hallyn@canonical.com, coreyb@linux.vnet.ibm.com,
        pmoore@redhat.com, eparis@redhat.com, djm@mindrot.org,
        segoon@openwall.com, rostedt@goodmis.org, jmorris@namei.org,
        scarybeasts@gmail.com, avi@redhat.com, penberg@cs.helsinki.fi,
        viro@zeniv.linux.org.uk, mingo@elte.hu, akpm@linux-foundation.org,
        khilman@ti.com, borislav.petkov@amd.com, amwang@redhat.com,
        ak@linux.intel.com, eric.dumazet@gmail.com, gregkh@suse.de,
        dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com,
        Roland McGrath <mcgrathr@chromium.org>,
        Denys Vlasenko <vda.linux@googlemail.com>
Subject: Re: Compat 32-bit syscall entry from 64-bit task!?
References: <CAObL_7EA-Z8yBbr1+-VW0v8k1okdcMfjRe5LgWo8YL5uvOkXbQ@mail.gmail.com> <49017bd7edab7010cd9ac767e39d99e4.squirrel@webmail.greenhost.nl> <20120118015013.GR11715@one.firstfloor.org> <20120118020453.GL7180@jl-vm1.vm.bytemark.co.uk> <20120118022217.GS11715@one.firstfloor.org> <fc8f165e541482d136ff8fc115fe6875.squirrel@webmail.greenhost.nl> <CA+55aFysH3h8sLHwNcaLnYMsgA28vmHgd3DSLPVw-=TzgfBrbg@mail.gmail.com> <CA+55aFzk6OOHoQ_e3pPQNUGN80tjXT7vYTNaRjXbWiQUnNRiTA@mail.gmail.com> <fd4ccb42a25876131e411299d24d9151.squirrel@webmail.greenhost.nl> <CA+55aFzcSVmdDj9Lh_gdbz1OzHyEm6ZrGPBDAJnywm2LF_eVyg@mail.gmail.com> <20120125193635.GA30311@redhat.com>
In-Reply-To: <20120125193635.GA30311@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/25/2012 07:36 PM, Oleg Nesterov wrote:
> 
> Not sure this is really better, but there is another idea. Currently we
> have PTRACE_O_TRACESYSGOOD to avoid the confusion with the real SIGTRAP.
> Perhaps we can add PTRACE_O_TRACESYS_VERY_GOOD (or we can look at
> PT_SEIZED instead) and report TS_COMPAT via ptrace_report_syscall ?

May I beg to don't rely on PTRACE_SYSCALL for anything new?
You can't PTRACE_SINGLESTEP and PTRACE_SYSCALL simultaneously.  Think of
gdb single-stepping all the way for some reason (software watchpoints, for ex.),
while at the same time wanting to catch syscalls.

As Roland suggested, replacing PTRACE_SYSCALL with PTRACE_O_TRACE_SYSCALL_{ENTRY,EXIT}
and PTRACE_EVENT_SYSCALL_{ENTRY,EXIT} would be superior, syscall tracing wise.

-- 
Pedro Alves
