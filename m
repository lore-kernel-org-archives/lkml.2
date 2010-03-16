Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938038Ab0CPRp1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 13:45:27 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:36792 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932742Ab0CPRpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 13:45:25 -0400
Date: Tue, 16 Mar 2010 10:43:44 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 2/2] scripts/kernel-doc: handle/ignore __aligned
Message-Id: <20100316104344.1be95fc7.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4B9FC3AB.00FE:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

scripts/kernel-doc erroneously says:

Warning(include/linux/skbuff.h:410): Excess struct/union/enum/typedef member 'cb' description in 'sk_buff'

on this line in struct sk_buff:
	char			cb[48] __aligned(8);

due to treating the last field as the struct member name, so
teach kernel-doc to ignore __aligned(x) in structs.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 scripts/kernel-doc |    2 ++
 1 file changed, 2 insertions(+)

--- linux-2.6.33-git13.orig/scripts/kernel-doc
+++ linux-2.6.33-git13/scripts/kernel-doc
@@ -1424,6 +1424,8 @@ sub dump_struct($$) {
 	$nested =~ s/\/\*.*?\*\///gos;
 	# strip kmemcheck_bitfield_{begin,end}.*;
 	$members =~ s/kmemcheck_bitfield_.*?;//gos;
+	# strip attributes
+	$members =~ s/__aligned\s*\(\d+\)//gos;
 
 	create_parameterlist($members, ';', $file);
 	check_sections($file, $declaration_name, "struct", $sectcheck, $struct_actual, $nested);
