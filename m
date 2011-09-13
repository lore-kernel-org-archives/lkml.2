Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175Ab1IMHx0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 03:53:26 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:55852 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670Ab1IMHxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 03:53:25 -0400
Date: Tue, 13 Sep 2011 16:46:53 +0900
From: Tejun Heo <htejun@gmail.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Jens Axboe <jaxboe@fusionio.com>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [RFC]block: don't mark flush request as SOFTBARRIER
Message-ID: <20110913074653.GC11397@mtj.dyndns.org>
References: <1315445394.29510.71.camel@sli10-conroe>
 <20110911025128.GM29319@htj.dyndns.org>
 <1315875841.29510.80.camel@sli10-conroe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315875841.29510.80.camel@sli10-conroe>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Shaohua.

On Tue, Sep 13, 2011 at 09:04:01AM +0800, Shaohua Li wrote:
> we do the flush first and then dispatch the data. The flush is
> already delayed a lot, so if latency is a problem, we already saw
> it.

I don't necessarily agree with the above.  We don't induce any extra
latency for flushes which don't overlap.

> Why not just remove SOFTBARRIER and use elv_dispatch_sort() for
> flush data so drive can better arrange requests?

Maybe, I don't know.  Elevator sorting on writes is likely to be much
less important to begin with.  Combined with the fact that sorting
flush data would require more writes to be flushed by the following
flush, I don't think it would be clear which way would be better.  If
it can be shown that sorting flush data is better, why not?

Thanks.

-- 
tejun
