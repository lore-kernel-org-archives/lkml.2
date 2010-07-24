Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125Ab0GXIvj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jul 2010 04:51:39 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52165 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685Ab0GXIvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jul 2010 04:51:37 -0400
Date: Sat, 24 Jul 2010 04:51:35 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        axboe@kernel.dk, nauman@google.com, dpshah@google.com,
        guijianfeng@cn.fujitsu.com, jmoyer@redhat.com, czoccolo@gmail.com
Subject: Re: [RFC PATCH] cfq-iosced: Implement IOPS mode and group_idle
 tunable V3
Message-ID: <20100724085135.GB32006@infradead.org>
References: <1279739181-24482-1-git-send-email-vgoyal@redhat.com>
 <20100722055602.GA18566@infradead.org>
 <20100722140044.GA28684@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100722140044.GA28684@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To me this sounds like slice_idle=0 is the right default then, as it
gives useful behaviour for all systems linux runs on.  Setups with
more than a few spindles are for sure more common than setups making
use of cgroups.  Especially given that cgroups are more of a high end
feature you'd rarely use on a single SATA spindle anyway.  So setting
a paramter to make this useful sounds like the much better option.

Especially given that the block cgroup code doesn't work particularly
well in presence of barriers, which are on for any kind of real life
production setup anyway.

