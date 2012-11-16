Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751816Ab2KPND6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 08:03:58 -0500
Received: from rrzmta2.uni-regensburg.de ([194.94.155.52]:59782 "EHLO
	rrzmta2.uni-regensburg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765Ab2KPNDz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 08:03:55 -0500
Message-Id: <50A647C4020000A10000D7B1@gwsmtp1.uni-regensburg.de>
X-Mailer: Novell GroupWise Internet Agent 12.0.1 
Date: Fri, 16 Nov 2012 14:03:48 +0100
From: "Ulrich Windl" <Ulrich.Windl@rz.uni-regensburg.de>
To: <linux-kernel@vger.kernel.org>
Subject: 3.0: blk-cgroup.c: allow '*' for device selection for
 "throttle.read_bps_device" and alike
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I have a wish for Linux 3.x and blkio cgroup subsystem:
Allow to specify any device like: blkio.throttle.read_bps_device = "*:* 41943040"

Why: With multipathing being effective, you can't predict the device number your device will have in advance (I'm talking about "/etc/cgconfig.conf").

Example:
# multipath -ll |grep dm-
CBW_DB_FATA-E2 (3600508b4001085dd0001100003800000) dm-10 HP,HSV200
CBW_CI-E2 (3600508b4001085dd00011000040c0000) dm-12 HP,HSV200
CBW_DB_FATA-E1 (3600508b4001085e30000f00001810000) dm-18 HP,HSV200
CBW_CI-E1 (3600508b4001085e30000f00001f60000) dm-19 HP,HSV200
DP_FileLib-E2 (3600508b4001085dd0001100004be0000) dm-16 HP,HSV200
CBW_DB_Exe-E2 (3600508b4001085dd00011000037b0000) dm-11 HP,HSV200
CBW_DB_Exe-E1 (3600508b4001085e30000f000017e0000) dm-17 HP,HSV200
DP_DB_10k-E2 (3600508b4001085dd0001100004480000) dm-15 HP,HSV200
CBW_DB_BTD-E2 (3600508b4001085dd0001100005ad0000) dm-14 HP,HSV200
DP_DB_10k-E1 (3600508b4001085e30000f00002460000) dm-20 HP,HSV200
CBW_DB_10k-E2 (3600508b4001085dd0001100005a50000) dm-9 HP,HSV200
CBW_DB_10k-E1 (3600508b4001085e30000f000035f0000) dm-13 HP,HSV200

The code is in blkio_policy_parse_and_set() of blk-cgroup.c.

Regards,
Ulrich


