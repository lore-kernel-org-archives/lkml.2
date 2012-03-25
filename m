Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697Ab2CYRlG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 13:41:06 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:44584 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754345Ab2CYRlF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 13:41:05 -0400
From: Arkadiusz =?utf-8?q?Mi=C5=9Bkiewicz?= <a.miskiewicz@gmail.com>
To: Vasiliy Kulikov <segoon@openwall.com>
Subject: Re: [PATCH] proc: fix mount -t proc -o AAA
Date: Sun, 25 Mar 2012 19:40:58 +0200
User-Agent: KMail/1.13.7 (Linux/3.3.0-06946-gf1d38e4; KDE/4.8.1; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Alexey Dobriyan <adobriyan@gmail.com>
References: <201203220903.15360.a.miskiewicz@gmail.com> <201203250924.06908.a.miskiewicz@gmail.com> <20120325153612.GC4391@albatros>
In-Reply-To: <20120325153612.GC4391@albatros>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201203251940.58668.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 25 of March 2012, Vasiliy Kulikov wrote:
> On Sun, Mar 25, 2012 at 09:24 +0200, Arkadiusz Miśkiewicz wrote:
> > but there is another problem - unmounting it and mounting without options
> > causes old option to persist:
> > 
> > # mount none /proc -t proc -o hidepid=2
> > # umount /proc
> > # mount none /proc -t proc
> > # grep "/proc" /proc/mounts
> > none /proc proc rw,relatime,hidepid=2 0 0
> > 
> > There should be no hidepid=2 now.
> 
> No, that's an expected behaviour.
> 
> Procfs is a special filesystem.  Mount options are not reset on each
> mount(2) as you can mount procfs multiple times at different mount points
> (/proc/, /aaa/proc/, etc.).  Each time you add mount options they are
> applied to _each_ mount point because there is no per-mount point sb, but
> there is a per pid_ns superblock: pid_ns itself.  All options are stored
> at pid_ns.
> 
> When you mount it another time without any option nothing should change
> at the old mount points.  When you umount the last mount point all mount
> options are still stored.  When you mount it again old options are used
> (unless you override them).

I wonder if it should support noxx options then (like nogid, nohidepid) ? 

-- 
Arkadiusz Miśkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
