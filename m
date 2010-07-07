Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803Ab0GGLq1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 07:46:27 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:63606 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054Ab0GGLq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 07:46:26 -0400
From: Joel Becker <joel.becker@oracle.com>
To: Dave Chinner <david@fromorbit.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, ocfs2-devel@oss.oracle.com,
       Tao Ma <tao.ma@oracle.com>, Dave Chinner <dchinner@redhat.com>,
       Christoph Hellwig <hch@lst.de>, Mark Fasheh <mfasheh@suse.com>
Subject: [PATCH 0/3] ocfs2: Tail zeroing fixes.
Date: Wed,  7 Jul 2010 04:16:04 -0700
Message-Id: <1278501367-7710-1-git-send-email-joel.becker@oracle.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <20100703213219.GB21262@mail.oracle.com>
References: <20100703213219.GB21262@mail.oracle.com>
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4C3468F0.0279:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	This is version 3 of the ocfs2 tail zeroing fixes.  This version
has some major changes.  Tao correctly pointed out that we can have
multiple extents past i_size due to unwritten extents.  I've reworked
the zeroing code to walk them all.  Since I had to do that, and I had to
handle refcounted extents, I end up fixing a refcount bug with
non-sparse extentds.
	There are now three patches.  The first changes our zeroing
code to go page-by-page at the high level.  The second actually changes
the zeroing code.  The final patch, limiting zeroing to the end of a
write, is unchanged from v2.

Joel

