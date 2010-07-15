Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934654Ab0GOUNo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 16:13:44 -0400
Received: from mail.fem.tu-ilmenau.de ([141.24.101.79]:60215 "EHLO
	mail.fem.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934633Ab0GOUNl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 16:13:41 -0400
From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
To: Dave Chinner <david@fromorbit.com>
Subject: Re: 2.6.35-r5 ext3 corruptions
Date: Thu, 15 Jul 2010 22:14:16 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc4-btrfs-debug; KDE/4.4.5; i686; ; )
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20100715105745.GI30737@dastard>
In-Reply-To: <20100715105745.GI30737@dastard>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201007152214.17898.johannes.hirte@fem.tu-ilmenau.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag 15 Juli 2010, 12:57:45 schrieb Dave Chinner:
> Upgrading my test vms from 2.6.35-rc3 to 2.6.35-rc5 is resulting in
> repeated errors on the root drive of a test VM:
> 
> { 1532.368808] EXT3-fs error (device sda1): ext3_lookup: deleted inode
> referenced: 211043 [ 1532.370859] Aborting journal on device sda1.
> [ 1532.376957] EXT3-fs (sda1):
> [ 1532.376976] EXT3-fs (sda1): error: ext3_journal_start_sb: Detected
> aborted journal [ 1532.376980] EXT3-fs (sda1): error: remounting
> filesystem read-only [ 1532.420361] error: remounting filesystem read-only
> [ 1532.621209] EXT3-fs error (device sda1): ext3_lookup: deleted inode
> referenced: 211043
> 
> The filesysetm is a mess when checked on reboot - lots of illegal
> references to blocks, multiply linked blocks, etc, but repairs.
> Files are lots, truncated, etc, so there is visible filesystem
> damage.
> 
> I did lots of testing on 2.6.35-rc3 and came across no problems;
> problems only seemed to start with 2.6.35-rc5, and I've repろoduced
> the problem on a vanilla 2.6.35-rc4.
> 
> The problem seems to occur randomly - sometimes during boot or when
> idle after boot, sometimes a while after boot. I haven't done any
> digging at all for the cause - all I've done so far is confirm that
> it is reproducable and it's not my code causing the problem.

This sounds like the errors I've encountered with btrfs and XFS:
http://lkml.org/lkml/2010/7/8/181

I'm not sure, but it's quite possible that this started with the change from 
2.6.35-rc3 to 2.6.35-rc4 .


regards,
  Johannes
