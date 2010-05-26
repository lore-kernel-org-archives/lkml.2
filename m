Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774Ab0EZTfr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 15:35:47 -0400
Received: from mga05.intel.com ([192.55.52.89]:5094 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756747Ab0EZTfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 15:35:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,305,1272870000"; 
   d="scan'208";a="570820666"
Subject: Re: [PATCH 1/2] tmpfs: Quick token library to allow scalable
 retrieval of tokens from token jar
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
       Hugh Dickins <hughd@google.com>
In-Reply-To: <20100520160834.d537ccf6.akpm@linux-foundation.org>
References: <1274225668.31973.8950.camel@mudge.jf.intel.com>
	 <20100520160834.d537ccf6.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 May 2010 12:33:24 -0700
Message-ID: <1274902404.31973.9394.camel@mudge.jf.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

I've fixed the issues that you brought up for this patch series. I have
sent out version 2 patches in separate mails.  
I've followed up on one of your comments below to explain why I'm doing
things done differently from your suggestions.

On Thu, 2010-05-20 at 16:08 -0700, Andrew Morton wrote:

> > +
> > +struct qtoken {
> > +	long		pool;	/* pool of free tokens */
> > +	long		total;  /* total num of tokens */
> > +#ifdef CONFIG_SMP
> > +	long		init_cache_sz; /* initial cache size */
> 
> I don't think that it si meaningful for any of these things to have
> negative values, so an unsigned type would be more appropriate.
> 
> Did they really need to be `long'?  Plain old `unsigned' might be more
> efficient, perhaps.

I've changed "pool" and "total" to unsigned long.  However, since tmpfs
uses unsigned long for the free blocks, I have to use unsigned long
instead of unsigned for the token jar to maintain compatibility with
tmpfs.


Thank you for your review.

Regards,
Tim Chen

