Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757859Ab2HXFKO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 01:10:14 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55179 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755730Ab2HXFKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 01:10:10 -0400
Date: Thu, 23 Aug 2012 22:09:36 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, vgoyal@redhat.com, mpatocka@redhat.com,
        bharrosh@panasas.com, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v6 05/13] block: Kill bi_destructor
Message-ID: <20120824050935.GB11977@moria.home.lan>
References: <1345655050-28199-1-git-send-email-koverstreet@google.com>
 <1345655050-28199-6-git-send-email-koverstreet@google.com>
 <20120822200032.GH19212@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120822200032.GH19212@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2012 at 01:00:32PM -0700, Tejun Heo wrote:
> Hello,
> 
> On Wed, Aug 22, 2012 at 10:04:02AM -0700, Kent Overstreet wrote:
> > +#define BIO_KMALLOC_POOL NULL
> 
> I would much prefer just doing
> 
> 	if (!bs) {
> 		/* do kmalloc/kfree thing */
> 	} else {
> 		/* do bioset thing */
> 	}
> 
> NULL @bs indicating no bioset is perfectly natural and so is using
> generic memory allocation in the absense of bioset.  I don't see any
> value in defining Bio_KMALLOC_POOL to be NULL.

Eh, kind of disagree but at this point I don't care that much, I'll
change it.
