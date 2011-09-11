Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699Ab1IKAeF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Sep 2011 20:34:05 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:56209 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247Ab1IKAeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Sep 2011 20:34:03 -0400
Date: Sat, 10 Sep 2011 20:33:06 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        JBeulich@novell.com, jeremy.fitzhardinge@citrix.com, axboe@kernel.dk
Subject: Re: [PATCH 1/3] xen/blk[front|back]: Use the full FLUSH | FUA
 instead of just FLUSH.
Message-ID: <20110911003306.GB9989@oracle.com>
References: <1315593060-20031-1-git-send-email-konrad.wilk@oracle.com>
 <1315593060-20031-2-git-send-email-konrad.wilk@oracle.com>
 <20110910180849.GA6621@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110910180849.GA6621@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4E6C01D1.0072:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 10, 2011 at 02:08:49PM -0400, Christoph Hellwig wrote:
> On Fri, Sep 09, 2011 at 02:30:59PM -0400, Konrad Rzeszutek Wilk wrote:
> > During a FLUSH we can pass sector number that we want to
> > have flushed - which is what FUA requests are.
> 
> No, that is not the case.
> 
> REQ_FLUSH without data		-> pure flush
> REQ_FLUSH with data		-> preflush plus write

Excellent. So we have been doing it right all along.

> REQ_FUA				-> write and ranged postflush

Ah, somehow I was thinking that you can't write data with a
REQ_FLUSH, but that is nonsense as the block/blk-flush.c
explains in great details.

Will drop this patch - and thanks for clarifying it!
