Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751291Ab1JCXMw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 19:12:52 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:56120 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750745Ab1JCXMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 19:12:51 -0400
X-Sasl-enc: m00n+AOIXWzIORQ7JbJ1/W/zbc4L8V0Mxt1dd2CRvQOj 1317683353
Date: Mon, 3 Oct 2011 16:06:32 -0700
From: Greg KH <greg@kroah.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: gregkh@suse.de, cascardo@holoscopio.com, dan.magenheimer@oracle.com,
        rdunlap@xenotime.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: zcache: reduce tmem bucket lock contention
Message-ID: <20111003230632.GA12719@kroah.com>
References: <1317306746-27072-1-git-send-email-sjenning@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317306746-27072-1-git-send-email-sjenning@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 29, 2011 at 09:32:26AM -0500, Seth Jennings wrote:
> tmem uses hash buckets each with their own rbtree and lock to
> quickly lookup tmem objects.  tmem has TMEM_HASH_BUCKETS (256)
> buckets per pool.  However, because of the way the tmem_oid is
> generated for frontswap pages, only 16 unique tmem_oids are being
> generated, resulting in only 16 of the 256 buckets being used.
> This cause high lock contention for the per bucket locks.
> 
> This patch changes SWIZ_BITS to include more bits of the offset.
> The result is that all 256 hash buckets are potentially used resulting in a
> 95% drop in hash bucket lock contention.

This patch is somehow corrupted and can't be applied, care to resend it
with Dan's acked-by so that I can apply it?

thanks,

greg k-h
