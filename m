Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113Ab1GUQH4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 12:07:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49742 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752756Ab1GUQHz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 12:07:55 -0400
Message-ID: <4E284EAB.1020906@zytor.com>
Date: Thu, 21 Jul 2011 09:07:07 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc15 Thunderbird/3.1.11
MIME-Version: 1.0
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, a.p.zijlstra@chello.nl, stable@kernel.org,
        dsahern@gmail.com, tglx@linutronix.de, mingo@elte.hu
CC: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/urgent] perf tools, x86: Fix 32-bit compile on 64-bit
 system
References: <1310420304-21452-1-git-send-email-dsahern@gmail.com> <tip-08a4a43fc407d780bdde36d98f89c0dbb2a6be6b@git.kernel.org>
In-Reply-To: <tip-08a4a43fc407d780bdde36d98f89c0dbb2a6be6b@git.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21/2011 08:36 AM, tip-bot for David Ahern wrote:
> Commit-ID:  08a4a43fc407d780bdde36d98f89c0dbb2a6be6b
> Gitweb:     http://git.kernel.org/tip/08a4a43fc407d780bdde36d98f89c0dbb2a6be6b
> Author:     David Ahern <dsahern@gmail.com>
> AuthorDate: Mon, 11 Jul 2011 15:38:24 -0600
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Thu, 21 Jul 2011 13:42:30 +0200
> 
> perf tools, x86: Fix 32-bit compile on 64-bit system
> 
> Builds for 32-bit perf binaries on a 64-bit host currently fail
> with this error:
> 
>  [...]
>  bench/../../../arch/x86/lib/memcpy_64.S: Assembler messages:
>  bench/../../../arch/x86/lib/memcpy_64.S:29: Error: bad register name `%rdi'
>  bench/../../../arch/x86/lib/memcpy_64.S:34: Error: invalid instruction suffix for `movs'
>  bench/../../../arch/x86/lib/memcpy_64.S:50: Error: bad register name `%rdi'
>  bench/../../../arch/x86/lib/memcpy_64.S:61: Error: bad register name `%rdi'
>  ...
> 
> The problem is the detection of the host arch without considering passed in
> flags. This change fixes 32-bit builds via:
> 
> make EXTRA_CFLAGS=-m32
> 
> and 64-bit builds still reference the memcpy_64.S.
> 

But this is the wrong way to build 32-bit code on 64-bit platforms.
make ARCH=i386 is the supported way.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

