Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932812Ab0FQJiu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 05:38:50 -0400
Received: from science.horizon.com ([71.41.210.146]:25681 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932502Ab0FQJis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 05:38:48 -0400
Date: 17 Jun 2010 05:38:46 -0400
Message-ID: <20100617093846.5075.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: avi@redhat.com
Subject: Re: [PATCH 0/4] Really lazy fpu
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, npiggin@suse.de
In-Reply-To: <4C18B9AC.3070409@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> That's an interesting optimization - and we already have something 
> similar in the form of fpu preload.  Shouldn't be too hard to do.

Unfortunately, there's no dirty flag for the preloaded FPU state.
Unless you take an interrupt, which defeats the whole purpose of
preload.

AFAIK, I should add; there's a lot of obscure stuff in the x86
system-level architecture.  But a bit of searching around the source
didn't show me anything; once we've used the CPU for 5 context switches,
the kernel calls __math_state_restore when loading the new state,
which sets TS_USEDFPU.


(While you're mucking about in there, do you suppose the gas < 2.16
workaround in arch/x86/include/asm/i387.h:fxsave() can be yanked yet?)
