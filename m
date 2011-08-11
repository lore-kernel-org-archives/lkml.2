Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656Ab1HKSs2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 14:48:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:65431 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751440Ab1HKSs1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 14:48:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="37616903"
From: Andi Kleen <andi@firstfloor.org>
To: Alex Neronskiy <zakmagnus@chromium.org>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org,
        Ingo Molnar <mingo@elte.hu>, Don Zickus <dzickus@redhat.com>,
        Mandeep Singh Baines <msb@chromium.org>,
        Alex Neronskiy <zakmagnus@chromium.com>
Subject: Re: [PATCH v6 2/2] Output stall data in debugfs
References: <1312999364-21104-1-git-send-email-zakmagnus@chromium.org>
	<1312999364-21104-2-git-send-email-zakmagnus@chromium.org>
Date: Thu, 11 Aug 2011 11:48:26 -0700
In-Reply-To: <1312999364-21104-2-git-send-email-zakmagnus@chromium.org> (Alex
	Neronskiy's message of "Wed, 10 Aug 2011 11:02:44 -0700")
Message-ID: <m2bovvn5s5.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Neronskiy <zakmagnus@chromium.org> writes:

> From: Alex Neronskiy <zakmagnus@chromium.com>
>
> Instead of using the log, use debugfs for output of both stall
> lengths and stack traces. Printing to the log can result in
> watchdog touches, 

Why? Because of printk being slow or something else?

The first could be probably workarounded, especially if you
already have "two buffers"

> distorting the very events being measured.
> Additionally, the information will not distract from lockups
> when users view the log.
>
> A two-buffer system is used to ensure that the trace information
> can always be recorded without contention.

This implies that kernel bug reports will often not contain the 
back trace, right? Seems like a bad thing to me because it will
make bug reports worse.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
