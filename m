Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751602Ab1HKNdR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 09:33:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27577 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751068Ab1HKNdP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 09:33:15 -0400
Date: Thu, 11 Aug 2011 09:33:02 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Kyungmin Park <kmpark@infradead.org>
Cc: jaxboe@fusionio.com, linux-kernel@vger.kernel.org, arnd@arndb.de,
        jh80.chung@samsung.com, shli@kernel.org, linux-mmc@vger.kernel.org
Subject: Re: [RFC PATCH v2] Add new elevator ops for request hint
Message-ID: <20110811133302.GC8552@redhat.com>
References: <20110811004216.GA24810@july>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110811004216.GA24810@july>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 11, 2011 at 09:42:16AM +0900, Kyungmin Park wrote:
> Hi Jens
> 
> Now eMMC device requires the upper layer information to improve the data
> performance and reliability.
> 
> . Context ID
> Using the context information, it can sort out the data internally and improve the performance.
> The main problem is that it's needed to define "What's the context". 
> Actually I expect cfq queue has own unique ID but it doesn't so decide to use the pid instead
> 

Hi,

Can you please give little more details about the optimization you will
do with this pid information?

Also what happens in the case of noop and deadline which don't maintain
per process queues and can't provide this information.

> . Data Tag
> Using the Data Tag (1-bit information), It writes the data at SLC area when it's hot data. So it can make the chip more reliable.

Sorry, I am not very familiar with flash technology. Can you please give
some more details that what do you do with this information about "hot"
data and how does that make chip more reliable.

> First I expect the REQ_META but current ext4 doesn't pass the WRITE_META. only use the READ_META. so it needs to investigate it.

So are you planning to later fix file systems to appropriately mark meta
data requests?

Thanks
Vivek
