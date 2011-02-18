Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558Ab1BRDpt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 22:45:49 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:35260 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821Ab1BRDpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 22:45:47 -0500
Date: Thu, 17 Feb 2011 21:45:42 -0600
From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: please, remove the abuse of vfs_path_lookup() in ecryptfs
Message-ID: <20110218034541.GE24444@boyd.l.tihix.com>
References: <20110217015350.GH22723@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110217015350.GH22723@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu Feb 17, 2011 at 01:53:50AM +0000, Al Viro <viro@ZenIV.linux.org.uk> wrote:
> 	commit 21edad32205e97dc7ccb81a85234c77e760364c8 (
> ecryptfs: dont call lookup_one_len to avoid NULL nameidata) is badly
> misguided.  The last thing we need is extra places where nameidata is
> passed around.

Thanks, Al. I reverted that patch and pushed it to
git://git.kernel.org/pub/scm/linux/kernel/git/ecryptfs/ecryptfs-2.6.git#next

I'll get a pull request together for Linus in the next day or two.

> 
> 	The current code is simply wrong - it's bypassing dcache
> lookups in new_lower_dentry().  Besides, abuse of vfs_path_lookup()
> here is a Bad Idea(tm).  No, filesystems are *not* allowed to die
> if ->d_revalidate()/->lookup()/->create() are called with NULL
> nameidata.

I fixed the eCryptfs d_revalidate, lookup, and create paths to not choke
when handed NULL nameidata. I don't think we would have ever received
NULL nameidata since we don't allow eCryptfs on eCryptfs or export to
NFS.

Tyler

