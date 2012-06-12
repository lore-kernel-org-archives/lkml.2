Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154Ab2FLMm4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 08:42:56 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:36959 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875Ab2FLMmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 08:42:55 -0400
Date: Tue, 12 Jun 2012 08:35:24 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, jaxboe@fusionio.com
Cc: xen-devel@lists.xensource.com, wdauchy@gmail.com,
        stefano.stabellini@eu.citrix.com, jbeulich@suse.com
Subject: [GIT PULL] (xen) stable/for-jens-3.5 for 3.5-rc2..
Message-ID: <20120612123524.GA559@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Jens,

Please pull:

 git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-jens-3.5

it has two critical fixes to deal with 32/64 guest/host combinations
when sending DISCARD commands. They weren't properly sent resulting
in the guest crashing (https://bugzilla.redhat.com/show_bug.cgi?id=824641)
The fix is in the backend (blkback) and the frontend has some extra
WARN_ON added to diagnose similar issues like this in the future.

Or if you prefer - I can stick those two patches in my tree and
send them to Linus in my git pull this Friday with your Ack-ed by tag.

Thanks!

Konrad Rzeszutek Wilk (2):
      xen/blkback: Copy id field when doing BLKIF_DISCARD.
      xen/blkfront: Add WARN to deal with misbehaving backends.

 drivers/block/xen-blkback/common.h |    2 +
 drivers/block/xen-blkfront.c       |   58 ++++++++++++++++++++++++++++-------
 2 files changed, 48 insertions(+), 12 deletions(-)
