Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757326Ab1DYICt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 04:02:49 -0400
Received: from trent.utfs.org ([194.246.123.103]:38919 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751498Ab1DYICq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 04:02:46 -0400
Date: Mon, 25 Apr 2011 01:02:33 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: Dave Chinner <david@fromorbit.com>
cc: LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: 2.6.39-rc4+: oom-killer busy killing tasks
In-Reply-To: <20110424234655.GC12436@dastard>
Message-ID: <alpine.DEB.2.01.1104250053590.18728@trent.utfs.org>
References: <alpine.DEB.2.01.1104211841510.18728@trent.utfs.org> <20110424234655.GC12436@dastard>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AV-Checked: ClamAV using ClamSMTP (127.0.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Apr 2011 at 09:46, Dave Chinner wrote:
> BTW, what are your mount options? If it is the problem I suspect it
> is, then using noatime with stop it from occurring....

When mounted with noatime, running du(1) accross the XFS volume still 
triggered the OOM killer, but the backtrace looked somewhat different 
this time:

 date invoked oom-killer: gfp_mask=0x84d0, order=0, oom_adj=0, oom_score_adj=0
 Call Trace:
 [ecda5c70] [c0009ce4] show_stack+0x70/0x1bc (unreliable)
 [ecda5cb0] [c008f508] T.528+0x74/0x1cc
 [ecda5d00] [c008f734] T.526+0xd4/0x2a0
 [ecda5d40] [c008fb7c] out_of_memory+0x27c/0x360
 [ecda5d90] [c0093b3c] __alloc_pages_nodemask+0x6f8/0x708
 [ecda5e30] [c0017e9c] pte_alloc_one+0x30/0x90
 [ecda5e40] [c00a9464] __pte_alloc+0x2c/0x100
 [ecda5e60] [c00a95a8] handle_mm_fault+0x70/0x110
 [ecda5e90] [c0016d78] do_page_fault+0x358/0x504
 [ecda5f40] [c0012938] handle_page_fault+0xc/0x80
 --- Exception: 401 at 0xffdd5e0
     LR = 0xffd8a04

Full dmesg & slabinfo & more on: 

http://nerdbynature.de/bits/2.6.39-rc4/oom/

(slabinfo-5.txt.bz2, messages-5.txt)

Christian.
-- 
BOFH excuse #176:

vapors from evaporating sticky-note adhesives
