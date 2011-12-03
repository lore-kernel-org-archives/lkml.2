Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318Ab1LCMTY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Dec 2011 07:19:24 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40005 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754893Ab1LCMTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Dec 2011 07:19:23 -0500
MIME-Version: 1.0
Date: Sat, 3 Dec 2011 13:19:22 +0100
Message-ID: <CAOY=C6HuVEYpkap3dVmgmC7d+SDhvO-zc79RvCvkZCham3MiXg@mail.gmail.com>
Subject: Oops in d_instantiate (fs/cache.c)
From: Stijn Devriendt <highguy@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I've had 2 occasions where udev crashed during bootup.
The second time carried a kernel log where the following line
"BUG_ON(!list_empty(&entry->d_alias))"
in d_instantiate is triggered when udev is attempting to
create a symlink in /dev (which is tmpfs/shmem).

I've tried reproducing this by doing as udev does:
- create temporary symlink
- move temporary symlink into place
in a tight loop (multiple processes) while multiple
other processes were removing the symlink in a
tight loop.
A third script was flushing the dentry/inode cache
every so often using drop_caches.
All to no avail.

I've been digging around in the kernel sources,
but I'm not sure what the d_alias field means
and what the actual case is the BUG_ON is
meant to catch. I'd like to be able to find a way
to reproduce this, because so far it's happened only
twice in 2 weeks over multiple systems doing
many reboots in a testing setup.
Can someone explain this to me in short?

Thanks,
Stijn
