Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933524Ab2JXIY2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 04:24:28 -0400
Received: from smtp.wow.synacor.com ([64.8.70.55]:43358 "EHLO
	smtp.mail.wowway.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755607Ab2JXIYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 04:24:25 -0400
X-Spam-Rating: None
X_CMAE_Category: 0,0 Undefined,Undefined
X-CNFS-Analysis: v=1.1 cv=xHXv0g0Kn/mySl3Zfr0D25xRGcuzAlFTymZE9p2Zkbk= c=1 sm=0 a=Vm6sNz4auHEA:10 a=nDghuxUhq_wA:10 a=kj9zAlcOel0A:10 a=txbFqWyMoYUhCs4Bd_4A:9 a=CjuIK1q_8ugA:10 a=zsaeSSr3pazHFAQJU9uUyg==:117
X-CM-Score: 0
Authentication-Results: smtp02.wow.synacor.com smtp.mail=set@squish.homelinux.org; spf=neutral
Date: Wed, 24 Oct 2012 04:24:23 -0400
From: Paul Thompson <set.mailinglist@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: BUG: using smp_processor_id() in preemptible
Message-ID: <20121024082423.GB2604@squish.home.loc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi;

	Just saw this after invoking cpufreq-set -g performance in
an attempt to enhance a stuttering mpeg transcode for ps3mediaserver.
	This repeats in the logs about 10 times. If anyone cares, I
will be responsive.

Paul

2012 Oct 24 01:39:14: BUG: using smp_processor_id() in preemptible [00000000] code: cpufreq-set/22941
2012 Oct 24 01:39:14: caller is powernowk8_target+0x19/0x50
2012 Oct 24 01:39:14: Pid: 22941, comm: cpufreq-set Not tainted 3.6.2-low-lat #13
2012 Oct 24 01:39:14: Call Trace:
2012 Oct 24 01:39:14: [<ffffffff811b0476>] ? debug_smp_processor_id+0xd6/0xf0
2012 Oct 24 01:39:14: [<ffffffff812eb6e9>] ? powernowk8_target+0x19/0x50
2012 Oct 24 01:39:14: [<ffffffff812e9a95>] ? cpufreq_governor_performance+0x25/0x30
2012 Oct 24 01:39:14: [<ffffffff812e7f87>] ? __cpufreq_governor+0x47/0xc0
2012 Oct 24 01:39:14: [<ffffffff812e8164>] ? __cpufreq_set_policy+0x164/0x1a0
2012 Oct 24 01:39:14: [<ffffffff812e8849>] ? store_scaling_governor+0xc9/0x1b0
2012 Oct 24 01:39:15: [<ffffffff812e8c40>] ? cpufreq_update_policy+0xf0/0xf0
2012 Oct 24 01:39:15: [<ffffffff812e9005>] ? store+0x65/0xb0
2012 Oct 24 01:39:15: [<ffffffff8112574d>] ? sysfs_write_file+0xcd/0x150
2012 Oct 24 01:39:15: [<ffffffff810ca9a7>] ? vfs_write+0xa7/0x180
2012 Oct 24 01:39:15: [<ffffffff810cacd7>] ? sys_write+0x47/0x90
2012 Oct 24 01:39:15: [<ffffffff813d8526>] ? system_call_fastpath+0x1a/0x1f


