Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318Ab0F3JqF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 05:46:05 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:24018 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273Ab0F3JqB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 05:46:01 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=1 a=_meyTIPSnzEA:10 a=ygRHs6EKU7oA:10 a=VphdPIyG4kEA:10
 a=kj9zAlcOel0A:10 a=c23vf5CSMVc0QQz9B4a6RA==:17 a=WuWbhNWRJEFkVPsS4pwA:9
 a=ag-LXmlOxWIch3TgJvifVdvUpMQA:4 a=CjuIK1q_8ugA:10
Subject: Re: [PATCH 3/3] Add a pair of system calls to make extended file stats available [ver #2]
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <20100630011712.18960.3723.stgit@warthog.procyon.org.uk>
Date: Wed, 30 Jun 2010 03:45:59 -0600
Cc: viro@ZenIV.linux.org.uk, smfrench@gmail.com, jlayton@redhat.com,
       mcao@us.ibm.com, aneesh.kumar@linux.vnet.ibm.com,
       linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, samba-technical@lists.samba.org,
       sjayaraman@suse.de, linux-ext4@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <B82FC7EE-93D2-4D86-906D-5D6AFA502709@dilger.ca>
References: <20100630011656.18960.4255.stgit@warthog.procyon.org.uk> <20100630011712.18960.3723.stgit@warthog.procyon.org.uk>
To: David Howells <dhowells@redhat.com>
X-Mailer: Apple Mail (2.1078)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-06-29, at 19:17, David Howells wrote:
> int ext4_getattr(struct vfsmount *mnt, struct dentry *dentry,
> 		 struct kstat *stat)
> {
> +	if (S_ISDIR(inode->i_mode)) {
> +		stat->result_flags |= XSTAT_QUERY_DATA_VERSION;
> +		stat->data_version = inode->i_version;
> +	}

Note that when ext4 is mounted with the "i_version" option that the i_version field is also updated on regular files, for use by NFSv4.  See, for example, ext4_mark_iloc_dirty().

I had a hard time finding this, even though I knew it was there somewhere, because it isn't modifying "i_version" directly, but rather calling a helper function inode_inc_iversion().

It probably makes sense to always return i_version, unless it is 0.

Cheers, Andreas





