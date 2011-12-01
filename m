Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225Ab1LAPrb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 10:47:31 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:53199 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755069Ab1LAPra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 10:47:30 -0500
Date: Thu, 1 Dec 2011 07:47:22 -0800
From: Tejun Heo <tj@kernel.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: rjw@sisk.pl, pavel@ucw.cz, len.brown@intel.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH] PM / Hibernate: Thaw processes in
 SNAPSHOT_CREATE_IMAGE ioctl error/test paths
Message-ID: <20111201154722.GB12668@google.com>
References: <20111201131532.21615.86479.stgit@srivatsabhat.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111201131532.21615.86479.stgit@srivatsabhat.in.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 01, 2011 at 06:45:37PM +0530, Srivatsa S. Bhat wrote:
> Commit 2aede851ddf08666f68ffc17be446420e9d2a056 (PM / Hibernate: Freeze
> kernel threads after preallocating memory) moved the freezing of kernel
> threads to hibernation_snapshot() function.
> 
> So now, if the call to hibernation_snapshot() fails or returns early due
> to a successful hibernation test, the caller has to thaw processes to
> ensure that the system gets back to its original state.
> 
> But in SNAPSHOT_CREATE_IMAGE hibernation ioctl, the caller does not thaw
> processes. Fix this issue. But note that if hibernation_snapshot() returned
> due to a successful freezer test, we still send the value of 'in_suspend'
> (which is now 0) to userspace, because we are not in an error path per-se,
> and moreover, the value of in_suspend correctly depicts the situation here.
> 
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Is this still applicable on top of pm-freezer branch?

Thanks.

-- 
tejun
