Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758886Ab1DYTvD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 15:51:03 -0400
Received: from casper.infradead.org ([85.118.1.10]:46896 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758831Ab1DYTvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 15:51:00 -0400
Subject: Re: [PATCH 0/4] munmap: Flexible mem unmap operation interface for
 scheduling latency
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Geunsik Lim <leemgs1@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Hugh Dickins <hughd@google.com>, Steven Rostedt <rostedt@goodmis.org>,
        Darren Hart <dvhart@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
In-Reply-To: <1303728272-11408-1-git-send-email-leemgs1@gmail.com>
References: <1303728272-11408-1-git-send-email-leemgs1@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 25 Apr 2011 21:47:17 +0200
Message-ID: <1303760837.4865.22.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-25 at 19:44 +0900, Geunsik Lim wrote:
>     Originally, We aim to not hold locks for too long (for scheduling latency reasons).
>     So zap pages in ZAP_BLOCK_SIZE byte counts.
>     This means we need to return the ending mmu_gather to the caller.

Please have a look at the mmu_gather rewrite that hit -mm last week,
that completely does away with ZAP_BLOCK_SIZE and renders these patches
obsolete.

Also, -rt doesn't care since it already has preemptible mmu_gather.

Furthermore:

> +L:     linux-rt-users@vger.kernel.org

is complete crap, linux-rt-users is _NOT_ a development list.

