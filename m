Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759480Ab1IKCvg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Sep 2011 22:51:36 -0400
Received: from mail-gw0-f42.google.com ([74.125.83.42]:52785 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514Ab1IKCvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Sep 2011 22:51:35 -0400
Date: Sun, 11 Sep 2011 11:51:28 +0900
From: Tejun Heo <htejun@gmail.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Jens Axboe <jaxboe@fusionio.com>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [RFC]block: don't mark flush request as SOFTBARRIER
Message-ID: <20110911025128.GM29319@htj.dyndns.org>
References: <1315445394.29510.71.camel@sli10-conroe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315445394.29510.71.camel@sli10-conroe>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Sep 08, 2011 at 09:29:54AM +0800, Shaohua Li wrote:
> I'm wondering why flush request should be marked as
> SOFTBARRIER. Current flush sequence guarantees the correctness of
> flush even the request is reordered by ioscheduler.

The primary reason would be because when those flush data requests are
put on the dispatch queue, it doesn't go through elv_dispatch_sort().
SOFTBARRIERs function as dispatch sort boundaries and queueing flush
data request at the head w/o SOFTBARRIER would confuse dispatch
sorting, and we want to put it at the head of dispatch queue to
decrease latency for flush sequence.

Thanks.

-- 
tejun
