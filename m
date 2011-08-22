Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671Ab1HVQDU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 12:03:20 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:35513 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294Ab1HVQDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 12:03:18 -0400
Date: Mon, 22 Aug 2011 12:02:59 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jens Axboe <jaxboe@fusionio.com>, axboe@kernel.dk,
        linux-kernel@vger.kernel.org
Cc: joe.jin@oracle.com
Subject: [GIT PULL] (xen) stable/for-jens for your 3.1-rc2 bugfix branch
Message-ID: <20110822160259.GB24763@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4E527DBD.0051:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Jens,

Please git pull the following branch:

 git pull git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-jens

I've two bug-fixes - on that just fixes indentation and comments and a more curious
one: when instructing the backend to remove a mounted disk from a guest it would correctly
refuse but also change the state as if it had removed it. Then when shutting down the guest,
the guest would hang as the backend states was removed (ooops). The fix is in the backend to
not remove (and move to the remove state) unless the frontend has really unmounted the disk.

The two patches are based off git commit ea5e116162b7e0cf83a2b8a273440514404604de
Konrad Rzeszutek Wilk (1):
    xen/blkback: Make description more obvious.

which you pulled for 3.1-rcX (and is now in Linus's master).

 drivers/block/xen-blkback/common.h |    2 +-
 drivers/block/xen-blkback/xenbus.c |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

Joe Jin (2):
      xen-blkback: Don't disconnect backend until state switched to XenbusStateClosed.
      xen-blkback: fixed indentation and comments

P.S.
I dropped a patch from the branch and when doing the 'git rebase' it modified the dates
of the two patches - rest assured - they have been in #linux-next and been tested since
at least seven days ago:
http://git.kernel.org/?p=linux/kernel/git/konrad/xen.git;a=shortlog;h=refs/heads/linux-next
