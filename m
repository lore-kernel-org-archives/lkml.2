Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758538Ab2GFVH7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 17:07:59 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:42181 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758507Ab2GFVH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 17:07:56 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: "Steven J. Magnani" <steve@digidescorp.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] fat (exportfs): reconnect file handles to evicted inodes/dentries
References: <1341342576-15394-1-git-send-email-steve@digidescorp.com>
	<1341342576-15394-3-git-send-email-steve@digidescorp.com>
	<87pq8bokcp.fsf@devron.myhome.or.jp>
	<1341606824.2214.14.camel@iscandar.digidescorp.com>
Date: Sat, 07 Jul 2012 06:07:50 +0900
In-Reply-To: <1341606824.2214.14.camel@iscandar.digidescorp.com> (Steven
	J. Magnani's message of "Fri, 06 Jul 2012 15:33:44 -0500")
Message-ID: <871ukobntl.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Steven J. Magnani" <steve@digidescorp.com> writes:

> On Wed, 2012-07-04 at 20:07 +0900, OGAWA Hirofumi wrote: 
>> Please don't add new lock_super() usage if it is not necessary. Almost
>> all of lock_super() just replaced lock_kernel() usage. It rather should
>> be removed in future.  Probably, this should use inode->i_mutex instead.
>> 
>> BTW, the above issue is same with all of directory read.
>
> I don't think there's really an alternative here. The cases addressed by
> this patch all involve walking on-disk structures via
> unofficial/temporary inodes created from information in the NFS handle
> (i.e., outside the normal inode creation paths). When this process is
> successful we end up with "official" connected inodes/dentries, but
> getting there is really a "bottom up" strategy instead of the usual "top
> down" approach.
>
> Because the "bottom up" method is lacking guarantees that "top down"
> takes for granted - i.e., that a cluster on disk that's supposed to be a
> directory actually *is* a directory -  I am adding some defensive code
> in the next spin of the patch.

I'm not sure what you meant. Where is the problem? ->get_name()? If so,
it has parent dentry parameter. What is the wrong if we take
mutex_lock(parent->d_inode)?

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
