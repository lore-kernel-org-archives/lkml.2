Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759887Ab1D0TuN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 15:50:13 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48944 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756710Ab1D0TuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 15:50:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BrAxTVyvggHleaDkienBXGfW2NOPeLYemylp05ZfP/NBdwkFEbM1Sx1Vh5CP9F+yxA
         yuY9AsPJ9KK+i7GhgRoTB6w0sImmQQwY78/CjbHPYkMN0E9fs39vpDxAXnSmQ8wLfEuI
         UIEfKu1pnAIVrA+z022esHSx2YtXZMzlvEFs0=
Date: Wed, 27 Apr 2011 21:50:07 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jason Wessel <jason.wessel@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/6] x86: Allow the user not to build hw_breakpoints
Message-ID: <20110427195004.GA3654@nowhere>
References: <1303923602-2923-1-git-send-email-fweisbec@gmail.com>
 <1303923602-2923-4-git-send-email-fweisbec@gmail.com>
 <4DB854AA.6070101@zytor.com>
 <20110427182633.GB1753@nowhere>
 <008d59a3-bd23-4cb3-8a73-1640137e3ac4@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <008d59a3-bd23-4cb3-8a73-1640137e3ac4@email.android.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 11:54:17AM -0700, H. Peter Anvin wrote:
> Why do you have to be able to disable breakpoints to disable perf? That seems seriously backwards, especially since we had breakpoints long before perf...

That started when we implemented breakpoints as counters. Then we realized that
ptrace had its own scheduling that was somehow duplicating what perf was doing.
So we have finally unified that under perf. The good point is that archs don't need
to care much about ptrace breakpoints tracking, just the interface.

But yeah the bad point is that dependency.
