Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178Ab0JTSlH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 14:41:07 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:38767 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755091Ab0JTSlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 14:41:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=JYEVmLtAcp24Ze00DBFOTY3Uz14Q+FDayQv0zvjVb9dbyapX4Betiv231/eIvQwTpp
         oeQwUWFE7VS0COZZNB6GoninuY6skOP+uE6sJCc1+gEEQpbIi3k//3TGNN0KLsVtJaX4
         rwk4+UudxHCGx2lb562I7hkiNIFOXKC/ASDo8=
MIME-Version: 1.0
Date: Wed, 20 Oct 2010 13:41:03 -0500
Message-ID: <AANLkTim_fmTFr3gPAXE9Q77nzKxreOHyU7JXamKfohxv@mail.gmail.com>
Subject: one or more brain cells staggering towards 64 bit inode numbers
From: David Nicol <davidnicol@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fs.h contains, in part

struct inode {
	struct hlist_node	i_hash;
	struct list_head	i_list;		/* backing dev IO list */
	struct list_head	i_sb_list;
	struct list_head	i_dentry;
	unsigned long		i_ino;
	atomic_t		i_count;
	unsigned int		i_nlink;
	uid_t			i_uid;
	gid_t			i_gid;
	dev_t			i_rdev;
	unsigned int		i_blkbits;
	u64			i_version;
	loff_t			i_size;



how much chaos would ensue if the inode number would change to a u64?
Aside from, of course, having to recompile anything
file-system-related on a 32-bit system to use the resulting kernel?
Probably better to do an #ifdef based on sizeof that member and zig or
zag depending.



-- 
"In one instance, a rai being transported by canoe was accidentally
dropped and sunk to the sea floor. Although it was never seen again,
everyone agreed that the rai must still be there, so it continued to
be transacted as genuine currency" -- Wikipedia
