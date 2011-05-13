Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757855Ab1EMRis (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 13:38:48 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:55834 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757171Ab1EMRir convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 13:38:47 -0400
Date: Fri, 13 May 2011 10:37:50 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org,
        =?ISO-8859-1?Q?Jean-Fran=E7ois?= Dagenais 
	<dagenaisj@sonatest.com>,
        Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
        Szabolcs Gyurko <szabolcs.gyurko@tlt.hu>,
        Matt Reimer <mreimer@vpop.net>
Subject: [PATCH -mm] w1: fix w1_ds2408.c printk formats
Message-Id: <20110513103750.3fc12a1b.randy.dunlap@oracle.com>
In-Reply-To: <201105122329.p4CNTanN009889@imap1.linux-foundation.org>
References: <201105122329.p4CNTanN009889@imap1.linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4DCD6C7B.00B3:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printk format warnings (on i386):
(in w1-add-1-wire-w1-ds2408-8-channel-addressable-switch-support.patch)

drivers/w1/slaves/w1_ds2408.c:79: warning: format '%lu' expects type 'long unsigned int', but argument 7 has type 'size_t'
drivers/w1/slaves/w1_ds2408.c:92: warning: format '%lu' expects type 'long unsigned int', but argument 7 has type 'size_t'
drivers/w1/slaves/w1_ds2408.c:106: warning: format '%lu' expects type 'long unsigned int', but argument 7 has type 'size_t'
drivers/w1/slaves/w1_ds2408.c:120: warning: format '%lu' expects type 'long unsigned int', but argument 7 has type 'size_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jean-François Dagenais <dagenaisj@sonatest.com>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: Szabolcs Gyurko <szabolcs.gyurko@tlt.hu>
Cc: Matt Reimer <mreimer@vpop.net>
---
 drivers/w1/slaves/w1_ds2408.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- mmotm-2011-0512-1552.orig/drivers/w1/slaves/w1_ds2408.c
+++ mmotm-2011-0512-1552/drivers/w1/slaves/w1_ds2408.c
@@ -77,7 +77,7 @@ static ssize_t w1_f29_read_state(
 	char *buf, loff_t off, size_t count)
 {
 	dev_dbg(&kobj_to_w1_slave(kobj)->dev,
-		"Reading %s kobj: %p, off: %0#10x, count: %lu, buff addr: %p",
+		"Reading %s kobj: %p, off: %0#10x, count: %zu, buff addr: %p",
 		bin_attr->attr.name, kobj, (unsigned int)off, count, buf);
 	if (count != 1 || off != 0)
 		return -EFAULT;
@@ -90,7 +90,7 @@ static ssize_t w1_f29_read_output(
 	char *buf, loff_t off, size_t count)
 {
 	dev_dbg(&kobj_to_w1_slave(kobj)->dev,
-		"Reading %s kobj: %p, off: %0#10x, count: %lu, buff addr: %p",
+		"Reading %s kobj: %p, off: %0#10x, count: %zu, buff addr: %p",
 		bin_attr->attr.name, kobj, (unsigned int)off, count, buf);
 	if (count != 1 || off != 0)
 		return -EFAULT;
@@ -104,7 +104,7 @@ static ssize_t w1_f29_read_activity(
 	char *buf, loff_t off, size_t count)
 {
 	dev_dbg(&kobj_to_w1_slave(kobj)->dev,
-		"Reading %s kobj: %p, off: %0#10x, count: %lu, buff addr: %p",
+		"Reading %s kobj: %p, off: %0#10x, count: %zu, buff addr: %p",
 		bin_attr->attr.name, kobj, (unsigned int)off, count, buf);
 	if (count != 1 || off != 0)
 		return -EFAULT;
@@ -118,7 +118,7 @@ static ssize_t w1_f29_read_cond_search_m
 	char *buf, loff_t off, size_t count)
 {
 	dev_dbg(&kobj_to_w1_slave(kobj)->dev,
-		"Reading %s kobj: %p, off: %0#10x, count: %lu, buff addr: %p",
+		"Reading %s kobj: %p, off: %0#10x, count: %zu, buff addr: %p",
 		bin_attr->attr.name, kobj, (unsigned int)off, count, buf);
 	if (count != 1 || off != 0)
 		return -EFAULT;
