Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284Ab0IFAwP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 20:52:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32863 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755251Ab0IFAwN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 20:52:13 -0400
From: NeilBrown <neilb@suse.de>
To: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 06 Sep 2010 10:50:29 +1000
Subject: [PATCH 10/10] ovl: Assorted updates to
	Documentation/filesystems/overlayfs.txt
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20100906005029.20775.74294.stgit@localhost.localdomain>
In-Reply-To: <20100906004829.20775.68828.stgit@localhost.localdomain>
References: <20100906004829.20775.68828.stgit@localhost.localdomain>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: NeilBrown <neilb@suse.de>
---
 Documentation/filesystems/overlayfs.txt |   41 ++++++++++++++++---------------
 1 files changed, 21 insertions(+), 20 deletions(-)

diff --git a/Documentation/filesystems/overlayfs.txt b/Documentation/filesystems/overlayfs.txt
index 02af2d6..4e5f972 100644
--- a/Documentation/filesystems/overlayfs.txt
+++ b/Documentation/filesystems/overlayfs.txt
@@ -4,32 +4,33 @@ Overlay Filesystem
 ==================
 
 This document describes a prototype for a new approach to providing
-union-filesystem functionality in Linux.  A union-filesystem tries to
-present the union of two different filesystems as though it were a
-single filesystem.  The result will inevitably fail to look exactly
-like a normal filesystem for various technical reasons.  The
-expectation is that many use cases will be able to ignore these
-differences.
+overlay-filesystem functionality in Linux (sometimes referred to as
+union-filesystems).  An overlay-filesystem tries to present a
+filesystem which is the result over overlaying one filesystem on top
+of the other.
+
+The result will inevitably fail to look exactly like a normal
+filesystem for various technical reasons.  The expectation is that
+many use cases will be able to ignore these differences.
 
 This approach is 'hybrid' because the objects that appear in the
 filesystem do not all appear to belong to that filesystem.  In many
 case an object accessed in the union will be indistinguishable
 from accessing the corresponding object from the original filesystem.
 This is most obvious from the 'st_dev' field returned by stat(2).
-Some objects will report an st_dev from one original filesystem, some
-from the other, directories will report an st_dev from the union
-itself.  Similarly st_ino will only be unique when combined with
-st_dev, and both of these can change over the lifetime of a
-non-directory object.  Many applications and tools ignore these values
-and will not be affected.
+
+While directories will report an st_dev for the overlay-filesystem,
+all non-directory objects will report an st_dev whichever of the
+'lower' or 'upper' filesystem that is providing the object.  Similarly
+st_ino will only be unique when combined with st_dev, and both of
+these can change over the lifetime of a non-directory object.  Many
+applications and tools ignore these values and will not be affected.
 
 Upper and Lower
 ---------------
 
 An overlay filesystem combines two filesystems - an 'upper' filesystem
-and a 'lower' filesystem.  Note that while in set theory, 'union' is a
-commutative operation, in filesystems it is not - the two filesystems
-are treated differently.  When a name exists in both filesystems, the
+and a 'lower' filesystem.  When a name exists in both filesystems, the
 object in the 'upper' filesystem is visible while the object in the
 'lower' filesystem is either hidden or, in the case of directories,
 merged with the 'upper' object.
@@ -48,14 +49,14 @@ trusted.* extended attributes, and must provide valid d_type in
 readdir responses, at least for symbolic links - so NFS is not
 suitable.
 
-A read-only union of two read-only filesystems may use any filesystem
-type.
+A read-only overlay of two read-only filesystems may use any
+filesystem type.
 
 Directories
 -----------
 
-Unioning mainly involved directories.  If a given name appears in both
-upper ad lower filesystems and refers to a non-directory in either,
+Overlaying mainly involved directories.  If a given name appears in both
+upper and lower filesystems and refers to a non-directory in either,
 then the lower object is hidden - the name refers only to the upper
 object.
 
@@ -67,7 +68,7 @@ into a merged directory.  Then whenever a lookup is requested in such
 a merged directory, the lookup is performed in each actual directory
 and the combined result is cached in the dentry belonging to the overlay
 filesystem.  If both actual lookups find directories, both are stored
-and a merged directory is create, otherwise only one is stored: the
+and a merged directory is created, otherwise only one is stored: the
 upper if it exists, else the lower.
 
 Only the lists of names from directories are merged.  Other content


