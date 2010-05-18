Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756709Ab0ERQ2v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 12:28:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48507 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756446Ab0ERQ2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 12:28:48 -0400
Date: Tue, 18 May 2010 09:26:03 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, benh@kernel.crashing.org, stable@kernel.org,
       tglx@linutronix.de, tony@bakeyournoodle.com,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/locking] mutex: Fix optimistic spinning vs. BKL
In-Reply-To: <20100518160838.GA20658@elte.hu>
Message-ID: <alpine.LFD.2.00.1005180925180.4195@i5.linux-foundation.org>
References: <20100507042010.GR12389@ozlabs.org> <tip-227945799cc10d77c6ef812f3eb8a61a78689454@git.kernel.org> <20100518160838.GA20658@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 18 May 2010, Ingo Molnar wrote:
>
> Tony, mind sending a version of this patch that does not 
> include a jiffies based spinning loop?

I think it should just be the two-liner

	if (current->lock_depth >= 0)
		break;

in that loop. Plus comment.

		Linus
