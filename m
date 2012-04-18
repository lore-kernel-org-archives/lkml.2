Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085Ab2DRW62 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 18:58:28 -0400
Received: from mga02.intel.com ([134.134.136.20]:7546 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751320Ab2DRW61 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 18:58:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="134127951"
From: Jim Kukunas <james.t.kukunas@linux.intel.com>
To: neilb@suse.de
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Subject: arch/86: AVX RAID5 xor checksumming v1
Date: Wed, 18 Apr 2012 15:58:47 -0700
Message-Id: <1334789928-7238-1-git-send-email-james.t.kukunas@linux.intel.com>
X-Mailer: git-send-email 1.7.8.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Folks,

The following patch adds an AVX implementation of the RAID5 xor checksumming
functions.

This version differs from version 0, in that it:
	0) checks whether assembler supports AVX
	1) replaces __attribute__(aligned(32)) with __aligned(32)
	2) adds do/while(0); to macro blocks

Based on xor_speed, the AVX implementation appears to be ~32% faster than the
SSE implementation on my i7 2600:

        generic_sse: 15088.000 MB/sec
	avx: 19936.000 MB/sec

Thanks.


