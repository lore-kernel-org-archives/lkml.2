Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841Ab1J0QZA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 12:25:00 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:65507 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938Ab1J0QZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 12:25:00 -0400
Date: Thu, 27 Oct 2011 09:24:54 -0700
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/13] block, cfq: misc updates to cfq_io_context
Message-ID: <20111027162454.GC29899@google.com>
References: <1319593719-19132-1-git-send-email-tj@kernel.org>
 <1319593719-19132-7-git-send-email-tj@kernel.org>
 <20111027153901.GG7491@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111027153901.GG7491@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Vivek.

On Thu, Oct 27, 2011 at 11:39:01AM -0400, Vivek Goyal wrote:
> On Tue, Oct 25, 2011 at 06:48:32PM -0700, Tejun Heo wrote:
> > Make the following changes to prepare for ioc/cic management cleanup.
> > 
> > * Add cic->q so that ioc can determine the associated queue without
> >   querying cfq.  This will eventually replace ->key.
> 
> Not sure what's the advantage of storing cic->q instead of cic->cfqd.
> In blk-ioc code getting to cic's queue becomes easier but then reaching
> to cfqd in cfq code becomes much longer.

It's primarily for API separation.  Currently, io_context and cfq are
intermixed without clear layer of separation.  The optimization of
avoiding one indirect deref at this level isn't worth blurring API
boundaries especially when the cachelines being derefed are known to
be hot (we're deep in elevator path after all).  I'm working on a
patchset to make proper separation between them.  If reducing that one
indrect load proves to be worthwhile (I'm extremely skeptical tho), we
can use another another caching entry in cic.

Thanks.

-- 
tejun
