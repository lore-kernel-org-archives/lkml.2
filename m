Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494Ab1IVSMV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 14:12:21 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:55382
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753013Ab1IVSMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 14:12:18 -0400
Date: Thu, 22 Sep 2011 14:12:16 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: jens.axboe@fusionio.com, linux-kernel@vger.kernel.org
Subject: Re: blk_classic tracing horribly broken
Message-ID: <20110922181216.GA13772@infradead.org>
References: <x491uv8h348.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x491uv8h348.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 22, 2011 at 01:57:11PM -0400, Jeff Moyer wrote:
> Hi,
> 
> I've stared at the code for a while, and I've come up empty.  Would
> anyone care to take a stab at fixing this?
> 
> To reproduce:
> 
> mount -t debugfs none /sys/kernel/debug
> cd /sys/kernel/debug/tracing
> echo blk > current_tracer
> echo 1 > events/block/enable
> echo 1 > options/blk_classic
> echo 1 > tracing_on
> 
> dd if=/dev/<device> of=/dev/null bs=1M count=1 iflag=direct
> cat trace

Why are you using this interface anyway?  We actually had planned to
drop it long time ago, but for some reason that never happened.

