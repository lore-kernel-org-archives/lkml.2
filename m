Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627Ab0GaF1s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 01:27:48 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43111 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003Ab0GaF1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 01:27:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=DWIV1Mn5F0+BYN9ovfHLIBxFTlhkMCsX6Von6/WY5T9FV5jq8K0aws2NhopfjTRbXx
         LB3gCP2Ccl8MNTo8CW2f/PATv60Er47Uv3y/FEl2TF9wxmyrwwDlkhniujsQGvp6JupE
         HspMrCVvEXEGmkRWu9gjKLbM1kow71DmzeSKo=
MIME-Version: 1.0
Date: Fri, 30 Jul 2010 23:27:46 -0600
Message-ID: <AANLkTimTMNY5y1tL4Jed=W29nH-OuV++nnL-1PHGQuAy@mail.gmail.com>
Subject: ll_rw_blk() Comments still in the code
From: Jeffrey Merkey <jeffmerkey@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function has been gone for a while and the code has some
inaccurate comments remaining.

[root@cloudstream linux-2.6.34.1]#
[root@cloudstream linux-2.6.34.1]# find . -name '*.c' -exec grep -H
ll_rw_blk {} \;
./fs/reiserfs/journal.c:                // since we're using ll_rw_blk
above, it might have skipped over
./drivers/s390/block/dasd.c: * Dasd request queue function. Called
from ll_rw_blk.c
./drivers/s390/char/tape_block.c: * Tape request queue function.
Called from ll_rw_blk.c
./block/blk-core.c:      * Request may not have originated from
ll_rw_blk. if not,
./block/elevator.c:              *   queue wasn't empty before this
request, ll_rw_blk
[root@cloudstream linux-2.6.34.1]# find . -name '*.h' -exec grep -H
ll_rw_blk {} \;
./include/linux/fs.h:#define BLKSECTSET _IO(0x12,102)/* set max
sectors per request (ll_rw_blk.c) */
./include/linux/fs.h:#define BLKSECTGET _IO(0x12,103)/* get max
sectors per request (ll_rw_blk.c) */
./include/linux/blkdev.h:        * ll_rw_blk doesn't touch it.
./usr/include/linux/fs.h:#define BLKSECTSET _IO(0x12,102)/* set max
sectors per request (ll_rw_blk.c) */
./usr/include/linux/fs.h:#define BLKSECTGET _IO(0x12,103)/* get max
sectors per request (ll_rw_blk.c) */
[root@cloudstream linux-2.6.34.1]#
[root@cloudstream linux-2.6.34.1]#
[root@cloudstream linux-2.6.34.1]#


Jeff Merkey
