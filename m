Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109Ab1EQTcP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 15:32:15 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:35180 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756492Ab1EQTcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 15:32:11 -0400
Date: Tue, 17 May 2011 12:31:53 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        akpm <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org
Subject: [PATCH -next] proc_fs: add stub for proc_mkdir_mode
Message-Id: <20110517123153.6fed984d.randy.dunlap@oracle.com>
In-Reply-To: <20110517142749.8927b65b.sfr@canb.auug.org.au>
References: <20110517142749.8927b65b.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090203.4DD2CD35.0046:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Provide a stub for proc_mkdir_mode() when CONFIG_PROC_FS is not
enabled, just like the stub for proc_mkdir().

Fixes this build error:
drivers/net/wireless/airo.c:4504: error: implicit declaration of function 'proc_mkdir_mode'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 include/linux/proc_fs.h |    2 ++
 1 file changed, 2 insertions(+)

--- linux-next-20110517.orig/include/linux/proc_fs.h
+++ linux-next-20110517/include/linux/proc_fs.h
@@ -210,6 +210,8 @@ static inline struct proc_dir_entry *pro
 		struct proc_dir_entry *parent,const char *dest) {return NULL;}
 static inline struct proc_dir_entry *proc_mkdir(const char *name,
 	struct proc_dir_entry *parent) {return NULL;}
+static inline struct proc_dir_entry *proc_mkdir_mode(const char *name,
+	mode_t mode, struct proc_dir_entry *parent) { return NULL; }
 
 static inline struct proc_dir_entry *create_proc_read_entry(const char *name,
 	mode_t mode, struct proc_dir_entry *base, 
