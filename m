Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751771Ab1API6K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 03:58:10 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60986 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101Ab1API6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 03:58:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:content-type;
        b=w0XArIhpGkxsMV+JJGBUKYE5Uebel37tIp1fEeCYx0MDS/V9arr9aTnGjG/Pbjd0ao
         EX89ciOWu/OaNLtKC/8NkibTFLqcILUDIs53FiWWPpejNOUpuz3S4GOU+KohbN/kUWpO
         ZkwyhffiWnqsaxhcl6qo35eyBR02OGcUiX4EE=
MIME-Version: 1.0
From: Andrey Vul <andrey.vul@gmail.com>
Date: Sun, 16 Jan 2011 03:57:43 -0500
Message-ID: <AANLkTimE0uMmh7fQbZptwxDvvfxLqaVjsSEJpghAnUUL@mail.gmail.com>
Subject: jfs and ESTALE
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

How come, during fs corruption, some files on a jfs volume, ESTALE on
access? Does the fs mark dirty inodes  in need of fsck  and ESTALES
access until a consistent state is available?
Also, is there a way to disable the kernel from guessing the rootfs
type by explicitly specificying the fstype? Suppose the primary
superblock is damaged but the the other ones are all fine and mount -o
ro -t jfs succeeds. There  are times when I just don't want to fuck
with a livecd just to fsck / so that int mounts and init can run. Is
there a way to go from:
determine_fs_type
bad primay superblock
panic

to:
determine_fs_type
bad primary superblock
get fstype from cmdline
use alt superblock
run init
?

The discussion of alt superblocks came up when I went to the cs admin
office to get a livecd in order to fsck /. And they placated my fears
of having to grep [dd if=/dev/sda5 of=/mnt/backup/root.bin] to get the
important lines from /etc (my back ups are far too old) by stating
that ext2/3 has alt superblocks at regular intervals.JFS also has it
by implication, since ext2/3 is pretty much a subset of every
journaled fs in linux (counterexamples probably exist - I couldn't
care less).
--
001100 Andrey "m05hbear" Vul
010010
011110 andrey at moshbear dot net
100001 andrey dot vul at gmail
101101 416XXXXXXX
110011

Today's quote:
[ ] Obsolete code offends me.
[ ] Be aware of [ ] Murphy's, [ ] Muphry's Law.
[ ] Use [ ] Occam's, [ ] Hanlon's razor.
[ ] Greenspun's Tenth Rule.
[ ] Sturgeon's Law, [ ] Pareto principle.
[ ] RTFM, [ ] RTF[__]
[ ] [___]
