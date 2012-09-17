Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105Ab2IQKjX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 06:39:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2342 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753294Ab2IQKjW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 06:39:22 -0400
Message-ID: <5056FDD2.2080906@redhat.com>
Date: Mon, 17 Sep 2012 11:39:14 +0100
From: Pedro Alves <palves@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Roland McGrath <roland@hack.frob.com>
CC: Oleg Nesterov <oleg@redhat.com>, Denys Vlasenko <vda.linux@googlemail.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Amerigo Wang <amwang@redhat.com>
Subject: Re: [PATCH 2/2] coredump: add a new elf note with siginfo fields
 of the signal
References: <1347493124-10661-1-git-send-email-vda.linux@googlemail.com> <1347493124-10661-2-git-send-email-vda.linux@googlemail.com> <20120913153615.GB32128@redhat.com> <20120913155259.GA2267@redhat.com> <20120913172511.A69262C09C@topped-with-meat.com>
In-Reply-To: <20120913172511.A69262C09C@topped-with-meat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2012 06:25 PM, Roland McGrath wrote:
> I agree with Oleg.  If there is an NT_SIGINFO note, it should contain
> exactly the siginfo_t layout and data that we otherwise expose to userland
> already.  That is, it must match what PTRACE_GETSIGINFO reports, which (I
> think) also matches exactly what appears on the stack for a signal
> delivery.  

Agreed.  Please.  One note though:

PTRACE_GETSIGINFO always returns the siginfo_t in the architecture/bitness
of the kernel.  IOW, PTRACE_GETSIGINFO on a 32-bit debuggee, running on a
64-bit kernel, returns the siginfo_t in 64-bit layout.  IOW, copy_siginfo_to_user32
doesn't apply).  Or maybe that's the architecture of the tracer, instead of the kernel.
Haven't really checked.  In any case, GDB has to basically duplicate the kernel's
copy_siginfo_to_user/from_user for each supported arch (that does biarch) because
of this, for "(gdb) print $_siginfo".
I wish we had a PTRACE_GETSIGINFO variant that returned the siginfo_t in
layout of the program, not the kernel's..

> Note also that compat_binfmt_elf must deliver the 32-bit version
> of siginfo_t, i.e. as copy_siginfo_to_user32 does.

-- 
Pedro Alves

