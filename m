Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758951Ab2HWOPj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 10:15:39 -0400
Received: from mail-wi0-f202.google.com ([209.85.212.202]:39869 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756567Ab2HWOPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 10:15:31 -0400
Message-Id: <20120823141422.444396696@google.com>
User-Agent: quilt/0.48-1
Date: Thu, 23 Aug 2012 07:14:22 -0700
From: pjt@google.com
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Venki Pallipadi <venki@google.com>, Ben Segall <bsegall@google.com>,
        Mike Galbraith <efault@gmx.de>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [patch 00/16] sched: per-entity load-tracking
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Please find attached the latest version for CFS load-tracking.

It implements load-tracking on a per-sched_entity (currently SCHED_NORMAL, but
could be extended to RT as well) basis. This results in a bottom-up
load-computation in which entities contribute to their parents' load, as
opposed to the current top-down where the parent averages its children.  In
particular this allows us to correctly migrate load with their accompanying
entities and provides the necessary inputs for intelligent load-balancing and
power-management.

We've been running this internally for some time now and modulo any gremlins
from rebasing it, I think things have been shaken out and we're touching
mergeable state.

Special thanks to Namhyung Kim and Peter Zijlstra for comments on the last
round series.

For more background and prior discussion please review the previous posting:
https://lkml.org/lkml/2012/6/27/644

- Paul

