Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933404Ab2AKBbe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 20:31:34 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:44834 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932469Ab2AKBba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 20:31:30 -0500
Date: Wed, 11 Jan 2012 01:31:27 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Sage Weil <sage@newdream.net>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alex Elder <elder@dreamhost.com>
Subject: Re: linux-next: manual merge of the ceph tree with Linus' tree
Message-ID: <20120111013127.GE23916@ZenIV.linux.org.uk>
References: <20120111122744.7db3bfb91d79b1307db02228@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120111122744.7db3bfb91d79b1307db02228@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 11, 2012 at 12:27:44PM +1100, Stephen Rothwell wrote:
> Hi Sage,
> 
> Today's linux-next merge of the ceph tree got a conflict in
> fs/ceph/super.c between commit 3c5184ef1216 ("ceph: d_alloc_root() may
> fail") from Linus' tree and commit 26d913cdd955 ("ceph: always initialize
> the dentry in open_root_dentry()") from the ceph tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.

Ahem...  

>  +			root = d_obtain_alias(inode);
>  +		}
> + 		ceph_init_dentry(root);

What will happen if dentry returned by d_obtain_alias() had already existed?
