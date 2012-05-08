Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757714Ab2EHXlU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 19:41:20 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:36439 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757553Ab2EHXlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 19:41:19 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-6.tower-127.messagelabs.com!1336520464!4941804!8
X-Originating-IP: [216.166.12.69]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: remove __user annotation inside of struct's
Date: Tue, 8 May 2012 16:41:00 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205081641.00358.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The structs' comedi_insn, coomedi_insnlist, comedi_cmd,
comedi_chaninfo, and comedi_rangeinfo are all passed to
the kernel from user space using ioctl commands. They
are then copied to kernel space using copy_from_user()
before the data is passed to the drivers.

The __user annotation should not be used with variables
inside the struct. This produces a lot of sparse warnings
like:

warning: dereference of noderef expression 

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

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
