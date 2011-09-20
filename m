Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624Ab1ITKNt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 06:13:49 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:15164 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753479Ab1ITKNs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 06:13:48 -0400
Subject: [PATCH v4 0/8] SUNRPC: make rpcbind clients allocated and destroyed
	dynamically
To: Trond.Myklebust@netapp.com
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: linux-nfs@vger.kernel.org, xemul@parallels.com, neilb@suse.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bfields@fieldses.org, davem@davemloft.net
Date: Tue, 20 Sep 2011 14:13:32 +0400
Message-ID: <20110920101031.9861.18444.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v4:
1) creation and destruction on rpcbind clients now depends on service program
versions "vs_hidden" flag.

This patch is required for further RPC layer virtualization, because rpcbind
clients have to be per network namespace.
To achive this, we have to untie network namespace from rpcbind clients sockets.
The idea of this patch set is to make rpcbind clients non-static. I.e. rpcbind
clients will be created during first RPC service creation, and destroyed when
last RPC service is stopped.
With this patch set rpcbind clients can be virtualized easely.


The following series consists of:

---

Stanislav Kinsbursky (8):
      SUNRPC: introduce helpers for reference counted rpcbind clients
      SUNRPC: use rpcbind reference counting helpers
      SUNRPC: introduce svc helpers for prepairing rpcbind infrastructure
      SUNRPC: setup rpcbind clients if service requires it
      SUNRPC: cleanup service destruction
      NFSd: call svc rpcbind cleanup explicitly
      SUNRPC: remove rpcbind clients creation during service registering
      SUNRPC: remove rpcbind clients destruction on module cleanup


 fs/nfsd/nfssvc.c            |    2 +
 include/linux/sunrpc/clnt.h |    2 +
 include/linux/sunrpc/svc.h  |    1 +
 net/sunrpc/rpcb_clnt.c      |   85 ++++++++++++++++++++++++++++---------------
 net/sunrpc/sunrpc_syms.c    |    3 --
 net/sunrpc/svc.c            |   48 +++++++++++++++++++++++-
 6 files changed, 105 insertions(+), 36 deletions(-)

-- 
Signature
