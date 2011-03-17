Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755748Ab1CQWm6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 18:42:58 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60383 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755664Ab1CQWm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 18:42:57 -0400
Date: Thu, 17 Mar 2011 22:42:52 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Tony Luck <tony.luck@intel.com>
Cc: Xiaotian Feng <xtfeng@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: Some fixes for pstore (Was Re: [git pull] mnt_devname queue)
Message-ID: <20110317224252.GC22723@ZenIV.linux.org.uk>
References: <20110316235608.GY22723@ZenIV.linux.org.uk>
 <AANLkTimF9ExskxBmebk7X2=g5S6OK5vAa05G1cgeVVCP@mail.gmail.com>
 <20110317072344.GZ22723@ZenIV.linux.org.uk>
 <AANLkTin=5jSzZKXLL=A+dbRn1jB+tPg56LmjthzC02ui@mail.gmail.com>
 <20110317104434.GB22723@ZenIV.linux.org.uk>
 <4d827eae305473e2bf@agluck-desktop.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4d827eae305473e2bf@agluck-desktop.sc.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 17, 2011 at 02:35:42PM -0700, Tony Luck wrote:
>  	mutex_unlock(&root->d_inode->i_mutex);
>  
> -	if (!pstore_writefile(inode, dentry, data, size))
> -		goto fail_write;
> +	memcpy(private->data, data, size);
> +	inode->i_size = private->size = size;
>  
>  	inode->i_private = private;

Better move that before d_add()

>  	if (IS_ERR(root))
> -		return -ENOMEM;
> -
> -	mnt->mnt_root = root;
> -	mnt->mnt_sb = root->d_sb;
> -	pstore_mnt = mnt;
> +		return root;
>  
> -	return 0;
> +	return root;

*blink*
	if (IS_ERR(root))
		return root;
	return root;

... or am I misreading the patch?
