Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206Ab0EROeL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 10:34:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32961 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751096Ab0EROeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 10:34:05 -0400
Date: Tue, 18 May 2010 07:30:54 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] core/locking changes for v2.6.35
In-Reply-To: <20100517212848.GA28536@elte.hu>
Message-ID: <alpine.LFD.2.00.1005180729340.4195@i5.linux-foundation.org>
References: <20100517212848.GA28536@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 17 May 2010, Ingo Molnar wrote:
> 
> Tony Breeds (1):
>       mutex: Fix optimistic spinning vs. BKL

Grr. This has the ugly timeout thing, but what's _really_ ugly about it is

	kernel/mutex.c: In function ¡__mutex_lock_common¢:
	kernel/mutex.c:148: warning: unused variable ¡timeout¢

Nasty. It happens when spinning is disabled due to lockdep or whatever 
debugging that kills it.

		Linus
