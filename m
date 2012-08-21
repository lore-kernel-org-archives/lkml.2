Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230Ab2HUQH2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 12:07:28 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:54182 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752082Ab2HUQH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 12:07:26 -0400
Date: Tue, 21 Aug 2012 17:06:53 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Will Deacon <Will.Deacon@arm.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 16/31] arm64: ELF definitions
Message-ID: <20120821160653.GH12708@arm.com>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com>
 <201208151415.39570.arnd@arndb.de>
 <20120816102300.GG31784@mudshark.cambridge.arm.com>
 <201208161237.53594.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201208161237.53594.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2012 at 01:37:53PM +0100, Arnd Bergmann wrote:
> On Thursday 16 August 2012, Will Deacon wrote:
> > > This looks wrong: PER_LINUX/PER_LINUX32 decides over the output of the
> > > uname system call, while TIF_32BIT decides over the instruction set
> > > when returning to user space. You definitely should not set the personality
> > > to the value you pass from the elf loader. Instead, just do
> > > 
> > > #define SET_PERSONALITY(ex) clear_thread_flag(TIF_32BIT);
> > > #defined COMPAT_SET_PERSONALITY(ex) set_thread_flag(TIF_32BIT);
> > 
> > In this case, won't uname be incorrect (aarch64l) for aarch32 tasks (which
> > expect something like armv8l)?
> 
> No, the uname output is meant to tell you about the system, not the
> instruction set that you are using (you already know that in compiled
> code).

OK, so we assumed that compat tasks should get a uname as close as
possible to a 32-bit system, i.e. armv8l, for full compatibility. This
would allow us to run something like 32-bit Debian on an AArch64 kernel
without worrying about any scripts failing.

But I can see on x86 that it always reports x86_64 even if the task is
x86_32.

-- 
Catalin
