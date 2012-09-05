Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759245Ab2IEUNw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 16:13:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64825 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753657Ab2IEUNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 16:13:50 -0400
Date: Wed, 5 Sep 2012 13:13:46 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, vgoyal@redhat.com, mpatocka@redhat.com,
        bharrosh@panasas.com, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v7 3/9] block: Add bio_reset()
Message-ID: <20120905201346.GG25236@google.com>
References: <1346175456-1572-1-git-send-email-koverstreet@google.com>
 <1346175456-1572-4-git-send-email-koverstreet@google.com>
 <20120828203148.GB24608@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120828221715.GD1048@moria.home.lan>
 <20120901022305.GE19535@dhcp-172-17-108-109.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120901022305.GE19535@dhcp-172-17-108-109.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 31, 2012 at 07:23:05PM -0700, Tejun Heo wrote:
> On Tue, Aug 28, 2012 at 03:17:15PM -0700, Kent Overstreet wrote:
> > I still think they should be symmetrical, but if that's true bi_ioc and
> > bi_css need to be moved, and also bio_disassociate_task() should be
> > getting called from bio_free(), not bio_put().
> > 
> > Were you the one that added that call? I know you've been working on
> > that area of the code recently. Sticking it in bio_put() instead of
> > bio_free() seems odd to be, and they're completely equivalent now that
> > bio_free() is only called from bio_put() (save one instance I should
> > probably fix).
> 
> Maybe I botched symmetry but anyways I *suspect* it probably would be
> better to keep css association across bio_reset() give the current
> usages of both mechanisms.  css association indicates the ownership of
> the bio which isn't likely to change while recycling the bio.

Thought about it more and while you're right that css association isn't
likely to change, it'd just be a needless difference. bio_reset() should
be as close to a bio_free()/bio_alloc() as possible, IMO.

Fixed my patches to do it right, though.
