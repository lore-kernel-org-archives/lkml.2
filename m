Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518Ab1F2Aym (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 20:54:42 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:26059 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753128Ab1F2Ayf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 20:54:35 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Al0DAIN3Ck55LChDgWdsb2JhbABSp0IVAQEWJiXJew6GIgSaF4gs
Date: Wed, 29 Jun 2011 10:54:22 +1000
From: Dave Chinner <david@fromorbit.com>
To: Curt Wohlgemuth <curtw@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] writeback: Don't wait for completion in
 writeback_inodes_sb_nr
Message-ID: <20110629005422.GQ32466@dastard>
References: <1309304616-8657-1-git-send-email-curtw@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309304616-8657-1-git-send-email-curtw@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 28, 2011 at 04:43:35PM -0700, Curt Wohlgemuth wrote:
> Contrary to the comment block atop writeback_inodes_sb_nr(),
> we *were* calling
> 
>         wait_for_completion(&done);
> 
> which should not be done, as this is not called for data
> integrity sync.
> 
> Signed-off-by: Curt Wohlgemuth <curtw@google.com>

The comment says it does not wait for IO to be -completed-.

The function as implemented waits for IO to be *submitted*.

This provides the callers with same blocking semantics (i.e. request
queue full) as if the caller submitted the IO themselves. The code
that uses this function rely on this blocking to delay the next set
of operations they do until after IO has been started, so removing
the completion will change their behaviour significantly.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
