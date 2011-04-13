Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757556Ab1DMQxb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 12:53:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59504 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756973Ab1DMQx3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 12:53:29 -0400
Message-ID: <4DA5D4D8.7000902@zytor.com>
Date: Wed, 13 Apr 2011 09:52:40 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110403 Fedora/3.1.9-6.fc15 Thunderbird/3.1.9
MIME-Version: 1.0
To: Frank Arnold <farnold@amd64.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Clean up mwait_play_dead
References: <1302711073-31985-1-git-send-email-farnold@amd64.org>
In-Reply-To: <1302711073-31985-1-git-send-email-farnold@amd64.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/13/2011 09:11 AM, Frank Arnold wrote:
> From: Frank Arnold <frank.arnold@amd.com>
> 
> Commit 93789b32dbf355e70f18b17a82e8661677a7f7fb introduced
> cpuinfo_x86 *c for brevity. It is used to check for the
> mwait feature flag. The same can be done with a subsequent
> check for clflsh and save us a second per-cpu pointer
> dereference.
> 
> Signed-off-by: Frank Arnold <frank.arnold@amd.com>
> Acked-by: Borislav Petkov <borislav.petkov@amd.com>
> ---
>  arch/x86/kernel/smpboot.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 

This should be using this_cpu_has()... if that's not in the tree yet we
should add it.

Creating an absolute pointer for a percpu references is a big lose.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

