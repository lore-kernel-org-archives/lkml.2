Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932784Ab0EYScK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 14:32:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52242 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932294Ab0EYScI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 14:32:08 -0400
Date: Tue, 25 May 2010 14:30:51 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Will Drewry <wad@chromium.org>, Alasdair G Kergon <agk@redhat.com>,
       linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
       Nick Piggin <npiggin@suse.de>, Tejun Heo <tj@kernel.org>,
       Scott James Remnant <scott@ubuntu.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Harald Hoyer <harald@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH 2/2] init, mount: export the name_to_dev_t symbol
Message-ID: <20100525183051.GA692@redhat.com>
References: <1274802411-26613-1-git-send-email-wad@chromium.org>
 <1274802411-26613-2-git-send-email-wad@chromium.org>
 <20100525155535.GA811@infradead.org>
 <20100525160550.GC28588@agk-dp.fab.redhat.com>
 <AANLkTin6Nt2TqxlF9kQJZThI7pZ6wqAwSlg9GnqkKB-v@mail.gmail.com>
 <20100525172110.GA6046@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100525172110.GA6046@infradead.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 25 2010 at  1:21pm -0400,
Christoph Hellwig <hch@infradead.org> wrote:

> On Tue, May 25, 2010 at 11:11:33AM -0500, Will Drewry wrote:
> > In addition to getting rid of the code duplication, I'd like device-mapper
> > to be able to resolve slave devices at boot-time to accommodate a
> > do_mounts_dm.c equivalent to do_mounts_md.c:
> 
> So please add a do_mounts_dm.c instead of pushing this somewhere it
> doesn't belong to.

He is proposing doing just that, you cut out the patchwork url he
already shared: https://patchwork.kernel.org/patch/101024/

Will's intentions are good: avoid code duplication.

He is also trying to keep DM-specific common code in drivers/md/

So in this instance, avoiding the need to export name_to_dev_t would
require splitting the internal DM __table_get_device (or more likely:
dm_get_device) out to a public facing interface that takes a dev_t.

Mike
