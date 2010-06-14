Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206Ab0FNLKj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 07:10:39 -0400
Received: from smtp.nokia.com ([192.100.122.233]:34600 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756044Ab0FNLKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 07:10:37 -0400
Message-ID: <4C160E0E.4010802@nokia.com>
Date: Mon, 14 Jun 2010 14:10:06 +0300
From: Adrian Hunter <adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kyungmin Park <kmpark@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
       Madhusudhan Chikkature <madhu.cr@ti.com>
Subject: Re: [PATCH V2 0/4] Add MMC erase and secure erase
References: <4C14AC7E.6030308@nokia.com> <20100614080921.GA28316@lst.de>
In-Reply-To: <20100614080921.GA28316@lst.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Jun 2010 11:10:09.0931 (UTC) FILETIME=[27298DB0:01CB0BB2]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Sun, Jun 13, 2010 at 01:01:34PM +0300, Adrian Hunter wrote:
>> Hi
>>
>> Add ability to do MMC erase and secure erase operations from userspace,
>> using the BLKDISCARD ioctl and a newly created BLKSECDISCARD ioctl.
> 
> Have you done any measurement if the use of the block layer changes
> performance of the discard requests for you?

No.  For my purposes there will be only 1 discard request for the entire
device which will take several minutes to process, so block layer
performance is not a factor.

> I'd really prefer to
> send down the secure erase that way, too.  This could easily be done
> by having a DISCARD_SECURE rw flag, which just ORs another flag into
> the request type field.

Needs a bio flag, a request flag, setup the request flag based on the
bio flag, prevent merging secure and non-secure discards, prevent drivers
doing non-secure discards for secure discards.

Seems like a lot of little changes for something that no one wants.
Shouldn't it wait for someone to need it first?
