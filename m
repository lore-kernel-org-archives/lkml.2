Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364Ab1C1WfY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 18:35:24 -0400
Received: from www.linutronix.de ([62.245.132.108]:33957 "EHLO linutronix.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753878Ab1C1WfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 18:35:24 -0400
Date: Tue, 29 Mar 2011 00:35:20 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Snitzer <snizer@redhat.com>,
        James Bottomley <James.Bottomley@suse.de>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>
Subject: [Regression] Please revert a91a2785b20
Message-ID: <alpine.LFD.2.00.1103290006070.2774@localhost6.localdomain6>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Out of the blue all my perfectly fine working test machines which use
RAID stopped working with the very helpful error message:

	md/raid1:md1: active with 2 out of 2 mirrors
	md: pers->run() failed ...

Reverting a91a2785b20 fixes the problem.

Neither the subject line:

 block: Require subsystems to explicitly allocate bio_set integrity mempool

nor the changelog have any hint why that wreckage is in any way
sensible.

The wreckage happens due to:

-       md_integrity_register(mddev);
-       return 0;
+       return md_integrity_register(mddev);

But the changelog does not give the courtesy of explaining these
changes. Also there is no fcking reason why the kernel cannot deal
with the missing integrity capabilities of a drive just by emitting a
warning msg and dealing gracefully with the outcome.

All my RAID setups have been working perfectly fine until now, so
what's the rationale to break this?

Did anyone test this shite on a non enterprise class hardware with a
distro default config ? Obviously _NOT_.

FYI, the config files of those machines are based off a fedora default
config, so this would hit all raid users based on popular distro
configs sooner than later.

Thanks for stealing my time,

	tglx
