Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756222Ab1COXMK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 19:12:10 -0400
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:55947 "HELO
	cpoproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754766Ab1COXMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 19:12:07 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=eQ53yEJ0Q/adcZik8qOVy1r3vqMdR90EGyiu0NtaK5fP1WjnTcDuxuRc3aWQGQN+FEbDBxtp710YaiEz2sVAE3Jl+8+J333RDTK+IEXAnSgrxaogIR2eNfxQd0Sg9foS;
Date: Tue, 15 Mar 2011 16:12:05 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: lkml <linux-kernel@vger.kernel.org>
Cc: torvalds <torvalds@linux-foundation.org>,
        Federica Teodori <federica.teodori@googlemail.com>,
        Rik van Riel <riel@redhat.com>
Subject: [PATCH 4/6] Documentation: file handles are now freed
Message-Id: <20110315161205.413e4d96.rdunlap@xenotime.net>
In-Reply-To: <20110315134316.465b6e2c.rdunlap@xenotime.net>
References: <20110315134316.465b6e2c.rdunlap@xenotime.net>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 173.50.240.230 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Federica Teodori <federica.teodori@googlemail.com>

Since file handles are freed, a little amendment to the documentation

Signed-off-by: Federica Teodori <federica.teodori@googlemail.com>
Acked-by: Rik van Riel<riel@redhat.com>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/sysctl/fs.txt |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

--- lnx-2638-rc8.orig/Documentation/sysctl/fs.txt
+++ lnx-2638-rc8/Documentation/sysctl/fs.txt
@@ -88,20 +88,19 @@ you might want to raise the limit.
 
 file-max & file-nr:
 
-The kernel allocates file handles dynamically, but as yet it
-doesn't free them again.
-
 The value in file-max denotes the maximum number of file-
 handles that the Linux kernel will allocate. When you get lots
 of error messages about running out of file handles, you might
 want to increase this limit.
 
-Historically, the three values in file-nr denoted the number of
-allocated file handles, the number of allocated but unused file
-handles, and the maximum number of file handles. Linux 2.6 always
-reports 0 as the number of free file handles -- this is not an
-error, it just means that the number of allocated file handles
-exactly matches the number of used file handles.
+Historically,the kernel was able to allocate file handles
+dynamically, but not to free them again. The three values in
+file-nr denote the number of allocated file handles, the number
+of allocated but unused file handles, and the maximum number of
+file handles. Linux 2.6 always reports 0 as the number of free
+file handles -- this is not an error, it just means that the
+number of allocated file handles exactly matches the number of
+used file handles.
 
 Attempts to allocate more file descriptors than file-max are
 reported with printk, look for "VFS: file-max limit <number>
