Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821Ab1GRTJA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 15:09:00 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55497 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144Ab1GRTI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 15:08:59 -0400
MIME-Version: 1.0
Date: Mon, 18 Jul 2011 12:08:56 -0700
Message-ID: <CAHQAjVF-58LAYWZev6zH0NB+Prmn=WudcxwtgwmiWv8jNSNQAA@mail.gmail.com>
Subject: Looking for max iops
From: ersatz splatt <ersatzsplatt@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Roland Dreier <roland@purestorage.com>, Matthew Wilcox <matthew@wil.cx>,
        Jens Axboe <axboe@kernel.dk>, "Jiang, Dave" <dave.jiang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Foong, Annie" <annie.foong@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Nadolski, Edmund" <edmund.nadolski@intel.com>,
        "Skirvin, Jeffrey D" <jeffrey.d.skirvin@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The HBA controller is not released yet.  I'm using an early version.
My hope is to cobble something together for a driver before the
hardware is in peoples' hands and give the driver to the community.

I would like to know if I'm breaking new ground by trying to drive the
number of IOPS I'm pushing now.  I don't expect to be able to get a
million with the hardware I have.  Is anybody driving that level of
activity now?  I'm getting nowhere near half that.  If nobody has
shared data at these speeds then I'd be happy to do some testing if it
is wanted.

The rq_affinity change certainly helped (as I wrote before).

By lockless, do you mean no host_lock?  The queuecommand has no
host_lock use but does have some local locking.

If I am to cast suspicion on locks, I suppose I should be looking at
lock_stat (?) -- what units should I be attributing to holdtime?


Thanks for the response Christoph,
David



On Fri, Jul 15, 2011 at 7:40 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Fri, Jul 15, 2011 at 04:43:44PM -0700, ersatz splatt wrote:
>> I have a dual socket system with Tylersburg chipset (approximately
>> Westmere I gather).
>> With two Xeon X5660 packages I get this when running with more iops
>> potential than the system can handle:
>
> What HBA do you use? Does it already have a lockless ->queuecommand?
>
>
