Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805Ab0DTOWy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 10:22:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35097 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754751Ab0DTOWx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 10:22:53 -0400
Subject: repost - RFC [Patch] Remove "please try 'cgroup_disable=memory'
	option if you don't want memory cgroups" printk at boot time.
From: Larry Woodman <lwoodman@redhat.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org
Content-Type: multipart/mixed; boundary="=-H/O1OMvkVAiyyec34Fay"
Date: Tue, 20 Apr 2010 10:26:27 -0400
Message-Id: <1271773587.28748.134.camel@dhcp-100-19-198.bos.redhat.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-H/O1OMvkVAiyyec34Fay
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Re-posting, cc'ing linux-mm as requested:

We are considering removing this printk at boot time from RHEL because
it will confuse customers, encourage them to change the boot parameters
and generate extraneous support calls.  Its documented in
Documentation/kernel-parameters.txt anyway.  Any thoughts???

Larry Woodman



--=-H/O1OMvkVAiyyec34Fay
Content-Disposition: attachment; filename=rhel6-cgroup.patch
Content-Type: text/x-patch; name=rhel6-cgroup.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

diff --git a/mm/page_cgroup.c b/mm/page_cgroup.c
index 3d535d5..2029fae 100644
--- a/mm/page_cgroup.c
+++ b/mm/page_cgroup.c
@@ -83,8 +83,6 @@ void __init page_cgroup_init_flatmem(void)
 			goto fail;
 	}
 	printk(KERN_INFO "allocated %ld bytes of page_cgroup\n", total_usage);
-	printk(KERN_INFO "please try 'cgroup_disable=memory' option if you"
-	" don't want memory cgroups\n");
 	return;
 fail:
 	printk(KERN_CRIT "allocation of page_cgroup failed.\n");

--=-H/O1OMvkVAiyyec34Fay--

