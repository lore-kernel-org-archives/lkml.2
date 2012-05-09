Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760216Ab2EIQgM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 12:36:12 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:27721 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755886Ab2EIQgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 12:36:11 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-15.tower-160.messagelabs.com!1336581369!5901482!1
X-Originating-IP: [216.166.12.178]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] staging: comedi: remove __user annotation inside of struct's
Date: Wed, 9 May 2012 09:36:03 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205090936.03921.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the __user annotations in the struct definitions in
comedi.h.

These structs are used to pass information from user-space
to kernel-space. The copy_from_user and copy_to_user functions
are used to transfer the data between the address spaces.

The drivers then use the information internally under the
assumption that they are kernel-space objects. Having the
__user annotations inside the structs produces a number of
sparse warnings of the type:

warning: dereference of noderef expression

According to Grek Kroah-Hartman:

"When the kernel exports .h files, stuff like this should work
"automatically", so there is no need to not put __user markings."

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

v2: update commit message

Note: This patch exposes some new warnings about different
address space. These will be addressed.

diff --git a/drivers/staging/comedi/comedi.h b/drivers/staging/comedi/comedi.h
index 8ea55ae..2e2f366 100644
--- a/drivers/staging/comedi/comedi.h
+++ b/drivers/staging/comedi/comedi.h
@@ -335,7 +335,7 @@
 	struct comedi_insn {
 		unsigned int insn;
 		unsigned int n;
-		unsigned int __user *data;
+		unsigned int *data;
 		unsigned int subdev;
 		unsigned int chanspec;
 		unsigned int unused[3];
@@ -343,7 +343,7 @@
 
 	struct comedi_insnlist {
 		unsigned int n_insns;
-		struct comedi_insn __user *insns;
+		struct comedi_insn *insns;
 	};
 
 	struct comedi_cmd {
@@ -365,24 +365,24 @@
 		unsigned int stop_src;
 		unsigned int stop_arg;
 
-		unsigned int __user *chanlist;	/* channel/range list */
+		unsigned int *chanlist;	/* channel/range list */
 		unsigned int chanlist_len;
 
-		short __user *data; /* data list, size depends on subd flags */
+		short *data; /* data list, size depends on subd flags */
 		unsigned int data_len;
 	};
 
 	struct comedi_chaninfo {
 		unsigned int subdev;
-		unsigned int __user *maxdata_list;
-		unsigned int __user *flaglist;
-		unsigned int __user *rangelist;
+		unsigned int *maxdata_list;
+		unsigned int *flaglist;
+		unsigned int *rangelist;
 		unsigned int unused[4];
 	};
 
 	struct comedi_rangeinfo {
 		unsigned int range_type;
-		void __user *range_ptr;
+		void *range_ptr;
 	};
 
 	struct comedi_krange {
