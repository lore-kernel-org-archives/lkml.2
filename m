Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698Ab0EELTS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 07:19:18 -0400
Received: from smtp.nokia.com ([192.100.105.134]:16502 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105Ab0EELTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 07:19:17 -0400
Subject: Re: [PATCH] mtd: nand_base: Extend NAND flash detection to new MLC
 chips
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Kevin Cernekee <cernekee@gmail.com>
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <430ce15d6a65533b5c3677b02498e5ff2e41c78c@localhost.localdomain>
References: <430ce15d6a65533b5c3677b02498e5ff2e41c78c@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 May 2010 14:18:46 +0300
Message-ID: <1273058326.3702.174.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 05 May 2010 11:19:07.0736 (UTC) FILETIME=[C7321580:01CAEC44]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-03 at 17:46 -0700, Kevin Cernekee wrote:
> Some of the newer MLC devices have a 6-byte ID sequence in which
> several field definitions differ from older chips in a manner that is
> not backward compatible.  For instance:
> 
> Samsung K9GAG08U0M (5-byte sequence): ec d5 14 b6 74
> 4th byte, bits 1:0 encode the page size: 0=1KiB, 1=2KiB, 2=4KiB, 3=8KiB
> 4th byte, bits 5:4 encode the block size: 0=64KiB, 1=128KiB, ...
> 4th byte, bit 6 encodes the OOB size: 0=8B/512B, 1=16B/512B
> 
> Samsung K9GAG08U0D (6-byte sequence): ec d5 94 29 34 41
> 4th byte, bits 1:0 encode the page size: 0=2KiB, 1=4KiB, 3=8KiB, 4=rsvd
> 4th byte, bits 7;5:4 encode the block size: 0=128KiB, 1=256KiB, ...
> 4th byte, bits 6;3:2 encode the OOB size: 1=128B/page, 2=218B/page
> 
> This patch uses the new 6-byte scheme if the ID code wraps around
> exactly at byte 6, and falls back to the old scheme otherwise.
> 
> Signed-off-by: Kevin Cernekee <cernekee@gmail.com>

Pushed to l2-mtd-2.6 / master

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

