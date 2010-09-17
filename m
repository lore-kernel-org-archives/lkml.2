Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161Ab0IQNOi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 09:14:38 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:50975 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072Ab0IQNOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 09:14:37 -0400
From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: vaurora@redhat.com, neilb@suse.de, viro@zeniv.linux.org.uk
Subject: Re: [PATCH 2/6] vfs: make i_op->permission take a dentry instead of an inode
In-Reply-To: <20100903134148.908403931@szeredi.hu>
References: <20100903134116.039612691@szeredi.hu> <20100903134148.908403931@szeredi.hu>
User-Agent: Notmuch/0.3.1-58-g6607fd6 (http://notmuchmail.org) Emacs/24.0.50.1 (i686-pc-linux-gnu)
Date: Fri, 17 Sep 2010 18:44:09 +0530
Message-ID: <m31v8stsv2.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 03 Sep 2010 15:41:18 +0200, Miklos Szeredi <miklos@szeredi.hu> wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Like most other inode operations ->permission() should take a dentry
> instead of an inode.  This is necessary for filesystems which operate
> on names not on inodes.
> 

This change will also help 9P patch series i am doing 
http://article.gmane.org/gmane.linux.kernel/1032788

Currently ACL values are fetched from the server as a part of inode
initialization. We can't do it in inode operations->permission because
we need dentry to do 9P operations. Having inode operations->permission
take a dentry instead of an inode help there.

-aneesh

