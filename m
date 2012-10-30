Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964829Ab2J3QYe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 12:24:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34719 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758531Ab2J3QYb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 12:24:31 -0400
From: Oliver Neukum <oneukum@suse.de>
To: Ming Lei <ming.lei@canonical.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
        Minchan Kim <minchan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Jens Axboe <axboe@kernel.dk>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH v3 2/6] PM / Runtime: introduce pm_runtime_set[get]_memalloc_noio()
Date: Tue, 30 Oct 2012 17:30:13 +0100
Message-ID: <2504263.kbM6W9JoH9@linux-lqwf.site>
Organization: SUSE
User-Agent: KMail/4.8.4 (Linux/3.7.0-rc2-12-desktop+; KDE/4.9.1; x86_64; ; )
In-Reply-To: <CACVXFVO5-UPNrWsySzDE5AfOv1TMqbyitQX9ViidSJPM36fqAQ@mail.gmail.com>
References: <CACVXFVOPDu6wVgPmvtTkokn7VV41x3XVvL4g_E0pz0mikUbvUg@mail.gmail.com> <Pine.LNX.4.44L0.1210301112270.1363-100000@iolanthe.rowland.org> <CACVXFVO5-UPNrWsySzDE5AfOv1TMqbyitQX9ViidSJPM36fqAQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 31 October 2012 00:00:56 Ming Lei wrote:
> On Tue, Oct 30, 2012 at 11:38 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> 
> >
> > Okay, I see your point.  But acquiring the lock here doesn't solve the
> > problem.  Suppose a thread is about to reset a USB mass-storage device.
> > It acquires the lock and sees that the noio flag is clear.  But before
> > it can issue the reset, another thread sets the noio flag.
> 
> If the USB mass-storage device is being reseted, the flag should be set
> already generally.  If the flag is still unset, that means the disk/network
> device isn't added into system(or removed just now), so memory allocation
> with block I/O should be allowed during the reset. Looks it isn't one problem,
> isn't it?

I am afraid it is, because a disk may just have been probed as the deviceis being reset.

	Regards
		Oliver

