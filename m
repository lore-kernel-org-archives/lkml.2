Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757775Ab2GFSRV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 14:17:21 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:52310 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031Ab2GFSRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 14:17:19 -0400
MIME-Version: 1.0
In-Reply-To: <1341598329.7709.57.camel@twins>
References: <tip-xxrt0a1zronm1sm36obwc2vy@git.kernel.org> <CA+55aFxY7SqwSQWuRXSg+W=ftp9FtCT1MMEqMiCi1H279Fis-A@mail.gmail.com>
 <1341598329.7709.57.camel@twins>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 6 Jul 2012 11:16:57 -0700
X-Google-Sender-Auth: x7LN3J7Cwcj1q5GHTfez-tUusYs
Message-ID: <CA+55aFzqoz7dcUCQfSrXxX2T8=2wgWdb1H2vaBhk7V-r0uaogw@mail.gmail.com>
Subject: Re: [tip:perf/core] perf/x86: Fix USER/KERNEL tagging of samples
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        akpm@linux-foundation.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 6, 2012 at 11:12 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>
> PEBS, BTS, LBR don't have CS. PEBS does have eflags.
>
> If we cannot do this I'm not sure what we can do :/

Well, you're passed in a "pt_regs". Which *does* have CS, and has it right.

If some code then changes the values in the pt_regs, it is *that* code
that needs to think twice about what it does. Where is that code?

                 Linus
