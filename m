Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614Ab2GIWRN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 18:17:13 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:43139 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876Ab2GIWRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 18:17:12 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: "Steven J. Magnani" <steve@digidescorp.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] fat (exportfs): reconnect file handles to evicted inodes/dentries
References: <1341342576-15394-1-git-send-email-steve@digidescorp.com>
	<1341342576-15394-3-git-send-email-steve@digidescorp.com>
	<87pq8bokcp.fsf@devron.myhome.or.jp>
	<1341606824.2214.14.camel@iscandar.digidescorp.com>
	<871ukobntl.fsf@devron.myhome.or.jp>
	<1341623782.2021.9.camel@iscandar>
	<87wr2g9kh3.fsf@devron.myhome.or.jp>
	<1341679286.2435.12.camel@iscandar>
	<87zk7bo6aq.fsf@devron.myhome.or.jp>
	<1341835422.2215.6.camel@iscandar.digidescorp.com>
	<87sjd1nj7s.fsf@devron.myhome.or.jp>
	<1341845277.2215.10.camel@iscandar.digidescorp.com>
	<87obnooqz7.fsf@devron.myhome.or.jp>
	<1341851223.2215.22.camel@iscandar.digidescorp.com>
	<1341853758.2215.34.camel@iscandar.digidescorp.com>
	<87bojooinr.fsf@devron.myhome.or.jp>
	<1341865572.31078.2.camel@iscandar.digidescorp.com>
	<877gucobya.fsf@devron.myhome.or.jp>
	<1341871431.1944.4.camel@iscandar>
Date: Tue, 10 Jul 2012 07:17:09 +0900
In-Reply-To: <1341871431.1944.4.camel@iscandar> (Steven J. Magnani's message
	of "Mon, 09 Jul 2012 17:03:51 -0500")
Message-ID: <87zk78mvfe.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Steven J. Magnani" <steve@digidescorp.com> writes:

>> Hm, not really, if the file handle is including parent ino. ext2 will
>> get the latest parent ino, because it checks parent of inode of file
>> handle.
>
> Can you point me to the code for this? The code I see looks pretty
> congruent to what I think the FAT code would be.
>
>> But if the file handle is including parent ino and we believe it is
>> parent, I think NFS server can be return the old parent. The difference
>> is the result of ->get_parent().
>
> I'm a little confused about which function we're discussing here.
> fat_get_parent() isn't called with a file handle. fat_fh_to_parent() is,
> but it is only called by exportfs_decode_fh() and I am reasonably sure
> that that function is handling the case you're concerned about.

Oh, you are right. I should discuss about it based on the new patch, and
only if there is new usage of file handle (e.g. parent->i_no).
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
