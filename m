Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340Ab1HYHaL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 03:30:11 -0400
Received: from ch-smtp04.sth.basefarm.net ([80.76.153.5]:37033 "EHLO
	ch-smtp04.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750903Ab1HYHaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 03:30:08 -0400
X-Mailer: exmh version 2.7.2 04/02/2003 (gentoo 2.7.2) with nmh-1.3-dev
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        aeriksson@fastmail.fm
Subject: mtrr failure, 3.1-rc1
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Thu, 25 Aug 2011 09:03:35 +0200
From: Anders Eriksson <aeriksson@fastmail.fm>
Message-Id: <20110825070335.3095B3BC183@tippex.mynet.homeunix.org>
X-Originating-IP: 83.252.233.92
X-Scan-Result: No virus found in message 1QwUNs-0003sk-Fs.
X-Scan-Signature: ch-smtp04.sth.basefarm.net 1QwUNs-0003sk-Fs 450afc85a2f2c0986adcc1b9e50e109f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



My old P-II has 640MB ram, but the bios only sets up WC for the first 512, so i 
add this early in the boot process:
echo "base=0x20000000 size=0x8000000 type=write-back" > /proc/mtrr

For reasons I have forgot I also have to add 'disable_mtrr_check' to the 
command line. Works great.

As of merge dc43d9fa73d82083656fb9c02f4823bcdcfb9f91 This no longer works.
Adding that line to /proc/mtrr no longer has any effect (cat /proc/mtrr shows
only the reg00 entry).

Reverting that merge on top of rc3 brings things back to normal and /proc/mtrr 
shows:
reg00: base=0x000000000 (    0MB), size=  512MB, count=1: write-back
reg01: base=0x048000000 ( 1152MB), size=  128MB, count=1: write-combining
reg02: base=0x020000000 (  512MB), size=  128MB, count=2: write-back

Any ideas how to track this down futher? Would be good to get it fixed for 3.1

-Anders


