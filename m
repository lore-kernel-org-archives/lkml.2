Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757092Ab2ASRmb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 12:42:31 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:22340 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751800Ab2ASRma (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 12:42:30 -0500
Subject: [PATCH v2 0/5] SUNRPC: make caches network namespace aware
To: Trond.Myklebust@netapp.com
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: linux-nfs@vger.kernel.org, xemul@parallels.com, neilb@suse.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jbottomley@parallels.com, bfields@fieldses.org, davem@davemloft.net,
        devel@openvz.org
Date: Thu, 19 Jan 2012 21:42:13 +0400
Message-ID: <20120119173823.23767.91876.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2:
1) Fixed silly usage of unix gid cache template instead on per-net cache
instance.
2) Postfix "_template" was added to all caches templates to make sure, that no
misaunderstanding or direct usage of template object will happen in future.

One more step towards to "NFS in container".
With this patch set caches are allocated per network namespace.

The following series consists of:

---

Stanislav Kinsbursky (5):
      SUNRPC: cache creation and destruction routines introduced
      SUNRPC: create unix gid cache per network namespace
      SUNRPC: create GSS auth cache per network namespace
      SUNRPC: ip map cache per network namespace cleanup
      SUNRPC: generic cache register routines removed


 include/linux/sunrpc/cache.h       |    6 +
 include/linux/sunrpc/svcauth_gss.h |    2 
 net/sunrpc/auth_gss/auth_gss.c     |   21 +++++
 net/sunrpc/auth_gss/svcauth_gss.c  |  165 +++++++++++++++++++++++++-----------
 net/sunrpc/cache.c                 |   34 +++++--
 net/sunrpc/netns.h                 |    3 +
 net/sunrpc/sunrpc_syms.c           |   15 ++-
 net/sunrpc/svcauth_unix.c          |  126 +++++++++++++++------------
 8 files changed, 252 insertions(+), 120 deletions(-)

-- 
Signature
