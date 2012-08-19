Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327Ab2HSRMw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 13:12:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47877 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751353Ab2HSRMv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 13:12:51 -0400
Date: Sun, 19 Aug 2012 19:09:17 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Anton Arapov <anton@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        William Cohen <wcohen@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] uprobes: mmap_region() corrupts mm->mm_rb if
	uprobe_mmap() fails
Message-ID: <20120819170917.GA26953@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I guess this patch was forgotten due to the lengthy discussion,
see http://marc.info/?t=134349366100001

I am re-sending it because it fixes the serious and easy-to-trigger
problem. Just do something like

	# echo "p /bin/true:OFFSET_OF_INVALID_INSN" > tracing/uprobe_events
	# /bin/true

to crash the kernel. I think this is 3.6/stable material, the
patch is simple and obviously can't make any harm.


Just in case... Yes, this is not what we want in the long term,
but there is no simple fix for now and we need other changes in
uprobe.c before we can teach mmap_region() to handle the error
from uprobe_mmap().

Oleg.

