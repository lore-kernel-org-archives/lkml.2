Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755688Ab2IYXbf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 19:31:35 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:31155 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755560Ab2IYXbc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 19:31:32 -0400
MIME-Version: 1.0
Message-ID: <30a570e8-8157-47e1-867a-4960a7c1173d@default>
Date: Tue, 25 Sep 2012 16:31:01 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>
Cc: Mel Gorman <mgorman@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [RFC/PATCH] zcache2 on PPC64 (Was: [RFC] mm: add support for zsmalloc
 and zcache)
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.7  (607090) [OL
 12.0.6661.5003 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Attached patch applies to staging-next and I _think_ should
fix the reported problem where zbud in zcache2 does not
work on a PPC64 with PAGE_SIZE!=12.  I do not have a machine
to test this so testing by others would be appreciated.

Ideally there should also be a BUILD_BUG_ON to ensure
PAGE_SHIFT * 2 + 2 doesn't exceed BITS_PER_LONG, but
let's see if this fixes the problem first.

Apologies if there are line breaks... I can't send this from
a linux mailer right now.  If it is broken, let me know,
and I will re-post tomorrow... though it should be easy
to apply manually for test purposes.

Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>

diff --git a/drivers/staging/ramster/zbud.c b/drivers/staging/ramster/zbud.c
index a7c4361..6921af3 100644
--- a/drivers/staging/ramster/zbud.c
+++ b/drivers/staging/ramster/zbud.c
@@ -103,8 +103,8 @@ struct zbudpage {
 		struct {
 			unsigned long space_for_flags;
 			struct {
-				unsigned zbud0_size:12;
-				unsigned zbud1_size:12;
+				unsigned zbud0_size:PAGE_SHIFT;
+				unsigned zbud1_size:PAGE_SHIFT;
 				unsigned unevictable:2;
 			};
 			struct list_head budlist;
