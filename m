Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644Ab2JVTSc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 15:18:32 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:53484 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752813Ab2JVTSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 15:18:30 -0400
Date: Mon, 22 Oct 2012 15:18:29 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Ming Lei <ming.lei@canonical.com>
cc: linux-kernel@vger.kernel.org, Oliver Neukum <oneukum@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Jens Axboe <axboe@kernel.dk>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>, <netdev@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-mm@kvack.org>, Eric Dumazet <eric.dumazet@gmail.com>,
        David Decotigny <david.decotigny@google.com>,
        Tom Herbert <therbert@google.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC PATCH v2 4/6] net/core: apply pm_runtime_set_memalloc_noio
 on network devices
In-Reply-To: <1350894794-1494-5-git-send-email-ming.lei@canonical.com>
Message-ID: <Pine.LNX.4.44L0.1210221516280.1724-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Oct 2012, Ming Lei wrote:

> Deadlock might be caused by allocating memory with GFP_KERNEL in
> runtime_resume callback of network devices in iSCSI situation, so
> mark network devices and its ancestor as 'memalloc_noio_resume'
> with the introduced pm_runtime_set_memalloc_noio().

Is this really needed?  Even with iSCSI, doesn't register_disk() have
to be called for the underlying block device?  And given your 3/6
patch, wouldn't that mark the network device?

Alan Stern

