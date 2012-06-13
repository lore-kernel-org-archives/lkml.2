Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423Ab2FMAGA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 20:06:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54047 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853Ab2FMAF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 20:05:59 -0400
From: Tyler Hicks <tyhicks@canonical.com>
To: ecryptfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sasha Levin <levinsasha928@gmail.com>
Subject: [PATCH 0/3] eCryptfs: Fix and simplify messaging code
Date: Tue, 12 Jun 2012 17:05:37 -0700
Message-Id: <1339545940-11736-1-git-send-email-tyhicks@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1338061161.4284.16.camel@lappy>
References: <1338061161.4284.16.camel@lappy>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sasha Levin discovered a bug when fuzzing /dev/ecryptfs. The code behind
/dev/ecryptfs never considered the possibility that file descriptors may be
inherited or passed to other processes. Additionally, far too many BUG() calls
were used throughout the messaging code.

The eCryptfs messaging code was originally implemented using netlink. Several
years ago, it was converted to a miscdev driver but it retained some of the
concepts that were specific to netlink.

The first patch is a minimalist approach at solving the bug Sasha discovered.
The second patch removes some cruft. The last patch leverages the file-based
miscdev approach to simplify the implementation.

Tyler

---

 fs/ecryptfs/ecryptfs_kernel.h |   22 ++-----
 fs/ecryptfs/messaging.c       |  136 +++++------------------------------------
 fs/ecryptfs/miscdev.c         |   91 ++++++++-------------------
 3 files changed, 48 insertions(+), 201 deletions(-)

