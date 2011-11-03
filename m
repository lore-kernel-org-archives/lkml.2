Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693Ab1KCVpt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 17:45:49 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43076 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439Ab1KCVps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 17:45:48 -0400
Date: Thu, 3 Nov 2011 14:39:59 -0700
From: Tejun Heo <tj@kernel.org>
To: Andrew Watts <akwatts@ymail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org,
        linux-pm@lists.linux-foundation.org
Subject: Re: [REGRESSION]: hibernate/sleep regression w/ bisection
Message-ID: <20111103213959.GP4417@google.com>
References: <20111101124759.GA1326@zeus>
 <20111102054658.GA29035@core.coreip.homeip.net>
 <20111102160208.GA6657@zeus>
 <20111102163109.GA29430@core.coreip.homeip.net>
 <20111103155956.GG4417@google.com>
 <20111103184559.GA3295@zeus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111103184559.GA3295@zeus>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Andrew.

On Thu, Nov 03, 2011 at 01:46:19PM -0500, Andrew Watts wrote:
> On Thu, Nov 03, 2011 at 08:59:56AM -0700, Tejun Heo wrote:
> > Andrew, just in case, can you please double check that you're
> > reverting only that single commit (not all the ones afterwards) and
> > the test results?  If they're all okay, can you please trigger the
> > problem, wait a while, trigger sysrq-t and attach the kernel log?
> 
> Hi Tejun.
> 
> I am only reverting 8ee294cd9def0004887da7f44b80563493b0a097 though I first
> revert part of 1d64b655dc083df5c5ac39945ccbbc6532903bf1 so it reverts 
> cleanly. 
> 
> I am very sure of my test results; normally I get 4-5 bad resumes on a 20
> hibernate loop and get no bad resumes with the commit reverted. I have
> been very thorough in my testing to ensure I am not generating false
> positives or false negatives (repeating the loops many times).

Thanks.  Yeah, this is odd & interesting.

> Below is the output you asked for (sysrq t).
> 
> Thanks.
> 
> ~ Andy
> 
> ======================
> 
> 
> kernel: [  345.226523] SysRq : Show State
> kernel: [  345.226531]   task                PC stack   pid father
> kernel: [  345.226535] init            S f4a47b68  5488     1      0 0x00000000
> kernel: [  345.226765] kthreadd        S 00000000  7172     2      0 0x00000000

This is missing all stack traces.  Can you please turn on
FRAME_POINTER and adjust log level such that all stack dumps are
included too?

Thank you.

-- 
tejun
