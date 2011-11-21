Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930Ab1KUKAK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 05:00:10 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:39122
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752063Ab1KUKAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 05:00:08 -0500
Date: Mon, 21 Nov 2011 05:00:04 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        linux-fsdevel@vger.kernel.org, Li Shaohua <shaohua.li@intel.com>,
        Clemens Ladisch <clemens@ladisch.de>,
        Jens Axboe <jens.axboe@oracle.com>, Rik van Riel <riel@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 1/8] block: limit default readahead size for small devices
Message-ID: <20111121100004.GB5084@infradead.org>
References: <20111121091819.394895091@intel.com>
 <20111121093846.121502745@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111121093846.121502745@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 21, 2011 at 05:18:20PM +0800, Wu Fengguang wrote:
> This looks reasonable: smaller device tend to be slower (USB sticks as
> well as micro/mobile/old hard disks).
> 
> Given that the non-rotational attribute is not always reported, we can
> take disk size as a max readahead size hint. This patch uses a formula
> that generates the following concrete limits:

Given that you mentioned the rotational flag and device size in this
mail, as well as benchmarking with an intel SSD  -  did you measure
how useful large read ahead sizes still are with highend Flash device
that have extremly high read IOP rates?

