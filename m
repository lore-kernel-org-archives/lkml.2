Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225Ab0FTNWH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 09:22:07 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35872 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754054Ab0FTNWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 09:22:04 -0400
Message-ID: <4C1E1602.7080700@alessandroguido.name>
Date: Sun, 20 Jun 2010 15:22:10 +0200
From: Alessandro Guido <ag@alessandroguido.name>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.4) Gecko/20100619 Thunderbird/3.1
MIME-Version: 1.0
Newsgroups: gmane.linux.redhat.security.audit,gmane.linux.kernel,gmane.linux.file-systems
To: "Justin P. Mattock" <justinmattock@gmail.com>
CC: linux-kernel@vger.kernel.org, zippel@linux-m68k.org,
       linux-fsdevel@vger.kernel.org, rusty@rustcorp.com.au,
       linux-audit@redhat.com
Subject: Re: [PATCH 3/6]cifs Fix variable not set warnings
References: <1276288869-16815-1-git-send-email-justinmattock@gmail.com> <1276288869-16815-4-git-send-email-justinmattock@gmail.com>
In-Reply-To: <1276288869-16815-4-git-send-email-justinmattock@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ...
> @@ -734,7 +733,6 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
>   			direntry->d_op =&cifs_dentry_ops;
>   		d_add(direntry, newInode);
>   		if (posix_open)
> -			filp = lookup_instantiate_filp(nd, direntry, NULL);
>   		/* since paths are not looked up by component - the parent
>   		   directories are presumed to be good here */
>   		renew_parental_timestamps(direntry);
> ...

This is wrong, now "renew_parental_timestamps(direntry)" is in the if body.


