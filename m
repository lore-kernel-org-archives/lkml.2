Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931Ab2HUURO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 16:17:14 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:65234 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412Ab2HUURL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 16:17:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v2 16/31] arm64: ELF definitions
Date: Tue, 21 Aug 2012 20:17:07 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Will Deacon <Will.Deacon@arm.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com> <201208161237.53594.arnd@arndb.de> <20120821160653.GH12708@arm.com>
In-Reply-To: <20120821160653.GH12708@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208212017.08110.arnd@arndb.de>
X-Provags-ID: V02:K0:anEGhII12ggl1o1VgKNHNPjMAEV+RU//kh4+xGLLMi0
 wvbD9vGHh1PmXJ3AD3ibbq7WMTHPpjv6QUviiwIm2BY/8z5qIt
 UjeP/fdaq+UH38pmfsZzNT7X77879SMloIaby2xkHs3DboHvPd
 P5IKppkfNv+Ym+4yTJd69VBXoJVTpMEbUbWlLSYD+ACMVs/CnB
 wvnDT71nX2/WRt4CIYZzS1/qxAIDF0oIMFZYVNx7T4UsDlCmg3
 kszPSGjs7A5OD6f1jlvcIxZ73YXQ/QF4dkmJ5LysP6r83gEjjm
 7bdspaq/yyz+6Oa69xuWXBWhffRQSAicaTUacUz/83vlxyfKvd
 a3IheQRXwS8j13/EDMAg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 21 August 2012, Catalin Marinas wrote:
> On Thu, Aug 16, 2012 at 01:37:53PM +0100, Arnd Bergmann wrote:
> > On Thursday 16 August 2012, Will Deacon wrote:
> > > > This looks wrong: PER_LINUX/PER_LINUX32 decides over the output of the
> > > > uname system call, while TIF_32BIT decides over the instruction set
> > > > when returning to user space. You definitely should not set the personality
> > > > to the value you pass from the elf loader. Instead, just do
> > > > 
> > > > #define SET_PERSONALITY(ex) clear_thread_flag(TIF_32BIT);
> > > > #defined COMPAT_SET_PERSONALITY(ex) set_thread_flag(TIF_32BIT);
> > > 
> > > In this case, won't uname be incorrect (aarch64l) for aarch32 tasks (which
> > > expect something like armv8l)?
> > 
> > No, the uname output is meant to tell you about the system, not the
> > instruction set that you are using (you already know that in compiled
> > code).
> 
> OK, so we assumed that compat tasks should get a uname as close as
> possible to a 32-bit system, i.e. armv8l, for full compatibility. This
> would allow us to run something like 32-bit Debian on an AArch64 kernel
> without worrying about any scripts failing.

You can still do that, just boot with init="/sbin/setarch armv7 /sbin/init".

> But I can see on x86 that it always reports x86_64 even if the task is
> x86_32.

Not just x86, the same behavior is used on powerpc, s390, mips, sparc and
parisc. Not sure about tile though.

	Arnd
