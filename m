Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767699Ab2KOMfn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 07:35:43 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:50808 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993283Ab2KOMfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 07:35:42 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: Re: [RFC PATCH v1 14/31] ARC: syscall support
Date: Thu, 15 Nov 2012 12:35:31 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: "Gilad Ben-Yossef" <gilad@benyossef.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
References: <1352281674-2186-1-git-send-email-vgupta@synopsys.com> <201211131037.43526.arnd@arndb.de> <50A48882.3030204@synopsys.com>
In-Reply-To: <50A48882.3030204@synopsys.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201211151235.31735.arnd@arndb.de>
X-Provags-ID: V02:K0:84quefjv9AuytqDqb7NOo6UEQ7yoRO+Aqzxr0Y8Lqco
 ZoCwQRCZmonYlj7ZMbjK+WLVYAoOpSgo3JPPPf2Zol0vuIFoRf
 Qj4YWnPCY/BhkopFYWZxsWZUf+Yfnd4ZP9hl+E9Vn6G7Cp7/SJ
 1ovS8E5euxHwDl0X5H9wBLBcuSW64N4dqBHqlOPfsmP6C9vxqI
 7EY8BnLFw4ss/ajxcp/STfaE3lTO3KdKmHxvpkcD8duwyBl2rB
 tsRn9VXJhpt1ZKTo6Ii3ObhGHEQaS4z6sMIbP/SgMcpgtN3Sis
 uL1jqrDOeqpaWIfK0n7jENfbZikkG+h7VSeJzRg9xR7DVvp9QM
 KmoG6NkmINeY1koiRHgc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 November 2012, Vineet Gupta wrote:
> So the primary concern here is not breaking the userspace ABI - right ?
> 
> For syscalls I agree that we will indeed need to fix the ABI - by fixing
> uClibc. And if uClibc doesn't merge the fixes we can stay out of tree
> for uClibc - as we currently already are.

I'm sure we can find a solution for uClibc. We already have seven
architectures using the generic syscalls, including at least one
(arm64) that is going to run on a large number of installations
in the future.

> For gdbserver, the kernel provides the complete regset ABI. However it
> also provides a very limited version of old ABI - i.e. ptrace with
> PEEKUSR/POKEUSR. Note that latter is just a shim layer and it reuses the
> regset callbacks. This allows us to support the legacy gdbserver. If and
> when gdbserver upgrades it can switch over to new interface. So all
> along there will be NO ABI breakage at all. The cost is couple extra
> functions in kernel which we might have to maintain for some foreseeable
> future. Agree ?

It's more a question of principle. The rule is that we don't break user
space, and ptrace is just another user space interface is this. If
we merge it now, we will keep it around forever, taking it out later
is not an option IMHO. My preference would be not to merge the backwards
compatibility layer for ptrace at all, but I'm willing to listen to
other people that support your view if you want to keep it. In one
way, ptrace is less critical than the other system calls, and that is
because it's already architecture specific.

	Arnd
