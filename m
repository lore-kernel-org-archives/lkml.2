Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750Ab2GKBMu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 21:12:50 -0400
Received: from atomicpeace.com ([50.116.19.59]:51300 "EHLO atomicpeace.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752817Ab2GKBMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 21:12:48 -0400
From: Tim Sally <tsally@atomicpeace.com>
To: tyhicks@canonical.com, dustin.kirkland@gazzang.com
Cc: ecryptfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tim Sally <tsally@atomicpeace.com>
Subject: [PATCH 0/1] Check for eCryptfs cipher support at mount time.
Date: Tue, 10 Jul 2012 21:05:50 -0400
Message-Id: <1341968751-28331-1-git-send-email-tsally@atomicpeace.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

eCryptfs will mount with any cipher supported by the crypto subsystem,
even if the cipher is not supported by eCryptfs itself. An error will
not occur until a write. This change checks for eCryptfs cipher
support at mount time and will not mount the filesystem if the cipher
is not supported.

The cipher name and blocksize are retrieved from ecryptfs_key_tfm
because it will assign a default block size upon creation if none
is specified in the mount options.

This issue originally reported by Tyler Hicks in 03/2009.
https://bugs.launchpad.net/ecryptfs/+bug/338914

Thanks,

Tim

Tim Sally (1):
  eCryptfs: check for eCryptfs cipher support at mount

 fs/ecryptfs/main.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

-- 
1.7.10.4

