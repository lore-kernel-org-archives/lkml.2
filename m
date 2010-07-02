Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758643Ab0GBOFa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 10:05:30 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46481 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753752Ab0GBOF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 10:05:29 -0400
Date: Fri, 2 Jul 2010 10:05:28 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Larry Woodman <lwoodman@redhat.com>
Cc: hch@infradead.org, linux-kernel@vger.kernel.org, riel@redhat.com,
       axboe@kernel.dk
Subject: Re: Race in wb_do_writeback() ???
Message-ID: <20100702140528.GA27937@infradead.org>
References: <1277843296.3223.98.camel@dhcp-100-19-198.bos.redhat.com>
 <20100629202650.GA28992@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100629202650.GA28992@infradead.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens, I think we need to pull this patch into 2.6.35 still.  While
we could fix the various races with the kfree and wakeup vs ->state
manipulation in a slightly smaller way at least this patch has gotten
lots of testing in linux-next and targeted stress testing.

On Tue, Jun 29, 2010 at 04:26:50PM -0400, Christoph Hellwig wrote:
> On Tue, Jun 29, 2010 at 04:28:16PM -0400, Larry Woodman wrote:
> > Can you have one unconditional call to wb_clear_pending() after the
> > calling wb_writeback()???
> 
> In fact we should only have a conditional call after wb_writeback.
> I've done that already and it's in Jens' tree for 2.6.36:
> 
> 	http://git.kernel.dk/?p=linux-2.6-block.git;a=commitdiff;h=79338d2a78ab78efdc1698f1309766a039addf9d
> 
---end quoted text---
