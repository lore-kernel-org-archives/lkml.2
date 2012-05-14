Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909Ab2ENI3Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 04:29:25 -0400
Received: from plane.gmane.org ([80.91.229.3]:45331 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753479Ab2ENI3X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 04:29:23 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH 0/2] kdump: Enter 2nd kernel with BSP for enabling
 multiple CPUs
Date: Mon, 14 May 2012 08:29:08 +0000 (UTC)
Message-ID: <joqfok$pu1$1@dough.gmane.org>
References: <20120416021951.9303.58568.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 203.114.244.89
User-Agent: slrn/0.9.9p1 (Linux)
Cc: kexec@lists.infradead.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So, the reason why you want to have multiple CPU's enabled in the 2nd
kernel is to speed up the compression of the core dump?

The first question is that, why the speed is important? Given the fact
that the whole kdump progress happens automatically nowdays, there should
be very few guys waiting for a kdump to complete, so the speed is not that
important.

Second, currently we use nr_cpus=1 for the 2nd kernel on RHEL6,
to reduce the memory usage in the 2nd kernel. You mentioned
512M is a limit, but we want to make it even less, even 512M is
not a good choice for us on x86. Bringing up more than 1 CPU will
of course need more memory in the 2nd kernel.

The limit is not only the size, but also the max address of loading
initrd, which is 896M on x86 IIRC. A contiguos memory area larger
than 512M usually sit above 869M, due to the fragmentation in
the lower memory, so I am afraid you need to do (much?) more work.

So, I am afraid you spend too much effort to fix a not-that-important
issue, but I may miss something here...

Thanks.

