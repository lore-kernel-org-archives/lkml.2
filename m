Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751841Ab0CTRHr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 13:07:47 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:55871 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006Ab0CTRHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 13:07:46 -0400
Message-ID: <4BA50086.6020707@oracle.com>
Date: Sat, 20 Mar 2010 10:06:14 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] scripts/kernel-doc: fix fatal error on function prototype
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4BA500D5.016A:SCFMA4539814,ss=1,fgs=0
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
 

