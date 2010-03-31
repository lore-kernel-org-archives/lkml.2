Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757480Ab0CaPwJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 11:52:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11074 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757193Ab0CaPwB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 11:52:01 -0400
Subject: Re: RFC [Patch] Remove "please try 'cgroup_disable=memory' option
	if you don't want memory cgroups" printk at boot time.
From: Larry Woodman <lwoodman@redhat.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1270049283.3551.281.camel@dhcp-100-19-198.bos.redhat.com>
References: <1270049283.3551.281.camel@dhcp-100-19-198.bos.redhat.com>
Content-Type: multipart/mixed; boundary="=-1CdCMh1qAPD4cYP2+D+0"
Date: Wed, 31 Mar 2010 11:54:59 -0400
Message-Id: <1270050899.3551.283.camel@dhcp-100-19-198.bos.redhat.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-1CdCMh1qAPD4cYP2+D+0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Wed, 2010-03-31 at 11:28 -0400, Larry Woodman wrote:
> We are considering removing this printk at boot time from RHEL because
> it will confuse customers, encourage them to change the boot parameters
> and generate extraneous support calls.  Its documented in
> Documentation/kernel-parameters.txt anyway.  Any thoughts???
> 
> Larry Woodman
> 

OOPS, sorry to attach the patch:



--=-1CdCMh1qAPD4cYP2+D+0
Content-Disposition: attachment; filename=rhel6-cgroup.patch
Content-Type: text/x-patch; name=rhel6-cgroup.patch; charset=utf-8
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

--=-1CdCMh1qAPD4cYP2+D+0--

