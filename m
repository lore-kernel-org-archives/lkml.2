Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095Ab1IVVUy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 17:20:54 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59946 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753914Ab1IVVUv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 17:20:51 -0400
Subject: Re: [PATCH 3/3] seq_file: convert seq buffer to vmalloc
From: Peter Zijlstra <peterz@infradead.org>
To: Joe Perches <joe@perches.com>
Cc: Colin Cross <ccross@android.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>
Date: Thu, 22 Sep 2011 23:20:25 +0200
In-Reply-To: <1316725632.29447.21.camel@Joe-Laptop>
References: <1316725029-22737-1-git-send-email-ccross@android.com>
	 <1316725029-22737-4-git-send-email-ccross@android.com>
	 <1316725632.29447.21.camel@Joe-Laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1316726425.31040.35.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-22 at 14:07 -0700, Joe Perches wrote:
> On Thu, 2011-09-22 at 13:57 -0700, Colin Cross wrote:
> > seq_files are often used for debugging.  When things are going wrong
> > due to failed physically contiguous allocations, the exponentially
> > growing physically contiguous allocations in seq_read can make things
> > worse.  There is no need for physically contiguous memory, so switch
> > to virtually contiguous memory instead.
> 
> vmalloc's are relatively expensive.

And very limited on certain archs..

> Perhaps use kmalloc when appropriate instead?
> 
> []
> > -	/* don't ask for more than the kmalloc() max size */
> > -	if (size > KMALLOC_MAX_SIZE)
> > -		size = KMALLOC_MAX_SIZE;
> > -
> > -	buf = kmalloc(size, GFP_KERNEL);
> > +	buf = vmalloc(size);
> >  	if (!buf)
> >  		return -ENOMEM;
> 
> 	if (size > KMALLOC_MAX_SIZE)
> 		buf = vmalloc(size, GFP_KERNEL)
> 	else
> 		buf = kmalloc(size, GFP_KERNEL)

There's wrappers for this stuff IIRC, that said all this is a horrible
idea. Just avoid the situation instead of coping with it.
