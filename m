Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933780Ab1IJSI4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Sep 2011 14:08:56 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:46079
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933733Ab1IJSIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Sep 2011 14:08:55 -0400
Date: Sat, 10 Sep 2011 14:08:49 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        JBeulich@novell.com, jeremy.fitzhardinge@citrix.com, axboe@kernel.dk
Subject: Re: [PATCH 1/3] xen/blk[front|back]: Use the full FLUSH | FUA
 instead of just FLUSH.
Message-ID: <20110910180849.GA6621@infradead.org>
References: <1315593060-20031-1-git-send-email-konrad.wilk@oracle.com>
 <1315593060-20031-2-git-send-email-konrad.wilk@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315593060-20031-2-git-send-email-konrad.wilk@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 09, 2011 at 02:30:59PM -0400, Konrad Rzeszutek Wilk wrote:
> During a FLUSH we can pass sector number that we want to
> have flushed - which is what FUA requests are.

No, that is not the case.

REQ_FLUSH without data		-> pure flush
REQ_FLUSH with data		-> preflush plus write
REQ_FUA				-> write and ranged postflush

