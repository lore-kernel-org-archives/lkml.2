Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445Ab2K1RoF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 12:44:05 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:30180 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754008Ab2K1RoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 12:44:01 -0500
From: Rafal Krypa <r.krypa@samsung.com>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: linux-security-module@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rafal Krypa <r.krypa@samsung.com>
Subject: [PATCHv2] Smack: add support for modification of existing rules
Date: Wed, 28 Nov 2012 18:43:28 +0100
Message-id: <1354124609-16829-1-git-send-email-r.krypa@samsung.com>
X-Mailer: git-send-email 1.7.10.4
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch introduces in-place modification of Smack rules.
Until now Smack supported only overwriting of existing rules.
To change permitted access for a given subject and object, user had
to read list of rules to get current accesses, modify it and write
modified rule back to kernel. This way was inefficient, non-atomic
and unnecessarily difficult.
New interface is intended to ease such modifications.

Changes in v2:
- dropped patches for smackfs seq list operations
- changed modification approach to simple integer assignment

Rafal Krypa (1):

  Smack: add support for modification of existing rules

 Documentation/security/Smack.txt |   11 ++
 security/smack/smackfs.c         |  249 ++++++++++++++++++++++++++------------
 2 files changed, 181 insertions(+), 79 deletions(-)

-- 
1.7.10.4

