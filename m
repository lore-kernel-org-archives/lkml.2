Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757019Ab2ENQtv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 12:49:51 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:42491 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754894Ab2ENQtu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 12:49:50 -0400
Message-ID: <1337014188.29436.18.camel@joe2Laptop>
Subject: Re: [PATCH] floppy: remove floppy-specific O_EXCL handling
From: Joe Perches <joe@perches.com>
To: Tejun Heo <tj@kernel.org>
Cc: Jiri Kosina <jkosina@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, NeilBrown <neilb@suse.de>,
        linux-kernel@vger.kernel.org
Date: Mon, 14 May 2012 09:49:48 -0700
In-Reply-To: <20120514162521.GA2366@google.com>
References: <alpine.LNX.2.00.1205131059410.15448@pobox.suse.cz>
	 <20120514162521.GA2366@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-05-14 at 09:25 -0700, Tejun Heo wrote:
> Hello,
> 
> On Sun, May 13, 2012 at 11:02:07AM +0200, Jiri Kosina wrote:
> > Block layer now handles O_EXCL in a generic way for block devices.
> > 
> > The semantics is however different for floppy and all other block devices,
> > as floppy driver contains its own O_EXCL handling.
> > 
> > The semantics for all-but-floppy bdevs is "there can be at most one O_EXCL 
> > open of this file", while for floppy bdev the semantics is "if someone has 
> > the bdev open with O_EXCL, noone else can open it".
> > 
> > Remove the floppy-specific handling and let the generic bdev code O_EXCL
> > handling take over.
> > 
> > Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> 
> Patch looks good to me but why do we want to change this at this
> point?

Because the hobgoblins of consistency are as fun to hunt as the wumpus?


