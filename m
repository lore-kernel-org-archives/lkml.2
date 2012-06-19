Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153Ab2FSMOx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 08:14:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43511 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752292Ab2FSMOu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 08:14:50 -0400
From: Igor Mammedov <imammedo@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: prarit@redhat.com, oleg@redhat.com, rob@landley.net, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org, luto@mit.edu,
        suresh.b.siddha@intel.com, avi@redhat.com, imammedo@redhat.com,
        a.p.zijlstra@chello.nl, johnstul@us.ibm.com, arjan@linux.intel.com
Subject: [PATCH 0/2 v2] x86: Improve secondary CPU bring-up process robustness
Date: Tue, 19 Jun 2012 14:14:19 +0200
Message-Id: <1340108061-5128-1-git-send-email-imammedo@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reproduced mostly in virt. environments, where physical CPUs are shared
beetween many guests and on overcommited host guest's CPUs may stall
and lead to master CPU 'canceling' CPU bring-up. But in reality being
onlined CPU continued to boot and caused hangs when onlining another CPU.

Now, I'm trying do fix issue a bit earlier. I hope it's better than
the first attempt: https://lkml.org/lkml/2012/5/9/125
Please review.

