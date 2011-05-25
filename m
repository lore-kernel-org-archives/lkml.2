Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932393Ab1EYUbe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 16:31:34 -0400
Received: from outmail010.snc4.facebook.com ([66.220.144.142]:41830 "EHLO
	mx-out.facebook.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932343Ab1EYUbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 16:31:32 -0400
Date: Wed, 25 May 2011 13:31:30 -0700
From: Arun Sharma <asharma@fb.com>
To: Michal Marek <mmarek@suse.cz>
Cc: Arun Sharma <asharma@fb.com>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] kbuild: Integrate with new-kernel-pkg
Message-ID: <20110525203130.GA29304@dev1756.snc6.facebook.com>
References: <1305653779-3445-1-git-send-email-asharma@fb.com>
 <4DD2D0B3.4070208@suse.cz>
 <20110517204520.GA21201@dev1756.snc6.facebook.com>
 <4DD2E9D9.7030207@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DD2E9D9.7030207@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 17, 2011 at 11:34:17PM +0200, Michal Marek wrote:
> 
> Or use /sbin/installkernel and let distros handle it.

Updated distro specific patch (not expecting you to apply it).
The earlier version was mixed up with kernel-devel patch.

 -Arun

commit cb73fb35a588922344763c075b2fce159df41fc7
Author: Arun Sharma <asharma@fb.com>
Date:   Sun Mar 6 08:08:53 2011 -0800

    kbuild: Integrate with new-kernel-pkg
    
    Handles mkinitrd, updating the bootloader among other things.
    
    Signed-off-by: Arun Sharma <asharma@fb.com>

diff --git a/scripts/package/mkspec b/scripts/package/mkspec
index ed8b6a8..f5f0cb5 100755
--- a/scripts/package/mkspec
+++ b/scripts/package/mkspec
@@ -40,6 +40,8 @@ echo "Source: kernel-$__KERNELRELEASE.tar.gz"
 fi
 
 echo "BuildRoot: %{_tmppath}/%{name}-%{PACKAGE_VERSION}-root"
+echo "Requires(post): /sbin/new-kernel-pkg"
+echo "Requires(preun): /sbin/new-kernel-pkg"
 echo "Provides: $PROVIDES"
 echo "%define __spec_install_post /usr/lib/rpm/brp-compress || :"
 echo "%define debug_package %{nil}"
@@ -95,6 +97,14 @@ echo 'mv vmlinux.orig vmlinux'
 echo "%endif"
 
 echo ""
+echo "%preun"
+echo '/sbin/new-kernel-pkg --rminitrd --rmmoddep --remove '"$KERNELRELEASE"' || exit $?'
+
+echo ""
+echo "%post"
+echo '/sbin/new-kernel-pkg --mkinitrd --depmod --install --make-default '"$KERNELRELEASE"' || exit $?'
+
+echo ""
 echo "%clean"
 echo 'rm -rf $RPM_BUILD_ROOT'
 echo ""
