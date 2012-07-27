Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597Ab2G0IdH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 04:33:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:46871 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464Ab2G0Ics convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 04:32:48 -0400
Message-ID: <1343377963.32120.30.camel@twins>
Subject: Re: [PATCH 1/2] sched: recover SD_WAKE_AFFINE in
 select_task_rq_fair and code clean up
From: Peter Zijlstra <peterz@infradead.org>
To: Alex Shi <alex.shi@intel.com>
Cc: Mike Galbraith <efault@gmx.de>, mingo@redhat.com,
        linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com
Date: Fri, 27 Jul 2012 10:32:43 +0200
In-Reply-To: <5011F323.10202@intel.com>
References: <1343280446-24019-1-git-send-email-alex.shi@intel.com>
	 <1343295457.6863.43.camel@marge.simpson.net> <5011F323.10202@intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-07-27 at 09:47 +0800, Alex Shi wrote:

> From 610515185d8a98c14c7c339c25381bc96cd99d93 Mon Sep 17 00:00:00 2001
> From: Alex Shi <alex.shi@intel.com>
> Date: Thu, 26 Jul 2012 08:55:34 +0800
> Subject: [PATCH 1/3] sched: recover SD_WAKE_AFFINE in select_task_rq_fair and
>  code clean up
> 
> Since power saving code was removed from sched now, the implement
> code is out of service in this function, and even pollute other logical.
> like, 'want_sd' never has chance to be set '0', that remove the effect
> of SD_WAKE_AFFINE here.
> 
> So, clean up the obsolete code and some other unnecessary code.
> 
> Signed-off-by: Alex Shi <alex.shi@intel.com>

I think your code leaves an unused definition of SD_PREFER_LOCAL around.
