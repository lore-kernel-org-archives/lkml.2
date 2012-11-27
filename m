Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932311Ab2K0UZj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 15:25:39 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49037 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756521Ab2K0UZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 15:25:37 -0500
Date: Tue, 27 Nov 2012 12:25:36 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ming Lei <ming.lei@canonical.com>
Cc: linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oneukum@suse.de>, Minchan Kim <minchan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Jens Axboe <axboe@kernel.dk>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH v6 0/6] solve deadlock caused by memory allocation with
 I/O
Message-Id: <20121127122536.a0e94ab8.akpm@linux-foundation.org>
In-Reply-To: <1353761958-12810-1-git-send-email-ming.lei@canonical.com>
References: <1353761958-12810-1-git-send-email-ming.lei@canonical.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Nov 2012 20:59:12 +0800
Ming Lei <ming.lei@canonical.com> wrote:

> This patchset try to solve one deadlock problem which might be caused
> by memory allocation with block I/O during runtime PM and block device
> error handling path. Traditionly, the problem is addressed by passing
> GFP_NOIO statically to mm, but that is not a effective solution, see
> detailed description in patch 1's commit log.
> 
> This patch set introduces one process flag and trys to fix the deadlock
> problem on block device/network device during runtime PM or usb bus reset.
> 
> The 1st one is the change on include/sched.h and mm.
> 
> The 2nd patch introduces the flag of memalloc_noio on 'dev_pm_info',
> and pm_runtime_set_memalloc_noio(), so that PM Core can teach mm to not
> allocate mm with GFP_IO during the runtime_resume callback only on
> device with the flag set.
> 
> The following 2 patches apply the introduced pm_runtime_set_memalloc_noio()
> to mark all devices as memalloc_noio_resume in the path from the block or
> network device to the root device in device tree.
> 
> The last 2 patches are applied again PM and USB subsystem to demonstrate
> how to use the introduced mechanism to fix the deadlock problem.
> 
> Andrew, could you queue these patches into your tree since V6 fixes all
> your concerns and looks no one objects these patches?

Yes, this patchset looks ready to run with.  But as we're at -rc7 I'll ask
you to refresh, retest and resend after 3.8-rc1, please.
