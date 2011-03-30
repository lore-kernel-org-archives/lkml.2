Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932524Ab1C3PEI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 11:04:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38661 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754710Ab1C3PEG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 11:04:06 -0400
Message-ID: <4D934648.7040500@kernel.org>
Date: Wed, 30 Mar 2011 08:03:36 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Andy Lutomirski <luto@mit.edu>
CC: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86-64: Clean up vdso/kernel shared variables
References: <c79ac2a9a1caad9865ffa3c4a05438227c59f63e.1301408701.git.luto@mit.edu>
In-Reply-To: <c79ac2a9a1caad9865ffa3c4a05438227c59f63e.1301408701.git.luto@mit.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2011 07:29 AM, Andy Lutomirski wrote:
> Variables that are shared between the vdso and the kernel are
> currently a bit of a mess.  They are each defined with their own
> magic, they are accessed differently in the kernel, the vsyscall page,
> and the vdso, and one of them (vsyscall_clock) doesn't even really
> exist.
> 
> This changes them all to use a common mechanism.  All of them are
> delcared in vvar.h with a fixed address (validated by the linker
> script).  In the kernel (as before), they look like ordinary
> read-write variables.  In the vsyscall page and the vdso, they are
> accessed through a new macro VVAR, which gives read-only access.
> 
> The vdso is now loaded verbatim into memory without any fixups.  As a
> side bonus, access from the vdso is faster because a level of
> indirection is removed.
> 
> Signed-off-by: Andy Lutomirski <luto@mit.edu>

How does this deal with variables which really should be shared with
multiple vdsos (in particular the 32-bit vdso and the 64-bit vdso)?
Part of me is wondering if it might not be simpler to put them all into
a structure?

	-hpa
