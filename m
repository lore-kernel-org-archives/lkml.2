Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968Ab2BBUgP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 15:36:15 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44856 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838Ab2BBUgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 15:36:13 -0500
Date: Thu, 2 Feb 2012 12:36:09 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET] blkcg: unify blkgs for different policies
Message-ID: <20120202203609.GI19837@google.com>
References: <1328131156-13290-1-git-send-email-tj@kernel.org>
 <20120202192958.GA1723@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120202192958.GA1723@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Feb 02, 2012 at 02:29:58PM -0500, Vivek Goyal wrote:
> On Wed, Feb 01, 2012 at 01:19:05PM -0800, Tejun Heo wrote:
> 
> [..]
> > 
> > * use unified stats updated under queue lock and drop percpu stats
> >   which should fix locking / context bug across percpu allocation.
> 
> Does that mean that stat updation will happen under queue lock even if
> there are no throttling rules? That will introduce extra queue lock on
> fast path those who have throttling compiled in but are not using (common
> case for distributions).

No, I don't think extra locking would be necessary at all.  We end up
grabbing queue_lock anyway.  It's just the matter of where to update
the stats.

Thanks.

-- 
tejun
