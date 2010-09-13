Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752408Ab0IMVZT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 17:25:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51752 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751240Ab0IMVZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 17:25:17 -0400
Date: Mon, 13 Sep 2010 14:24:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Rubin <mrubin@google.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, fengguang.wu@intel.com, jack@suse.cz,
        riel@redhat.com, david@fromorbit.com, kosaki.motohiro@jp.fujitsu.com,
        npiggin@kernel.dk, hch@lst.de, axboe@kernel.dk
Subject: Re: [PATCH 5/5] writeback: Reporting dirty thresholds in
 /proc/vmstat
Message-Id: <20100913142412.dc0f6950.akpm@linux-foundation.org>
In-Reply-To: <1284357493-20078-6-git-send-email-mrubin@google.com>
References: <1284357493-20078-1-git-send-email-mrubin@google.com>
	<1284357493-20078-6-git-send-email-mrubin@google.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Sep 2010 22:58:13 -0700
Michael Rubin <mrubin@google.com> wrote:

> The kernel already exposes the user desired thresholds in /proc/sys/vm
> with dirty_background_ratio and background_ratio. But the kernel may
> alter the number requested without giving the user any indication that
> is the case.
> 
> Knowing the actual ratios the kernel is honoring can help app developers
> understand how their buffered IO will be sent to the disk.
> 
>         $ grep threshold /proc/vmstat
>         nr_dirty_threshold 409111
>         nr_dirty_background_threshold 818223
> 

Yes, I think /proc/vmstat is a decent place to put these.  The needed
infrastructural support is minimal and although these numbers are
closely tied to the implementation-of-the-day, people should expect
individual fields in /proc/vmstat to appear and disappear at random as
kernel versions change.

