Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756121Ab2IQUme (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 16:42:34 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54850 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010Ab2IQUmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 16:42:32 -0400
Date: Mon, 17 Sep 2012 13:42:27 -0700
From: Kent Overstreet <koverstreet@google.com>
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, Jens Axboe <axboe@kernel.dk>,
        Jeff Garzik <jeff@garzik.org>, Boaz Harrosh <bharrosh@panasas.com>,
        Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH v10 8/8] block: Add bio_clone_bioset(),
 bio_clone_kmalloc()
Message-ID: <20120917204227.GA14492@google.com>
References: <1346970902-10931-1-git-send-email-koverstreet@google.com>
 <1346970902-10931-9-git-send-email-koverstreet@google.com>
 <20120914215059.GQ15728@agk-dp.fab.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120914215059.GQ15728@agk-dp.fab.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 10:50:59PM +0100, Alasdair G Kergon wrote:
> On Thu, Sep 06, 2012 at 03:35:02PM -0700, Kent Overstreet wrote:
> > Previously, there was bio_clone() but it only allocated from the fs bio
> > set; as a result various users were open coding it and using
> > __bio_clone().
> 
> Explain in the header the reasoning behind the change to dm-crypt so that 
> it no longer resets bi_idx to 0 too?
> 
> > -	clone->bi_idx = 0;

Previously, it was open coding __bio_clone(), that's what the setting
bi_idx to 0 was from. With the change to bio_clone_bioset() that's no
longer necessary (and dangerous, since bi_idx needs to be consistent
with bi_sector/bi_size).
