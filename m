Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757813Ab2IDVDm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 17:03:42 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41934 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757610Ab2IDVDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 17:03:41 -0400
Date: Tue, 4 Sep 2012 14:03:42 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, bharrosh@panasas.com,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v7 9/9] block: Avoid deadlocks with bio allocation by
 stacking drivers
Message-ID: <20120904210342.GA8724@dhcp-172-17-108-109.mtv.corp.google.com>
References: <Pine.LNX.4.64.1208291210180.774@file.rdu.redhat.com>
 <20120829165006.GB20312@google.com>
 <20120829170711.GC12504@redhat.com>
 <20120829171345.GC20312@google.com>
 <20120830220745.GI27257@redhat.com>
 <20120831014359.GB15218@moria.home.lan>
 <Pine.LNX.4.64.1209031638110.15620@file.rdu.redhat.com>
 <20120904034100.GA21602@moria.home.lan>
 <20120904185540.GC3638@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120904194237.GC25236@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120904194237.GC25236@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Sep 04, 2012 at 12:42:37PM -0700, Kent Overstreet wrote:
> You want to point me at the relevant workqueue code? I'd really like to
> see what you did there, it's entirely possible you're aware of some
> issue I'm not but if not I'd like to take a stab at it.

I was mistaken.  The issue was that adding @gfp_flags to
kthread_create() wasn't trivial involving updates to arch callbacks,
so the timer was added to side-step the issue.  So, yeah, if it can be
made to work w/o timer, I think that would be better.

Thanks.

-- 
tejun
