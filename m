Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932414Ab1IQA3y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 20:29:54 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40880 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932145Ab1IQA3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 20:29:53 -0400
Date: Sat, 17 Sep 2011 09:29:46 +0900
From: Tejun Heo <tj@kernel.org>
To: Ripduman Sohan <Ripduman.Sohan@cl.cam.ac.uk>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org
Subject: Re: [PATCH] workqueue: Restore cpus_allowed mask for sleeping
 workqueue rescue threads
Message-ID: <20110917002946.GU29319@htj.dyndns.org>
References: <1314884193-20454-1-git-send-email-ripduman.sohan@cl.cam.ac.uk>
 <20110902002917.GD2752@htj.dyndns.org>
 <20110915161430.GE1548@tusker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110915161430.GE1548@tusker>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ripduman.

On Thu, Sep 15, 2011 at 05:14:30PM +0100, Ripduman Sohan wrote:
> The rescuer being left bound to the last CPU it was active on is not a
> problem.  As I pointed out in the commit log the issue is that the
> allowed_cpus mask is not restored when rescuers return to sleep,
> rendering inconsistent the presented and actual set of CPUs the
> process may potentially run on.
> 
> Perhaps an explanation is in order.  I am working on a system where we
> constantly sample process run-state (including the process
> Cpus_Allowed field in /proc/<pid>/status) to build a forward plan of
> where the process _may_ run in the future.  In situations of high
> memory pressue (common on our setup) where the rescuers ran often the
> plan begun to significantly deviate from the calculated schedule
> because rescuer threads were marked as only runnable on a single CPU
> when in reality they would bounce across CPUs.

But cpus_allowed doesn't mean where the task *may* run in the future.
It indicates on which cpus the task is allowed to run *now* and it's
allowed to change.

> I've currently put in a special-case exception in our code to account
> for the fact that rescuer threads may run on _any_ CPU regardless of
> the current cpus_allowed mask but I thought it would be useful to
> correct it.  I'm happy to continue with my current approach if you
> deem the patch irrelevant.

I'm not necessarily against the patch if it helps a valid use case but
let's do that when and if the use case becomes relevant enough, which
I don't think it is yet.  Please feel free to raise the issue again
when the situation changes.

Thank you.

-- 
tejun
