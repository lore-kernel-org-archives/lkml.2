Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466Ab1J0SJz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 14:09:55 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:23386 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754225Ab1J0SJy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 14:09:54 -0400
Subject: [PATCH v3 0/3] SUNRPC: rcbind clients virtualization
To: Trond.Myklebust@netapp.com
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: linux-nfs@vger.kernel.org, xemul@parallels.com, neilb@suse.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bfields@fieldses.org, davem@davemloft.net, devel@openvz.org
Date: Thu, 27 Oct 2011 22:10:43 +0300
Message-ID: <20111027180824.20459.23219.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v3:
1) First two patches from previous version were squashed.

This patch-set was created in context of clone of git branch:
git://git.linux-nfs.org/projects/trondmy/nfs-2.6.git
and rebased on tag "v3.1".

This patch-set virtualizes rpcbind clients per network namespace context. IOW,
each network namespace will have its own pair of rpcbind clients (if they would
be created by request).

Note:
1) this patch-set depends on "SUNRPC: make rpcbind clients allocated and
destroyed dynamically" patch-set which has been send earlier.
2) init_net pointer is still used instead of current->nsproxy->net_ns,
because I'm not sure yet about how to virtualize services. I.e. NFS callback
services will be per netns. NFSd service will be per netns too from my pow. But
Lockd can be per netns or one for all. And also we have NFSd file system, which
is not virtualized yet.

The following series consists of:

---

Stanislav Kinsbursky (3):
      SUNRPC: move rpcbind internals to sunrpc part of network namespace context
      SUNRPC: optimize net_ns dereferencing in rpcbind creation calls
      SUNRPC: optimize net_ns dereferencing in rpcbind registering calls


 net/sunrpc/netns.h     |    5 ++
 net/sunrpc/rpcb_clnt.c |  103 ++++++++++++++++++++++++++----------------------
 2 files changed, 61 insertions(+), 47 deletions(-)

-- 
Signature
