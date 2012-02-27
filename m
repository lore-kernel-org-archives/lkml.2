Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617Ab2B0Ns7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 08:48:59 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:18390 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113Ab2B0Ns6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 08:48:58 -0500
Subject: [PATCH 0/4] SUNRPC: several fixes around PipeFS objects
To: Trond.Myklebust@netapp.com
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: linux-nfs@vger.kernel.org, xemul@parallels.com, neilb@suse.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jbottomley@parallels.com, bfields@fieldses.org, davem@davemloft.net,
        devel@openvz.org
Date: Mon, 27 Feb 2012 17:48:43 +0400
Message-ID: <20120227134623.13371.61185.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First two pathes fixes lockdep warnings and next two - dereferencing of
released pipe data on eventfd close.

The following series consists of:

---

Stanislav Kinsbursky (4):
      SUNRPC: replace per-net client lock by rw mutex
      NFS: replace per-net client lock by mutex
      SUNRPC: check RPC inode's pipe reference before dereferencing
      SUNRPC: move waitq from RPC pipe to RPC inode


 fs/nfs/client.c                    |   36 +++++++++---------
 fs/nfs/idmap.c                     |    4 +-
 fs/nfs/netns.h                     |    2 +
 include/linux/sunrpc/rpc_pipe_fs.h |    2 +
 net/sunrpc/clnt.c                  |   16 ++++----
 net/sunrpc/netns.h                 |    2 +
 net/sunrpc/rpc_pipe.c              |   71 +++++++++++++++++++++++-------------
 net/sunrpc/sunrpc_syms.c           |    2 +
 8 files changed, 77 insertions(+), 58 deletions(-)

