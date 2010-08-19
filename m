Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751335Ab0HSDhv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 23:37:51 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:35134 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050Ab0HSDht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 23:37:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=cl2iJW9SBoDx7ZLp9t6YELxeYeSAdRgpAJmmqUFad0FgCesDl49SfvIeSKj3Grkqb5
         s6zyd+wZlYUh6jaFL1uSwDy5uhvZOIYoi6MlpiLTB69s+iAlZ1Ax2B2URLl7cpkgIOHM
         BZ00pGwI06DTjNU1gybTfGaGPl+Ne+OGjrBXg=
From: Namhyung Kim <namhyung@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] initramfs: remove sparse warnings
Date: Thu, 19 Aug 2010 12:37:40 +0900
Message-Id: <1282189064-3904-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patchset removes most of sparse warnings in init/initramfs.c.
Current implementation of initramfs relies on syscall service rountins heavily
so it requires many of arguments to be __user address space pointers but, in
most cases, were missing proper markups. This patchset tries to fix those at
a minimum change.

Namhyung Kim (4):
  initramfs: refactor clean_path()
  initramfs: mark dirp as a __user pointer on clean_rootfs()
  initramfs: mark collect buffers as __user pointers
  initramfs: add missing __user markup

 init/initramfs.c |   69 ++++++++++++++++++++++++++++++-----------------------
 1 files changed, 39 insertions(+), 30 deletions(-)

