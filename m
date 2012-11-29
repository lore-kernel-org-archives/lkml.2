Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668Ab2K2Bep (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 20:34:45 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:55356 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754631Ab2K2Beo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 20:34:44 -0500
X-AuditID: 9c93016f-b7b86ae000003a75-c7-50b6bbb1b61d
Date: Thu, 29 Nov 2012 10:34:41 +0900
From: Minchan Kim <minchan@kernel.org>
To: Jerome Marchand <jmarchan@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Nitin Gupta <ngupta@vflare.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 3/3] zram: get rid of lockdep warning
Message-ID: <20121129013441.GB24077@blaptop>
References: <1354070146-18619-1-git-send-email-minchan@kernel.org>
 <1354070146-18619-3-git-send-email-minchan@kernel.org>
 <50B625B5.2070601@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50B625B5.2070601@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2012 at 03:54:45PM +0100, Jerome Marchand wrote:
> On 11/28/2012 03:35 AM, Minchan Kim wrote:
> > Lockdep complains about recursive deadlock of zram->init_lock.
> > [1] made it false positive because we can't request IO to zram
> > before setting disksize. Anyway, we should shut lockdep up to
> > avoid many reporting from user.
> > 
> > This patch allocates zram's metadata out of lock so we can fix it.
> 
> Is that me or the functions zram_meta_alloc/free are missing?

Who bite my zram_meta_alloc/free? :)
Will resend with your suggestion for removing GFP_ATOMIC.

Thanks!

> 
> Regards,
> Jerome
-- 
Kind regards,
Minchan Kim
