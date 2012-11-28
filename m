Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835Ab2K1JZC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 04:25:02 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:34992 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753748Ab2K1JY7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 04:24:59 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ming Lei <ming.lei@canonical.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oneukum@suse.de>, Minchan Kim <minchan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v6 2/6] PM / Runtime: introduce pm_runtime_set_memalloc_noio()
Date: Wed, 28 Nov 2012 10:29:41 +0100
Message-ID: <1408044.6czCGhbHJH@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0-rc7; KDE/4.9.3; x86_64; ; )
In-Reply-To: <CACVXFVODD9fRqQc3kR58OJm3ERgBWojnx=790xGwu=MPGaSmMA@mail.gmail.com>
References: <1353761958-12810-1-git-send-email-ming.lei@canonical.com> <5434404.G1ERYjuorE@vostro.rjw.lan> <CACVXFVODD9fRqQc3kR58OJm3ERgBWojnx=790xGwu=MPGaSmMA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 28, 2012 12:34:36 PM Ming Lei wrote:
> On Wed, Nov 28, 2012 at 5:19 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >
> > Please use counters instead of walking the whole path every time.  Ie. in
> > addition to the flag add a counter to store the number of the device's
> > children having that flag set.
> 
> Even though counter is added, walking the whole path can't be avoided too,
> and may be a explicit walking or recursion, because pm_runtime_set_memalloc_noio
> is required to set or clear the flag(or increase/decrease the counter) of
> devices in the whole path.

But it doesn't have to walk the children.  Moreover, with counters it only
needs to walk the whole path if all devices in it need to be updated.  For
example, if you call pm_runtime_set_memalloc_noio(dev, true) for a device
whose parent's counter is greater than zero already, you don't need to
walk the path above the parent.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
