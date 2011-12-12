Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719Ab1LLRgY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 12:36:24 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44577 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753576Ab1LLRgV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 12:36:21 -0500
Date: Mon, 12 Dec 2011 18:34:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Borislav Petkov <bp@amd64.org>
Cc: X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 0/5] x86, microcode, AMD: Size checking fixes
Message-ID: <20111212173430.GJ23870@elte.hu>
References: <1323454135-16777-1-git-send-email-bp@amd64.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323454135-16777-1-git-send-email-bp@amd64.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@amd64.org> wrote:

> From: Borislav Petkov <borislav.petkov@amd.com>
> 
> Hi all,
> 
> this is a patchset that reworks and fixes ucode size checking. 
> The meat of it is contained in 3/5 which reworks the code to 
> iterate over the patches in the microcode binary image 
> _without_ vmalloc-ing space for every patch in succession in 
> order to look at it and go on to the next, if it doesn't fit.
> 
> In any case, we end up loading at most one patch so before we 
> copy it in local storage we do all possible checks on it now, 
> and copy it only then, if all checks are passed.
> 
> Also, for simplicity, we alloc a single 4K page as a buffer 
> for it which we keep per CPU as long as the ucode module is 
> loaded and free upon exit. This simplifies all 
> allocations/cleanup paths significantly.

No objections from anyone it appears - did you want to send this 
as a pull request?

Thanks,

	Ingo
