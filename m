Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013Ab2GINn1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 09:43:27 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:43015 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753664Ab2GINnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 09:43:25 -0400
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
Date: Mon, 09 Jul 2012 22:43:19 +0900
In-Reply-To: <1341835422.2215.6.camel@iscandar.digidescorp.com> (Steven
	J. Magnani's message of "Mon, 09 Jul 2012 07:03:42 -0500")
Message-ID: <87sjd1nj7s.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Steven J. Magnani" <steve@digidescorp.com> writes:

>> How do you prevent to modify or free the those inode/blocks from other
>> path?  Yeah, it is racy. And if races is not solved, that's simply wrong
>> and not solution.
>> 
>> Although I'm not thinking deeply about NFS support on FAT. Just a idea,
>> the one of possible solutions would be register it to hash, and find it
>> on all path. So, all path will use same inode and lock.
>> 
>> We need the key, possible key is - if it is only directory, FAT may be
>> able to use i_start as additional search key.
>
> Interesting idea. I think this, and reformulating the FAT NFS file
> handle to include the parent's i_ino, will greatly simplify (and speed
> up) the code.

Does it work even if the inode was rename()'ed?
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
