Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943Ab0JARsI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 13:48:08 -0400
Received: from adelie.canonical.com ([91.189.90.139]:46886 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753677Ab0JARsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 13:48:06 -0400
From: Andy Whitcroft <apw@canonical.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        vaurora@redhat.com, neilb@suse.de, viro@zeniv.linux.org.uk,
        Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 0/2] overlayfs: module and statfs fixes
Date: Fri,  1 Oct 2010 18:48:00 +0100
Message-Id: <1285955282-10240-1-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just been playing with overlayfs and hit a couple of issues.  First I
was not able to build this filesystem as a module.  Second statfs support
was missing.  Following this email are a couple of patches which I used to
fix these up.  I am not 100% sure the statfs approach is quite right, but
its not clear the semantics can ever be correct in the face of an overlay.

With these applied I was able to drop an overlay over the top of a very
out of date Ubuntu chroot and upgrade it to the latest and greatest;
all without incident.

Nice.

-apw

Andy Whitcroft (2):
  overlayfs: export security_inode_permission to allow overlayfs to be
    modular
  overlayfs: add statfs support

 fs/overlayfs/overlayfs.c |   20 ++++++++++++++++++++
 security/security.c      |    1 +
 2 files changed, 21 insertions(+), 0 deletions(-)

