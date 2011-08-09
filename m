Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754336Ab1HIRvQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 13:51:16 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:57921 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753373Ab1HIRvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 13:51:15 -0400
Date: Tue, 9 Aug 2011 19:51:10 +0200
From: Tejun Heo <tj@kernel.org>
To: Mike Snitzer <snitzer@redhat.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org,
        Jens Axboe <jaxboe@fusionio.com>, Vivek Goyal <vgoyal@redhat.com>,
        dm-devel@redhat.com
Subject: Re: block: properly handle flush/fua requests in
 blk_insert_cloned_request
Message-ID: <20110809175110.GE23842@htj.dyndns.org>
References: <x49y5z2eibl.fsf@segfault.boston.devel.redhat.com>
 <20110809153826.GB23842@htj.dyndns.org>
 <x49liv2eg34.fsf@segfault.boston.devel.redhat.com>
 <20110809161334.GC23842@htj.dyndns.org>
 <20110809174347.GA13293@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110809174347.GA13293@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Aug 09, 2011 at 01:43:47PM -0400, Mike Snitzer wrote:
> [cc'ing dm-devel]
> 
> All of these issues have come to light because DM was not setting
> flush_flags based on the underlying device(s).  Now fixed in v3.1-rc1:
> ed8b752 dm table: set flush capability based on underlying devices
> 
> Given that commit, and that request-based DM is beneath the elevator, it
> seems any additional effort to have DM flushes re-enter the flush
> machinary is unnecessary.

Hmmm... what if the underlying devices have different featureset?  Use
the lowest common denominator?  The flush mechanism is designed to
deal with stacking by going through flush at each level.  Stacking
queue can simply export support for both REQ_FLUSH and FUA and the
lower lever queue will decompose them according to the capability
supported by the actual device.

IIUC, what's broken here is some insert functions aren't using
ELEVATOR_INSERT_FLUSH when needed and there are some issues due to the
special nature of the stacked requests which I think should be fixed.

Thanks.

-- 
tejun
