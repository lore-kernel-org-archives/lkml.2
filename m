Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933121Ab0CPRnk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 13:43:40 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:33283 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759967Ab0CPRng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 13:43:36 -0400
Date: Tue, 16 Mar 2010 10:43:22 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 1/2] scripts/kernel-doc: fix fatal error in function
 signature
Message-Id: <20100316104322.5f715ae8.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4B9FC33E.0091:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix a fatal error in scripts/kernel-doc when a function signature
uses __init_or_module (just ignore that string):

Error(drivers/base/platform.c:568): cannot understand prototype: 'struct platform_device * __init_or_module platform_create_bundle(struct platform_driver *driver, int (*probe)(struct platform_device *), struct resource *res, unsigned int n_res, const void *data, size_t size) '

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 scripts/kernel-doc |    1 +
 1 file changed, 1 insertion(+)

--- lnx-2634-rc1.orig/scripts/kernel-doc
+++ lnx-2634-rc1/scripts/kernel-doc
@@ -1728,6 +1728,7 @@ sub dump_function($$) {
     $prototype =~ s/^noinline +//;
     $prototype =~ s/__devinit +//;
     $prototype =~ s/__init +//;
+    $prototype =~ s/__init_or_module +//;
     $prototype =~ s/^#\s*define\s+//; #ak added
     $prototype =~ s/__attribute__\s*\(\([a-z,]*\)\)//;
 
