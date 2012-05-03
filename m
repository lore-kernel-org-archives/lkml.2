Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754451Ab2ECHCV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 03:02:21 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:35965 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469Ab2ECHCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 03:02:20 -0400
Date: Thu, 3 May 2012 09:02:07 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH RFC V1 0/5] Rationalize time keeping
Message-ID: <20120503070139.GA2235@netboy.at.omicron.at>
References: <cover.1335510125.git.richardcochran@gmail.com>
 <4F9B228F.90903@linaro.org>
 <20120428080443.GA2241@netboy.at.omicron.at>
 <4F9EFC70.50405@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F9EFC70.50405@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2012 at 01:56:16PM -0700, John Stultz wrote:
> No. So, on architectures that support vsyscalls/vdso (x86_64,
> powerpc, ia64, and maybe a few others) getnstimeofday() is really
> only an internal interface for in-kernel access. Userland uses the
> vsyscall/vdso interface to be able to read the time completely from
> userland context (with no syscall overhead). Since this is done in
> different ways for each architecture, you need to export the proper
> information out via update_vsyscall() and also update the
> arch-specific vsyscall gettimeofday paths (which is non-trivial, as
> some arches are implemented in asm, etc - my sympathies here, its a
> pain).

Okay, so now I understand the vDSO page thingy. Help me please to
understand exactly which architectures would need changes for my
proposal.

The only archs exporting time variables/functions through vDSO are
those which define CONFIG_GENERIC_TIME_VSYSCALL=y, namely:

- ia64
- powerpc 64 and 32 bit
- s390    64 and 32 bit
- x86     64 bit only **

  ** But 32 guest running in a 64 host also has time in the vDSO?!?

Did I get that right?

Thanks,
Richard


