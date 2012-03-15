Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031345Ab2COWxP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 18:53:15 -0400
Received: from tn-76-7-162-101.sta.embarqhsd.net ([76.7.162.101]:51377 "EHLO
	animx.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965275Ab2COWxO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 18:53:14 -0400
Date: Thu, 15 Mar 2012 18:53:10 -0400
From: Wakko Warner <wakko@animx.eu.org>
To: linux-kernel@vger.kernel.org
Subject: Burning multiple DVDs at one time
Message-ID: <20120315225310.GB3152@animx.eu.org>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm having problems doing this.

When I burn a single disk, wodim shows the drive buf @ 99% consistently. 
The instant that a 2nd disk is being burned, the drive buf on the first one
starts to drop and data stops when the 2nd wodim is performing OPC.

During the burn of both discs, the drive buf will drop on both until one of
them finishes.  Both drives see under runs.

When one starts fixating, the other will hang until the fixation is
completed.

During the burns, the fifo of both never drop below 99%

There are no logs that are produced.

My burners are:
[6:0:0:0]    cd/dvd  ATAPI    iHAS422   8      4L11  /dev/sr7
[7:0:0:0]    cd/dvd  ATAPI    iHAS224   B      GL05  /dev/sr8

Both are SATA drives attached to the onboard sata controller
00:1f.2 SATA controller: Intel Corporation 631xESB/632xESB SATA AHCI Controller (rev 09)
00:1f.2 0106: 8086:2681 (rev 09)

The kernel is a vanilla kernel v3.0.0.  (This also happened with 2.6.35)

I don't believe it matters, but the data is coming over NFS via gigabit
ethernet.  Each burn process uses a 768M host buffer.  As I stated, the host
fifo on wodim never goes below 99%

The system motherboard is a SuperMicro X7DA8

-- 
 Microsoft has beaten Volkswagen's world record.  Volkswagen only created 22
 million bugs.
