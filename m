Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274Ab1IAQy7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 12:54:59 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:40255 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752373Ab1IAQy6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 12:54:58 -0400
Subject: Re: [PATCH 0/3] staging: zcache: xcfmalloc support
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>, gregkh@suse.de,
        devel@driverdev.osuosl.org, ngupta@vflare.org, cascardo@holoscopio.com,
        rdunlap@xenotime.net, linux-kernel@vger.kernel.org
In-Reply-To: <4E5FB3CF.3020703@linux.vnet.ibm.com>
References: <1314801641-15059-1-git-send-email-sjenning@linux.vnet.ibm.com>
	 <6e0e7950-0c91-4bb3-929b-3853fa95e63d@default 4E5EB066.6020007@linux.vnet.ibm.com>
	 <36dad993-ea60-43f4-89f0-77831befd483@default>
	 <4E5FB3CF.3020703@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Sep 2011 09:54:47 -0700
Message-ID: <1314896087.13161.30.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-01 at 11:33 -0500, Seth Jennings wrote:
> xcfmalloc is also 0(1) in that the number of freelists
> at that have to be checked is constant and not increasing
> with the number of allocations.  The constant hidden
> in the O(1) for finding a suitable block is NUM_FREELISTS.

The algorithm is technically O(n^2) since there are
XCF_MAX_BLOCKS_PER_ALLOC searches through XCF_NUM_FREELISTS.  There's
also the reserved pages refill loop, which is linear too.

xcfmalloc's big compromise is that it doesn't do any searching or
fitting.  It might needlessly split larger blocks when two small ones
would have worked, for instance.

-- Dave

