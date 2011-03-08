Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930Ab1CHKyf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 05:54:35 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55633 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982Ab1CHKye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 05:54:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=ja/C1jGPfut9pv0/LAjXFlOjX9Ukrz2j19QAotxgJV2+jG648WkQovIuUD8Mp1r7+D
         GLowPl3cKK6XY/GAd2VDuq+O6lMo/kDkDGGVe8P4oXExHZj9QrEOIAruxvIiAV7/md7x
         eegBo6r3Hdaw0r8eZFS2odDTTzX2DdHqdTBa4=
Date: Tue, 8 Mar 2011 12:54:28 +0200
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] proc: make struct proc_dir_entry::namelen unsigned int
Message-ID: <20110308105428.GA5767@p183.telecom.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Space is not really conserved, because of natural alignment for the next field.
sizeof(struct proc_dir_entry) remains the same.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 fs/proc/generic.c       |    8 ++++----
 include/linux/proc_fs.h |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -28,7 +28,7 @@
 
 DEFINE_SPINLOCK(proc_subdir_lock);
 
-static int proc_match(int len, const char *name, struct proc_dir_entry *de)
+static int proc_match(unsigned int len, const char *name, struct proc_dir_entry *de)
 {
 	if (de->namelen != len)
 		return 0;
@@ -303,7 +303,7 @@ static int __xlate_proc_name(const char *name, struct proc_dir_entry **ret,
 {
 	const char     		*cp = name, *next;
 	struct proc_dir_entry	*de;
-	int			len;
+	unsigned int		len;
 
 	de = *ret;
 	if (!de)
@@ -602,7 +602,7 @@ static struct proc_dir_entry *__proc_create(struct proc_dir_entry **parent,
 {
 	struct proc_dir_entry *ent = NULL;
 	const char *fn = name;
-	int len;
+	unsigned int len;
 
 	/* make sure name is valid */
 	if (!name || !strlen(name)) goto out;
@@ -786,7 +786,7 @@ void remove_proc_entry(const char *name, struct proc_dir_entry *parent)
 	struct proc_dir_entry **p;
 	struct proc_dir_entry *de = NULL;
 	const char *fn = name;
-	int len;
+	unsigned int len;
 
 	spin_lock(&proc_subdir_lock);
 	if (__xlate_proc_name(name, &parent, &fn) != 0) {
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -50,7 +50,7 @@ typedef	int (write_proc_t)(struct file *file, const char __user *buffer,
 
 struct proc_dir_entry {
 	unsigned int low_ino;
-	unsigned short namelen;
+	unsigned int namelen;
 	const char *name;
 	mode_t mode;
 	nlink_t nlink;
