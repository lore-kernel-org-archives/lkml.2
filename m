Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757283Ab2KIAPH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 19:15:07 -0500
Received: from dupo.coraid.com ([208.71.232.133]:49466 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753722Ab2KIAPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 19:15:06 -0500
Message-Id: <cover.1352410985.git.ecashin@coraid.com>
From: Ed Cashin <ecashin@coraid.com>
Subject: [PATCH 0/8] aoe: improved network congestion handling from v60 to v64+
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ecashin@coraid.com
From: Ed Cashin <ecashin@coraid.com>
X-Mailer: nedmail
Date: Thu, 8 Nov 2012 19:14:18 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series is based on linux-next/akpm from 8 Nov, commit
db3846344ad57222.

Ed L. Cashin (8):
  aoe: avoid running request handler on plugged queue
  aoe: provide ATA identify device content to user on request
  aoe: improve network congestion handling
  aoe: err device: include MAC addresses for unexpected responses
  aoe: manipulate aoedev network stats under lock
  aoe: use high-resolution RTTs with fallback to low-res
  aoe: commands in retransmit queue use new destination on failure
  aoe: update driver-internal version to 64+

 drivers/block/aoe/aoe.h    |   24 +++-
 drivers/block/aoe/aoeblk.c |   30 ++++
 drivers/block/aoe/aoecmd.c |  317 +++++++++++++++++++++++++++++++-------------
 drivers/block/aoe/aoedev.c |   38 ++++--
 4 files changed, 296 insertions(+), 113 deletions(-)

