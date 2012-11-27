Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687Ab2K0Rkh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 12:40:37 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:59325 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755511Ab2K0Rkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 12:40:35 -0500
From: Rafal Krypa <r.krypa@samsung.com>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: linux-security-module@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rafal Krypa <r.krypa@samsung.com>
Subject: [PATCH 0/3] Smack: add support for modification of existing rules,
 restructure rules list showing in smackfs
Date: Tue, 27 Nov 2012 18:40:18 +0100
Message-id: <1354038021-28324-1-git-send-email-r.krypa@samsung.com>
X-Mailer: git-send-email 1.7.10.4
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following three patches are intended to introduce in-place
modification of Smack rules. Until now Smack supported only
overwriting of existing rules. To change permitted access for a given
subject and object, user had to read list of rules to get current
accesses, modify it and write modified rule back to kernel. This way
was inefficient, non-atomic and unnecessarily difficult.
New interface is intended to ease such modifications.

I have prepared three patches:
1. Use RCU functions and read locking in smackfs seq list operations

Because rule lists will now get modified by list_replace_rcu(), this
one is intended to assure RCU reader critical sections in smackfs.

2. Remove global master list of rules

This is for avoiding having to modify rules in two places (per subject
list and the global list). The master list was redundant and kept up
for backward compatibility with previous smackfs seq operations code.

3. Add support for modification of existing rules

The actual patch with new interface.
A previous version of this one has posted previously
(http://thread.gmane.org/gmane.linux.documentation/6759),
but was proven to be wrong.

Rafal Krypa (3):
  Smack: use RCU functions and read locking in smackfs seq list
    operations
  Smack: remove global master list of rules
  Smack: add support for modification of existing rules

 Documentation/security/Smack.txt |   11 ++
 security/smack/smackfs.c         |  362 ++++++++++++++++++++++++--------------
 2 files changed, 239 insertions(+), 134 deletions(-)

-- 
1.7.10.4

