Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933566Ab2LGLLt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 06:11:49 -0500
Received: from service87.mimecast.com ([91.220.42.44]:46876 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932728Ab2LGLLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 06:11:48 -0500
From: Jonathan Austin <jonathan.austin@arm.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, dhowells@redhat.com,
        Jonathan Austin <jonathan.austin@arm.com>
Subject: [PATCH] Remove stale entry for generated version.h file in .gitignore
Date: Fri,  7 Dec 2012 11:10:37 +0000
Message-Id: <1354878637-6538-1-git-send-email-jonathan.austin@arm.com>
X-Mailer: git-send-email 1.7.9.5
X-OriginalArrivalTime: 07 Dec 2012 11:11:42.0958 (UTC) FILETIME=[A34798E0:01CDD46B]
X-MC-Unique: 112120711114304001
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id qB7BBqBx025926

Since userspace headers were moved to generated/uapi it possible to have a stale copy
of linux/version.h at that file's old location. This causes confusion after building
an older kernel version, then checking out and building a new one; the old (stale)
version header will still get picked up until it is manually removed. This upsets the
C library.

Since the uapi changes, include/linux/version.h is no longer generated and should not
be ignored, so this patch removes it from .gitignore.

Reported-by: Kevin Petit <kevin.petit@arm.com>
Signed-off-by: Jonathan Austin <jonathan.austin@arm.com>
---
 .gitignore |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/.gitignore b/.gitignore
index 92bd0e4..3b8b9b3 100644
--- a/.gitignore
+++ b/.gitignore
@@ -60,7 +60,6 @@ modules.builtin
 # Generated include files
 #
 include/config
-include/linux/version.h
 include/generated
 arch/*/include/generated
 
-- 
1.7.1


