Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053Ab0DURrB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 13:47:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13853 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753978Ab0DURrA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 13:47:00 -0400
Date: Wed, 21 Apr 2010 19:46:15 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Rik van Riel <riel@redhat.com>
Cc: Dan Carpenter <error27@gmail.com>, Izik Eidus <ieidus@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, kernel-janitors@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] ksm: check for ERR_PTR from follow_page()
Message-ID: <20100421174615.GO32034@random.random>
References: <20100421102759.GA29647@bicker>
 <4BCF18A8.8080809@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BCF18A8.8080809@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 21, 2010 at 11:24:24AM -0400, Rik van Riel wrote:
> On 04/21/2010 06:27 AM, Dan Carpenter wrote:
> > The follow_page() function can potentially return -EFAULT so I added
> > checks for this.
> >
> > Also I silenced an uninitialized variable warning on my version of gcc
> > (version 4.3.2).
> >
> > Signed-off-by: Dan Carpenter<error27@gmail.com>
> 
> Acked-by: Rik van Riel <riel@redhat.com>

  	    	while (!(page = follow_page(vma, start, foll_flags)))
  	    	{

gup only checks for null, so when exactly is follow_page going to
return -EFAULT? It's not immediately clear.
