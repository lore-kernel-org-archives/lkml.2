Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759600Ab1D0RDN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 13:03:13 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35594 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759518Ab1D0RDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 13:03:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=KjA68BZSEt501TDY0RxkA7aUsBb8ZljkJ5shFvMK39z27JqKmSgm68nXWQIJAdiOxz
         py+xkGzCjw0lKciIaFIWIfGNVXh1834g3Xy9j95G3O8j8Yd16dafeoro/5uIRS9rrEV9
         Y0U4eAqNIx4VXeB8SFIpeaGY2lBVx2dSlCaLA=
Date: Wed, 27 Apr 2011 19:02:58 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Will Deacon <will.deacon@arm.com>,
        Prasad <prasad@linux.vnet.ibm.com>, Paul Mundt <lethal@linux-sh.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 0/6] hw_breakpoint: Let the user choose not to build it
 (and perf too)
Message-ID: <20110427170253.GA1753@nowhere>
References: <1303923602-2923-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303923602-2923-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 06:59:56PM +0200, Frederic Weisbecker wrote:
> Hi,
> 
> Until now, x86 and superh32 had to always build hw_breakpoint and perf.
> And powerpc and arm were always building hw_breakpoints when perf
> was enabled.
> 
> After this patchset, one can simply disable hw_breakpoints if he
> selected CONFIG_EXPERT. Afterward the user is free to select perf
> or not. Except on SH unfortunately because that would require a
> bit of change in ptrace to support singlestep failures.
> 
> Frederic Weisbecker (6):
>   hw_breakpoints: Split hardware breakpoints config
>   hw_breakpoints: Migrate breakpoint conditional build under new config
>   x86: Allow the user not to build hw_breakpoints
>   hw_breakpoints: Breakpoints arch ability don't need perf events
>   hw_breakpoints: Only force perf events if breakpoints are selected
>   hw_breakpoints: Drop remaining misplaced dependency on perf

Ah, and every !x86 archs touched by this patchset have been compile tested only.
