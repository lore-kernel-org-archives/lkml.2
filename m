Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932423Ab1GNVvn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 17:51:43 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60500 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932320Ab1GNVvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 17:51:42 -0400
Date: Thu, 14 Jul 2011 23:51:37 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jason Wessel <jason.wessel@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/6] x86: Allow the user not to build hw_breakpoints
Message-ID: <20110714215134.GB26786@somewhere.redhat.com>
References: <1310655837-328-1-git-send-email-fweisbec@gmail.com>
 <1310655837-328-4-git-send-email-fweisbec@gmail.com>
 <4E1F5EF3.6050601@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E1F5EF3.6050601@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 14, 2011 at 02:26:11PM -0700, H. Peter Anvin wrote:
> On 07/14/2011 08:03 AM, Frederic Weisbecker wrote:
> > So that hw_breakpoints and perf can be not built on
> > specific embedded systems.
> 
> I want to emphasize I am very, very unhappy about this.  It should be
> possible to not build perf while still have breakpoints available...
> breakpoints are way more important than perf.

I know and that's a long term goal. I believe Will Deacon is currently working
on breakpoints to avoid archs to translate ptrace user arch input into perf generic
information (which afterward is eventually translated back to arch information).
This is a necessary first step to have a ptrace breakpoint implementation independant of
perf. Once we'll have that and all archs are converted to that new mode, we can work
toward having breakpoints not requiring perf to work.

Until we reach that point, it's still nice to have optable breakpoints. I think
it is a desired feature given the feedbacks I get from Prasad for example.
If that makes it possible to try a kernel without perf in x86, good too.

But this is not intended to be a solution of the breakpoint - perf dependency. That
dependency was a design mistake that needs more to be fixed.
We want to be able to have breakpoints without perf in the end. This just requires
deeper and longer term work that is currently in progress.
