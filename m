Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752370Ab2K1Eel (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 23:34:41 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:56377 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120Ab2K1Eei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 23:34:38 -0500
MIME-Version: 1.0
In-Reply-To: <5434404.G1ERYjuorE@vostro.rjw.lan>
References: <1353761958-12810-1-git-send-email-ming.lei@canonical.com>
	<1353761958-12810-3-git-send-email-ming.lei@canonical.com>
	<5434404.G1ERYjuorE@vostro.rjw.lan>
Date: Wed, 28 Nov 2012 12:34:36 +0800
Message-ID: <CACVXFVODD9fRqQc3kR58OJm3ERgBWojnx=790xGwu=MPGaSmMA@mail.gmail.com>
Subject: Re: [PATCH v6 2/6] PM / Runtime: introduce pm_runtime_set_memalloc_noio()
From: Ming Lei <ming.lei@canonical.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oneukum@suse.de>, Minchan Kim <minchan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2012 at 5:19 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>
> Please use counters instead of walking the whole path every time.  Ie. in
> addition to the flag add a counter to store the number of the device's
> children having that flag set.

Even though counter is added, walking the whole path can't be avoided too,
and may be a explicit walking or recursion, because pm_runtime_set_memalloc_noio
is required to set or clear the flag(or increase/decrease the counter) of
devices in the whole path.

Thanks,
--
Ming Lei
