Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758050Ab2BIU3l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 15:29:41 -0500
Received: from mga03.intel.com ([143.182.124.21]:61150 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754163Ab2BIU3g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 15:29:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="64971397"
Date: Thu, 9 Feb 2012 15:29:38 -0500
From: Matthew Wilcox <willy@linux.intel.com>
To: linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Doug Nelson <doug.nelson@intel.com>
Subject: scsi_id: sending ioctl 2285 to a partition
Message-ID: <20120209202938.GA14342@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Commit 0bfc96cb77 adds this printk that triggers tens of thousands of
times during a run of "a well-known database benchmark".  0x2285 is SG_IO.
I'm not sure why scsi_id feels that it needs to repeatedly send a SCSI
INQUIRY to a partition, but there we are.

Oh, userspace is RHEL 6.2 and the kernel in use is 3.2.3.
