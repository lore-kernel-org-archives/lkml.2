Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932230Ab2JAUwf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 16:52:35 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:42001 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756909Ab2JAUuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 16:50:37 -0400
Date: Mon, 1 Oct 2012 21:49:51 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] arm64: Linux kernel port
Message-ID: <20121001204950.GA11875@arm.com>
References: <20121001160043.GF12460@arm.com>
 <CA+55aFxefxzYB1iLFfWJeen6XK+5MZEMDjMLJQPS9Satr_5CxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxefxzYB1iLFfWJeen6XK+5MZEMDjMLJQPS9Satr_5CxA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2012 at 07:59:52PM +0100, Linus Torvalds wrote:
> On Mon, Oct 1, 2012 at 9:00 AM, Catalin Marinas <catalin.marinas@arm.com> wrote:
> >
> > Please pull the tag below containing the arm64 Linux port. The code
> > lives primarily under arch/arm64/ with a few bits of generic code
> > outside this. Thanks.
> 
> Ok, pulled.

Thanks.

> However, looking at the non-arm64 changes, I note:
> 
>  - the UID16 config option *has* to be fixed.
> 
>    This is not really about arm64, the ugliness comes from every crazy
> architecture. But we really need to fix this to have something like a
> "HAVE_UID16" config option, and have the architectures that support
> this select that option, so that the UID16 config option can just have
> a "depends on HAVE_UID16".
> 
>    Please? Anybody?
>
>  - same goes for DEBUG_KMEMLEAK and DEBUG_BUGVERBOSE.
> 
>  - very similar issues for the crazy mess of "#if defined()" in
> kernel/sysctl.c. Can we please just add a SYSCTL_EXCEPTION_TRACE
> config option, and have the architectures that want this just select
> it?

I agree, they don't look nice. I'll post patches to clean them up.

-- 
Catalin
