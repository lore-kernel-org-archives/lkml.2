Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932288Ab2HUS2L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 14:28:11 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:59082 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932196Ab2HUS2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 14:28:06 -0400
Date: Tue, 21 Aug 2012 19:27:31 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Will Deacon <Will.Deacon@arm.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 16/31] arm64: ELF definitions
Message-ID: <20120821182731.GJ12708@arm.com>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com>
 <201208151415.39570.arnd@arndb.de>
 <20120816102300.GG31784@mudshark.cambridge.arm.com>
 <201208161237.53594.arnd@arndb.de>
 <20120821160653.GH12708@arm.com>
 <CAMuHMdVEX0egzFETMJ=LA_PB+7Qc=Ph-7uxofVr__wOE-0cvLQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdVEX0egzFETMJ=LA_PB+7Qc=Ph-7uxofVr__wOE-0cvLQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 07:17:19PM +0100, Geert Uytterhoeven wrote:
> On Tue, Aug 21, 2012 at 6:06 PM, Catalin Marinas
> <catalin.marinas@arm.com> wrote:
> > But I can see on x86 that it always reports x86_64 even if the task is
> > x86_32.
> 
> Really?
> 
> $ uname -m
> x86_64
> $ linux32 uname -m
> i686
> $

Well, you set the personality explicitly with linux32. What I tested was
with an x86_32 uname called directly (without linux32) and even though
the ELF was a 32-bit one, it was reporting x86_64. In this AArch64
patch, a compat task was automatically setting the linux32 personality
(which x86 does not do).

Arnd's point is that the ELF file should not affect the personality and
hence the uname value. This should only be done by an explicit call to
sys_personality().

-- 
Catalin
