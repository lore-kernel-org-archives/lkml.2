Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538Ab2DGJdy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2012 05:33:54 -0400
Received: from plane.gmane.org ([80.91.229.3]:43048 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752151Ab2DGJdx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2012 05:33:53 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: "Frank A. Kingswood" <frank@kingswood-consulting.co.uk>
Subject: [PATCH] user-specified temporary directory for deb-pkg
Date: Sat, 07 Apr 2012 10:33:31 +0100
Message-ID: <jlp1lc$g0p$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: mail.kingswood-consulting.co.uk
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111114 Iceowl/1.0b2 Icedove/3.1.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The Debian package build can be very slow when running against a slow 
NFS server. This patch allows the user to set the BUILDTMP environment 
variable to move these temporaries somewhere local.

diff --git a/scripts/package/builddeb b/scripts/package/builddeb
index f6cbc3d..2f9d2ee 100644
--- a/scripts/package/builddeb
+++ b/scripts/package/builddeb
@@ -74,10 +74,20 @@ if [ -n "$KDEB_PKGVERSION" ]; then
  else
         packageversion=$version-$revision
  fi
-tmpdir="$objtree/debian/tmp"
-fwdir="$objtree/debian/fwtmp"
-kernel_headers_dir="$objtree/debian/hdrtmp"
-libc_headers_dir="$objtree/debian/headertmp"
+
+if [ -n "$BUILDTMP" ] ; then
+       mkdir -p "$BUILDTMP/debian"
+       tmpdir="$BUILDTMP/debian/tmp"
+       fwdir="$BUILDTMP/debian/fwtmp"
+       kernel_headers_dir="$BUILDTMP/debian/hdrtmp"
+       libc_headers_dir="$BUILDTMP/debian/headertmp"
+else
+       tmpdir="$objtree/debian/tmp"
+       fwdir="$objtree/debian/fwtmp"
+       kernel_headers_dir="$objtree/debian/hdrtmp"
+       libc_headers_dir="$objtree/debian/headertmp"
+fi
+
  packagename=linux-image-$version
  fwpackagename=linux-firmware-image
  kernel_headers_packagename=linux-headers-$version

