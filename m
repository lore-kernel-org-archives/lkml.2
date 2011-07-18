Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060Ab1GRTXo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 15:23:44 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:59933 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921Ab1GRTXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 15:23:42 -0400
Date: Mon, 18 Jul 2011 20:23:39 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        Nick Piggin <npiggin@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] vfs: fix race in rcu lookup of pruned dentry
Message-ID: <20110718192339.GH11013@ZenIV.linux.org.uk>
References: <CA+55aFxEGKgx+_xy+Lnt=84wRzE9TyznL3VCNSqWs7HC_H35_A@mail.gmail.com>
 <alpine.LSU.2.00.1107171641130.1274@sister.anvils>
 <20110718002524.GU11013@ZenIV.linux.org.uk>
 <alpine.LSU.2.00.1107171740260.1327@sister.anvils>
 <20110718020818.GW11013@ZenIV.linux.org.uk>
 <CA+55aFwXgcWxvAz7w1f_HYyzdm9b9EBJfrWhF1FW7EA3zpbJPg@mail.gmail.com>
 <CA+55aFxKRw8NxcHKzsSeCX3ud6eDrcQvAX+LMQOUT4p5TPLp5g@mail.gmail.com>
 <20110718182030.GF11013@ZenIV.linux.org.uk>
 <CA+55aFw+RwscYUocP0WYWTU=F+Udx+AsjMA0i63-D-y3iZKCTQ@mail.gmail.com>
 <20110718192038.GG11013@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110718192038.GG11013@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 18, 2011 at 08:20:38PM +0100, Al Viro wrote:

> Hmm...  Could you pull #for-linus (or #for-linus2, for that matter - same
> plus cifs_get_root() fix) first?

FWIW, diffstat and changelog for #for-linus2:
 fs/ceph/mds_client.c |   19 ++++++++-
 fs/cifs/cifsfs.c     |  100 ++++++++++++++-----------------------------------
 fs/cifs/dir.c        |   13 ++++++-
 fs/cramfs/inode.c    |   22 ++++++-----
 fs/exofs/super.c     |    2 +-
 fs/hppfs/hppfs.c     |   31 ++++-----------
 fs/ufs/namei.c       |   12 ++----
 7 files changed, 83 insertions(+), 116 deletions(-)
Al Viro (8):
      cifs: build_path_from_dentry() race fix
      ceph analog of cifs build_path_from_dentry() race fix
      fix exofs ->get_parent()
      ufs should use d_splice_alias()
      cramfs: get_cramfs_inode() returns ERR_PTR() on failure
      hppfs: fix dentry leak
      hppfs_lookup(): don't open-code lookup_one_len()
      Fix cifs_get_root()
