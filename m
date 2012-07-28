Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179Ab2G1KnX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2012 06:43:23 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:42169 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830Ab2G1KnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2012 06:43:22 -0400
Date: Sat, 28 Jul 2012 12:43:16 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: linux-kernel@vger.kernel.org
Cc: Miklos Szeredi <mszeredi@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>
Subject: [Bisected] commit 71574865 (vfs: do_last(): common slow lookup)
 breaks CUPS printing
Message-ID: <20120728104316.GA248@x4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Printing with CUPS is broken on the current git tree. Whenever I print a page
the job just sits in the CUPS queue showing "processing". But it never reaches
the printer.  (My CUPS version is 1.5.2. Filesystem is xfs.)

I've bisected this issue to:

commit 7157486541bffc0dfec912e21ae639b029dae3d3
Author: Miklos Szeredi <mszeredi@suse.cz>
Date:   Tue Jun 5 15:10:14 2012 +0200

    vfs: do_last(): common slow lookup
    
    Make the slow lookup part of O_CREAT and non-O_CREAT opens common.
    
    This allows atomic_open to be hooked into the slow lookup part.
    
    Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

`
-- 
Markus
