Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066Ab0F0Mcp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jun 2010 08:32:45 -0400
Received: from sh.osrg.net ([192.16.179.4]:38589 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754681Ab0F0Mcm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jun 2010 08:32:42 -0400
Date: Sun, 27 Jun 2010 21:32:07 +0900
To: hch@lst.de
Cc: fujita.tomonori@lab.ntt.co.jp, snitzer@redhat.com, axboe@kernel.dk,
       dm-devel@redhat.com, James.Bottomley@suse.de,
       linux-kernel@vger.kernel.org, martin.petersen@oracle.com,
       akpm@linux-foundation.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/2] block: fix leaks associated with discard request
 payload
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100627110712.GA14511@lst.de>
References: <20100627185927K.fujita.tomonori@lab.ntt.co.jp>
	<20100627193253P.fujita.tomonori@lab.ntt.co.jp>
	<20100627110712.GA14511@lst.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100627212952D.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Sun, 27 Jun 2010 21:32:10 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Jun 2010 13:07:12 +0200
Christoph Hellwig <hch@lst.de> wrote:

> > How about this?
> 
> As I tried to explain before this utterly confuses the I/O completion
> path.  With the patch applied even a simple mkfs.xfs that issues discard
> just hangs.

Wired. I just tried mkfs.xfs against scsi_debug with my block patches
(I saw one discard command). Seemed that it worked fine.
