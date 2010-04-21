Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756632Ab0DUU61 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 16:58:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756600Ab0DUU6Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 16:58:25 -0400
Date: Wed, 21 Apr 2010 22:58:07 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@redhat.com>, Dan Carpenter <error27@gmail.com>,
       Izik Eidus <ieidus@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, kernel-janitors@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] ksm: check for ERR_PTR from follow_page()
Message-ID: <20100421205807.GV32034@random.random>
References: <20100421102759.GA29647@bicker>
 <4BCF18A8.8080809@redhat.com>
 <20100421174615.GO32034@random.random>
 <20100421205305.GO20640@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100421205305.GO20640@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 21, 2010 at 10:53:05PM +0200, Johannes Weiner wrote:
> Check below that loop.  If it returns non-null, the first check is
> whether it IS_ERR().

Indeed.

> + * Returns the mapped (struct page *), %NULL if no mapping exists, or
> + * an error pointer if there is a mapping to something not represented
> + * by a page descriptor (see also vm_normal_page()).

where exactly in vm_normal_page? Note I already checked vm_normal_page
before sending the prev email and I didn't immediately see.  I search
return and they all return NULL except the return pfn_to_page(pfn), so
is pfn_to_page that returns -EFAULT (the implementations I checked
don't but there are plenty that I didn't check...).
