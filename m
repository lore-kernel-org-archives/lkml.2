Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678Ab0JKWBg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 18:01:36 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:37834 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756416Ab0JKWBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 18:01:35 -0400
Subject: Re: [RFC][PATCH] try not to let dirty inodes fester
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
        hch@infradead.org, lnxninja@linux.vnet.ibm.com, axboe@kernel.dk,
        pbadari@us.ibm.com, Yuri L Volobuev <volobuev@us.ibm.com>
In-Reply-To: <20101005153604.GA25228@lst.de>
References: <20101001191449.0AA0E233@kernel.beaverton.ibm.com>
	 <20101002113238.GF4681@dastard> <1286292345.9970.4231.camel@nimitz>
	 <20101005153604.GA25228@lst.de>
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Mon, 11 Oct 2010 15:01:30 -0700
Message-ID: <1286834490.20322.8.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave, Christoph,

Thanks again for looking at this.  It turned out not to be dirty data at
all that was causing this.  It was dispose_list() taking extraordinarily
long to complete.  There were cases where it was taking 2 or 3 minutes
per batch of ~75 inodes.  This was all due to the underlying filesystem
(GPFS) taking a couple of seconds for each clear_inode().  This kept the
kernel from being able to do any slab reclaim effectively.

Sorry for the noise.

-- Dave

