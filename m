Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758816Ab1DYSMG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 14:12:06 -0400
Received: from relay3.sgi.com ([192.48.152.1]:41429 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758686Ab1DYSLi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 14:11:38 -0400
Message-Id: <20110425181136.055235992@gulag1.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 25 Apr 2011 13:11:36 -0500
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] printk: Allocate log buffer as early as possible
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On larger systems, information in the kernel log is lost because
there is so much early text printed, that it overflows the static
log buffer before the log_buf_len kernel parameter can be processed,
and a bigger log buffer allocated.

Distros are relunctant to increase memory usage by increasing the
size of the static log buffer, so minimize the problem by allocating
the new log buffer as early as possible.

-- 
