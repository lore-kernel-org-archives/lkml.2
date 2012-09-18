Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751038Ab2IRQPt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 12:15:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39003 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770Ab2IRQPq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 12:15:46 -0400
Date: Tue, 18 Sep 2012 17:15:29 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, Jens Axboe <axboe@kernel.dk>,
        Jeff Garzik <jeff@garzik.org>, Boaz Harrosh <bharrosh@panasas.com>,
        Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH v10 8/8] block: Add bio_clone_bioset(),
	bio_clone_kmalloc()
Message-ID: <20120918161529.GB17356@agk-dp.fab.redhat.com>
Mail-Followup-To: Kent Overstreet <koverstreet@google.com>,
	linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
	dm-devel@redhat.com, Jens Axboe <axboe@kernel.dk>,
	Jeff Garzik <jeff@garzik.org>, Boaz Harrosh <bharrosh@panasas.com>,
	Alasdair Kergon <agk@redhat.com>
References: <1346970902-10931-1-git-send-email-koverstreet@google.com> <1346970902-10931-9-git-send-email-koverstreet@google.com> <20120914215059.GQ15728@agk-dp.fab.redhat.com> <20120917204227.GA14492@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120917204227.GA14492@google.com>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: 64 Baker Street, 4th floor, London,
	W1U 7DF.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2012 at 01:42:27PM -0700, Kent Overstreet wrote:
> Previously, it was open coding __bio_clone(), that's what the setting
> bi_idx to 0 was from. With the change to bio_clone_bioset() that's no
> longer necessary (and dangerous, since bi_idx needs to be consistent
> with bi_sector/bi_size).
 
It was performing a partial clone, deleting any no-longer-needed entries
from the array.  This patch undoes that which is presumably OK because
you propose to eliminate them again in a later one of your patches.

Alasdair

