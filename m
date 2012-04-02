Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989Ab2DBR6D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 13:58:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57563 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753391Ab2DBR57 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 13:57:59 -0400
Date: Mon, 2 Apr 2012 13:50:52 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Subject: 3.4rc1 btrfs IO problem ?
Message-ID: <20120402175052.GA8127@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, chris.mason@oracle.com,
	linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed something odd when I booted rc1 on my btrfs test box..

First I tried updating my git tree..

$ gp
error: cannot open .git/FETCH_HEAD: Input/output error
$ gp
remote: Counting objects: 5101, done.
remote: Compressing objects: 100% (546/546), done.
remote: Total 3764 (delta 3233), reused 3738 (delta 3208)
Receiving objects: 100% (3764/3764), 783.19 KiB | 195 KiB/s, done.
Resolving deltas: 100% (3233/3233), completed with 831 local objects.
fatal: fsync error on '.git/objects/pack/tmp_pack_gq3edw': Input/output error
fatal: index-pack failed

uh-oh. I looked in dmesg, nothing out of the ordinary (disks dying etc).

But anything that does IO seems to have serious issues..

$ fsx foo
truncating to largest ever: 0x13e76
truncating to largest ever: 0x2e52c
ftruncate1: 2e52c
dotruncate: ftruncate: Input/output error
Segmentation fault (core dumped)

3.3 is fine.

Thoughts ?

	Dave
