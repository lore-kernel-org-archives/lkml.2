Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118Ab0JFBdl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 21:33:41 -0400
Received: from mx.treblig.org ([80.68.94.177]:42370 "EHLO mx.treblig.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751427Ab0JFBdk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 21:33:40 -0400
X-Greylist: delayed 2032 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Oct 2010 21:33:40 EDT
Date: Wed, 6 Oct 2010 01:59:47 +0100
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: swhiteho@redhat.com
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: gfs2_glops_list duplicate initialiser
Message-ID: <20101006005947.GA2512@gallifrey>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/2.6.32.20-kvm-i386-20100823 (i686)
X-Uptime: 01:54:52 up 41 days,  9:21,  1 user,  load average: 0.04, 0.02,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,
  I was running sparse on the current main kernel git tree and
it spotted:

fs/gfs2/glops.c:456:10: warning: Initializer entry defined twice
fs/gfs2/glops.c:459:10:   also defined here

That's:
const struct gfs2_glock_operations *gfs2_glops_list[] = {
        [LM_TYPE_META] = &gfs2_meta_glops,
        [LM_TYPE_INODE] = &gfs2_inode_glops,
        [LM_TYPE_RGRP] = &gfs2_rgrp_glops,
        [LM_TYPE_NONDISK] = &gfs2_trans_glops,
        [LM_TYPE_IOPEN] = &gfs2_iopen_glops,
        [LM_TYPE_FLOCK] = &gfs2_flock_glops,
        [LM_TYPE_NONDISK] = &gfs2_nondisk_glops,
        [LM_TYPE_QUOTA] = &gfs2_quota_glops,
        [LM_TYPE_JOURNAL] = &gfs2_journal_glops,
};

The two separate assignments with the index of LM_TYPE_NONDISK are
as it says a bit odd; it's not obvious to me what the right
index is for the thing that is assigned &gfs2_trans_glops.

Dave
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
\ gro.gilbert @ treblig.org |                               | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
