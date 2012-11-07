Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570Ab2KGKCd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 05:02:33 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:32661 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754508Ab2KGKCc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 05:02:32 -0500
Subject: [PATCH 0/4] IPC: CRIU enhancements fixes and cleanup
To: akpm@linux-foundation.org
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: ebiederm@xmission.com, devel@openvz.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, jmorris@namei.org
Date: Wed, 07 Nov 2012 13:04:49 +0300
Message-ID: <20121107100317.22846.94715.stgit@localhost.localdomain>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set simplifies message queue copy feature and clean up it's
implementation.
It also adds some debug and fixes an issue, when copy_msg() fails. In this
case error have to returned instead of breaking messages loop, because error
message pointer is interpreted as -EAGAIN in current implemetation of further
message handling.

The following series implements...

---

Stanislav Kinsbursky (4):
      ipc: simplify free_copy() call
      ipc: convert prepare_copy() from macro to function
      ipc: simplify message copying
      ipc: add more comments to message copying related code


 ipc/msg.c     |   55 +++++++++++++++++++++++++++++++++----------------------
 ipc/msgutil.c |    5 +++++
 2 files changed, 38 insertions(+), 22 deletions(-)


