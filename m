Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752919Ab1K3SQm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 13:16:42 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:42769 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542Ab1K3SQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 13:16:37 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        Ian.Campbell@citrix.com, lidongyang@novell.com, JBeulich@novell.com
Cc: axboe@kernel.dk
Subject: [PATCH] Xen block improvements for 3.3 [secure-discard flag](v1)
Date: Wed, 30 Nov 2011 13:15:52 -0500
Message-Id: <1322676956-15691-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.3
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A020206.4ED672FD.00EB,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Way back in 3.2 time-frame we worked out some of these patches and how
to improve the code. I don't think I had posted them after we chatted
about what to do or how to do it...

Either way, posting them here to kick-start the conversation and
see if we can improve these patches some more. I've been running
with these patches for some time now so I am quite confident that I got
the 32-bit to 64-bit structure padding worked out.

(Ran it with old guests/new guests/32-bit/64-bit/Linux/Windows
combination. Around 18 different scenarios).

Konrad Rzeszutek Wilk (3):
      xen/blk[front|back]: Squash blkif_request_rw and blkif_request_discard together
      xen/blk[front|back]: Enhance discard support with secure erasing support.
      xen/blkback: Move processing of BLKIF_OP_DISCARD from dispatch_rw_block_io

Li Dongyang (1):
      xen-blkback: convert hole punching to discard request on loop devices

 drivers/block/xen-blkback/blkback.c |   84 ++++++++++++++--------------------
 drivers/block/xen-blkback/common.h  |   67 ++++++++++++++++------------
 drivers/block/xen-blkback/xenbus.c  |   12 +++++
 drivers/block/xen-blkfront.c        |   77 +++++++++++++++++++++-----------
 include/xen/interface/io/blkif.h    |   40 ++++++++++++++---
 5 files changed, 169 insertions(+), 111 deletions(-)

