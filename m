Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756676Ab2DTOTe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 10:19:34 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:23290 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756612Ab2DTOTc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 10:19:32 -0400
Subject: [PATCH 0/3] SUNRPC: three bugfixes for PipeFS event handling
To: bfields@fieldses.org, Trond.Myklebust@netapp.com
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org, devel@openvz.org
Date: Fri, 20 Apr 2012 18:18:59 +0400
Message-ID: <20120420141419.10848.84280.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These bugfixes were caught (or noticed) due to the following simple script:

======================================================================

#!/bin/bash
service rpcbind stop
service rpcidmapd stop
killall -TERM rpc.statd
umount /var/lib/nfs/rpc_pipefs
rmmod nfs
service rpcbind start
service nfs start
mount -t rpc_pipefs sunrpc /var/lib/nfs/rpc_pipefs

=======================================================================

The following series consists of:

---

Stanislav Kinsbursky (3):
      SUNRPC: skip clients with program without PipeFS entries
      SUNRPC: traverse clients tree on PipeFS event
      SUNRPC: set per-net PipeFS superblock before notification


 net/sunrpc/clnt.c     |   34 ++++++++++++++++++++++++++++------
 net/sunrpc/rpc_pipe.c |    3 ++-
 2 files changed, 30 insertions(+), 7 deletions(-)

