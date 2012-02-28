Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964982Ab2B1BIK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 20:08:10 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49705 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964962Ab2B1BIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 20:08:06 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.242.201 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
MIME-Version: 1.0
Message-Id: <20120228010215.452163443@linuxfoundation.org>
User-Agent: quilt/0.51-17.1
Date: Mon, 27 Feb 2012 17:03:10 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Ben Hutchings <ben@decadent.org.uk>,
        maximilian attems <max@stro.at>, Michal Marek <mmarek@suse.cz>
Subject: [ 67/73] builddeb: Dont create files in /tmp with predictable names
In-Reply-To: <20120228010246.GA24299@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit 6c635224602d760c1208ada337562f40d8ae93a5 upstream.

The current use of /tmp for file lists is insecure.  Put them under
$objtree/debian instead.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Acked-by: maximilian attems <max@stro.at>
Signed-off-by: Michal Marek <mmarek@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 scripts/package/builddeb |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/scripts/package/builddeb
+++ b/scripts/package/builddeb
@@ -238,14 +238,14 @@ EOF
 fi
 
 # Build header package
-(cd $srctree; find . -name Makefile -o -name Kconfig\* -o -name \*.pl > /tmp/files$$)
-(cd $srctree; find arch/$SRCARCH/include include scripts -type f >> /tmp/files$$)
-(cd $objtree; find .config Module.symvers include scripts -type f >> /tmp/objfiles$$)
+(cd $srctree; find . -name Makefile -o -name Kconfig\* -o -name \*.pl > "$objtree/debian/hdrsrcfiles")
+(cd $srctree; find arch/$SRCARCH/include include scripts -type f >> "$objtree/debian/hdrsrcfiles")
+(cd $objtree; find .config Module.symvers include scripts -type f >> "$objtree/debian/hdrobjfiles")
 destdir=$kernel_headers_dir/usr/src/linux-headers-$version
 mkdir -p "$destdir"
-(cd $srctree; tar -c -f - -T /tmp/files$$) | (cd $destdir; tar -xf -)
-(cd $objtree; tar -c -f - -T /tmp/objfiles$$) | (cd $destdir; tar -xf -)
-rm -f /tmp/files$$ /tmp/objfiles$$
+(cd $srctree; tar -c -f - -T "$objtree/debian/hdrsrcfiles") | (cd $destdir; tar -xf -)
+(cd $objtree; tar -c -f - -T "$objtree/debian/hdrobjfiles") | (cd $destdir; tar -xf -)
+rm -f "$objtree/debian/hdrsrcfiles" "$objtree/debian/hdrobjfiles"
 arch=$(dpkg --print-architecture)
 
 cat <<EOF >> debian/control


