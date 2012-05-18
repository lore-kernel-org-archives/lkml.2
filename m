Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965705Ab2ERSud (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 14:50:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45997 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757021Ab2ERSua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 14:50:30 -0400
Date: Fri, 18 May 2012 11:50:27 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Tejun Heo <tj@kernel.org>, axboe@kernel.dk, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, agk@redhat.com,
        Junichi Nomura <j-nomura@ce.jp.nec.com>,
        Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [dm-devel] [PATCH 02/13] dm: kill dm_rq_bio_destructor
Message-ID: <20120518185027.GA9673@google.com>
References: <cover.1337308722.git.koverstreet@google.com>
 <f07bc0f57562d98078e0f4c507cae165aa159e7c.1337308722.git.koverstreet@google.com>
 <20120518155729.GB19388@google.com>
 <20120518164319.GJ29330@agk-dp.fab.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120518164319.GJ29330@agk-dp.fab.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 05:43:19PM +0100, Alasdair G Kergon wrote:
> On Fri, May 18, 2012 at 08:57:29AM -0700, Tejun Heo wrote:
> > Please explain why this is done and how it's safe.  Alasdair / dm
> > folks, can you please ack this?
>  
> I think it's relying on there being never more than one reference on those 
> bios so that that endio fn, called exactly once, always frees it and there
> are no dm_puts elsewhere.

Is that a safe assumption? From my perusal of the code it certainly
looks like it should be, but I don't know dm all that well.

Seems like it might be better to use bio set's front_pad to put it in
the same allocation as the bio, but I don't really want to get into that
myself.
