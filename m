Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964Ab1ATXvH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 18:51:07 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36497 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755229Ab1ATXvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 18:51:05 -0500
Date: Thu, 20 Jan 2011 15:50:21 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>, Len Brown <len.brown@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Jack Steiner <steiner@sgi.com>, Robin Holt <holt@sgi.com>,
        Lori Gilbertson <loriann@sgi.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 1/6] printk: Allocate kernel log buffer earlier
Message-Id: <20110120155021.c39387c3.akpm@linux-foundation.org>
In-Reply-To: <20110119230106.527741713@gulag1.americas.sgi.com>
References: <20110119230106.341785959@gulag1.americas.sgi.com>
	<20110119230106.527741713@gulag1.americas.sgi.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Jan 2011 17:01:07 -0600
Mike Travis <travis@sgi.com> wrote:

> On larger systems, because of the numerous ACPI, Bootmem and EFI
> messages, the static log buffer overflows before the larger one
> specified by the log_buf_len param is allocated.  Minimize the
> overflow by allocating the new log buffer as soon as possible.
> 
> All arch's are covered by the "setup_log_buf" in start_kernel().
> The x86 arch allocates it right after bootmem is created.
> 
> ...
>
> +void setup_log_buf(void);
>
> ...
>
> +void __init setup_log_buf(void)
>

It's a PITA but the declaration should have the __init tag as well.  We
have had at least one instance where failing to do this caused an arch
(arm) to emit a short-mode address offset to a function which it
thought was in the same section as the callsite.  Only the target was
in a different section from the callsite and the linker couldn't fit
the needed offset into the operand.

