Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756934Ab2JWIom (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 04:44:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:45610 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355Ab2JWIok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 04:44:40 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1210221035450.1724-100000@iolanthe.rowland.org>
References: <1350894794-1494-7-git-send-email-ming.lei@canonical.com>
	<Pine.LNX.4.44L0.1210221035450.1724-100000@iolanthe.rowland.org>
Date: Tue, 23 Oct 2012 16:44:39 +0800
Message-ID: <CACVXFVOy+dmjdhBr9Vtww12PZg_fo2y78TcNzuP_Yq9_p=74Hw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 6/6] USB: forbid memory allocation with I/O during
 bus reset
From: Ming Lei <ming.lei@canonical.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-kernel@vger.kernel.org, Oliver Neukum <oneukum@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Jens Axboe <axboe@kernel.dk>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 10:37 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Mon, 22 Oct 2012, Ming Lei wrote:

>>
>> +     /*
>> +      * Don't allocate memory with GFP_KERNEL in current
>> +      * context to avoid possible deadlock if usb mass
>> +      * storage interface or usbnet interface(iSCSI case)
>> +      * is included in current configuration. The easiest
>> +      * approach is to do it for all devices.
>> +      */
>> +     memalloc_noio_save(noio_flag);
>
> Why not check dev->power.memalloc_noio_resume here too?

Yes, we can use the flag here too even though it is introduced
for rutime_resume case.

Thanks,
--
Ming Lei
