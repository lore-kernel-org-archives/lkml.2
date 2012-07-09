Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751608Ab2GIQKZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 12:10:25 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:43057 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771Ab2GIQKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 12:10:23 -0400
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
Date: Tue, 10 Jul 2012 01:10:20 +0900
In-Reply-To: <1341845277.2215.10.camel@iscandar.digidescorp.com> (Steven
	J. Magnani's message of "Mon, 09 Jul 2012 09:47:57 -0500")
Message-ID: <87obnooqz7.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Steven J. Magnani" <steve@digidescorp.com> writes:

> On Mon, 2012-07-09 at 22:43 +0900, OGAWA Hirofumi wrote: 
>> "Steven J. Magnani" <steve@digidescorp.com> writes:
>> 
>> >> We need the key, possible key is - if it is only directory, FAT may be
>> >> able to use i_start as additional search key.
>> >
>> > Interesting idea. I think this, and reformulating the FAT NFS file
>> > handle to include the parent's i_ino, will greatly simplify (and speed
>> > up) the code.
>> 
>> Does it work even if the inode was rename()'ed?
>
> AFAICT. I don't see why it wouldn't; on a rename, the inode's i_pos
> changes but its i_ino stays the same, right?

If the inode is not on cache anymore, is there the possibility that
selects the wrong parent? IIRC, NFS Server can be rebooted at any time
while the client using the same file handle.

> Do you have any objection to making the use of a directory logstart
> cache a mount option that defaults to off? It seems a shame to penalize
> everyone - particularly embedded systems - with the overhead of such a
> cache when FAT-backed-NFS seems to be such a small percentage of use
> cases.

I'm not sure what did it mean. It means to remove i_logstart from NFS
file handle?
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
