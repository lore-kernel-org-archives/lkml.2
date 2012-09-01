Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452Ab2IACNv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 22:13:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33748 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755352Ab2IACNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 22:13:49 -0400
Date: Fri, 31 Aug 2012 19:13:48 -0700
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Kent Overstreet <koverstreet@google.com>,
        Mikulas Patocka <mpatocka@redhat.com>, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com,
        bharrosh@panasas.com, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v7 9/9] block: Avoid deadlocks with bio allocation by
 stacking drivers
Message-ID: <20120901021348.GB19535@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1346175456-1572-1-git-send-email-koverstreet@google.com>
 <1346175456-1572-10-git-send-email-koverstreet@google.com>
 <Pine.LNX.4.64.1208291210180.774@file.rdu.redhat.com>
 <20120829165006.GB20312@google.com>
 <20120829170711.GC12504@redhat.com>
 <20120829171345.GC20312@google.com>
 <20120830220745.GI27257@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120830220745.GI27257@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Vivek.

On Thu, Aug 30, 2012 at 06:07:45PM -0400, Vivek Goyal wrote:
> Here is one quick and dirty proof of concept patch. It checks for stack
> depth and if remaining space is less than 20% of stack size, then it
> defers the bio submission to per queue worker.

So, it removes breadth-first walking of bio construction by ensuring
stack overflow never happens by bouncing to workqueue if stack usage
seems too high.

I do like removal of breadth-first walking.  It makes failure
scenarios a lot less mind-bending.  That said, Kent is right that this
can incur significant overhead for certain configurations, and looking
at stack usage in block layer is rather nasty both in design and
implementation.

If we're gonna need rescuer anyway and can get it right and the
mechanism can be contained in block proper relatively well, I think it
would be better to make bread-first walking safe.  Both are nasty in
their own ways after all.

Thanks.

-- 
tejun
