Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759045Ab2HWPds (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 11:33:48 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:58134 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752524Ab2HWPdp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 11:33:45 -0400
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH 0/2] revert changes to zcache_do_preload()
Date: Thu, 23 Aug 2012 10:33:09 -0500
Message-Id: <1345735991-6995-1-git-send-email-sjenning@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12082315-5806-0000-0000-000018B80933
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset fixes a regression in 3.6 by reverting two dependent
commits that made changes to zcache_do_preload().

The commits undermine an assumption made by tmem_put() in
the cleancache path that preemption is disabled.  This change
introduces a race condition that can result in the wrong page
being returned by tmem_get(), causing assorted errors (segfaults,
apparent file corruption, etc) in userspace.

The corruption was discussed in this thread:
https://lkml.org/lkml/2012/8/17/494

Please apply this patchset to 3.6.  This problem didn't exist
in previous releases so nothing need be done for the stable trees.

Seth Jennings (2):
  Revert "staging: zcache: cleanup zcache_do_preload and
    zcache_put_page"
  Revert "staging: zcache: optimize zcache_do_preload"

 drivers/staging/zcache/zcache-main.c |   54 +++++++++++++++++++---------------
 1 file changed, 31 insertions(+), 23 deletions(-)

-- 
1.7.9.5

