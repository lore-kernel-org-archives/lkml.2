Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932160Ab2JBWR3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 18:17:29 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:44073 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669Ab2JBWR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 18:17:26 -0400
Date: Tue, 2 Oct 2012 15:17:23 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk,
        "Martin K. Petersen" <martin.petersen@oracle.com>, tj@kernel.org
Subject: Re: [dm-devel] [PATCH v3 02/26] block: Convert integrity to
 bvec_alloc_bs()
Message-ID: <20121002221723.GX26488@google.com>
References: <1348526106-17074-1-git-send-email-koverstreet@google.com>
 <1348526106-17074-3-git-send-email-koverstreet@google.com>
 <20121002151202.GE758@redhat.com>
 <20121002205249.GR26488@google.com>
 <20121002220553.GD14471@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121002220553.GD14471@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2012 at 06:05:53PM -0400, Vivek Goyal wrote:
> On Tue, Oct 02, 2012 at 01:52:50PM -0700, Kent Overstreet wrote:
> > On Tue, Oct 02, 2012 at 11:12:02AM -0400, Vivek Goyal wrote:
> > > On Mon, Sep 24, 2012 at 03:34:42PM -0700, Kent Overstreet wrote:
> > > > This adds a pointer to the bvec array to struct bio_integrity_payload,
> > > > instead of the bvecs always being inline; then the bvecs are allocated
> > > > with bvec_alloc_bs().
> > > 
> > > Ok, you are introducing bio_vec pointer in this patch. May be we can
> > > do it earlier so that we take care of bio pair related issue.
> > 
> > I was just trying to make the bugfix patch small, since people
> > complained about too much stuff being done in one patch.
> 
> Can't we introduce the pointer while we retain bip_slabs as it is. Then
> this patch will be small. I think this patch is big only because you
> are trying to allocate integrity vecs from bio_set out of line.

Ok - yeah, that makes sense to break out. I think I'll just make the
integrity stuff a separate patch series, it's going to be like 4 patches
now.
