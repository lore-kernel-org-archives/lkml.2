Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755676Ab0GVF4M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 01:56:12 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39259 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606Ab0GVF4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 01:56:04 -0400
Date: Thu, 22 Jul 2010 01:56:02 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, nauman@google.com,
        dpshah@google.com, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
        czoccolo@gmail.com
Subject: Re: [RFC PATCH] cfq-iosced: Implement IOPS mode and group_idle
 tunable V3
Message-ID: <20100722055602.GA18566@infradead.org>
References: <1279739181-24482-1-git-send-email-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279739181-24482-1-git-send-email-vgoyal@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 21, 2010 at 03:06:18PM -0400, Vivek Goyal wrote:
> On high end storage (I got on HP EVA storage array with 12 SATA disks in 
> RAID 5),

That's actually quite low end storage for a server these days :)

> So this is not the default mode. This new tunable group_idle, allows one to
> set slice_idle=0 to disable some of the CFQ features and and use primarily
> group service differentation feature.

While this is better than before needing a sysfs tweak to get any
performance out of any kind of server class hardware still is pretty
horrible.  And slice_idle=0 is not exactly the most obvious paramter
I would look for either.    So having some way to automatically disable
this mode based on hardware characteristics would be really useful,
and if that's not possible at least make sure it's very obviously
document and easily found using web searches.

Btw, what effect does slice_idle=0 with your patches have to single SATA
disk and single SSD setups?

