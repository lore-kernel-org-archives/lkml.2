Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751637Ab2IRQcR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 12:32:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17801 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750992Ab2IRQcO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 12:32:14 -0400
Date: Tue, 18 Sep 2012 17:31:57 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, Jens Axboe <axboe@kernel.dk>,
        Lars Ellenberg <lars.ellenberg@linbit.com>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [dm-devel] [PATCH v10 1/8] block: Generalized bio pool freeing
Message-ID: <20120918163156.GC17356@agk-dp.fab.redhat.com>
Mail-Followup-To: Kent Overstreet <koverstreet@google.com>,
	linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
	dm-devel@redhat.com, Jens Axboe <axboe@kernel.dk>,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	Hannes Reinecke <hare@suse.de>
References: <1346970902-10931-1-git-send-email-koverstreet@google.com> <1346970902-10931-2-git-send-email-koverstreet@google.com> <20120914182828.GK15728@agk-dp.fab.redhat.com> <20120917205139.GB14492@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120917205139.GB14492@google.com>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: 64 Baker Street, 4th floor, London,
	W1U 7DF.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2012 at 01:51:39PM -0700, Kent Overstreet wrote:
> That isn't a very good patch - it says it's clearing bi_end_io as a
> precaution, but as a precaution to what?
 
As a precaution against the endio function being called an extra time by
mistake if a stray reference remains after the bio has been freed.
Wipe this field when dm frees it.  Defensive programming, basically,
in response to a tricky bug he had to deal with.

Alasdair

