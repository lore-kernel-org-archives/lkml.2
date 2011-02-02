Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752434Ab1BBFok (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 00:44:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36163 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751399Ab1BBFoj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 00:44:39 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Tejun Heo <tj@kernel.org>
X-Fcc: ~/Mail/linus
Cc: oleg@redhat.com, jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [PATCH 06/10] signal: fix premature completion of group stop
 when interfered by ptrace
In-Reply-To: Tejun Heo's message of  Monday, 31 January 2011 12:00:07 +0100 <20110131110007.GF7459@htj.dyndns.org>
References: <1296227324-25295-1-git-send-email-tj@kernel.org>
	<1296227324-25295-7-git-send-email-tj@kernel.org>
	<20110128212257.9C18B183C1E@magilla.sf.frob.com>
	<20110131110007.GF7459@htj.dyndns.org>
X-Windows: the cutting edge of obsolescence.
Message-Id: <20110202054405.D78AE183D88@magilla.sf.frob.com>
Date: Tue,  1 Feb 2011 21:44:05 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I have plans on separate out ptrace related stuff from task_struct so
> that they're allocate iff they're used which will save some tens of
> bytes on the task struct, so there at least is a plan to compensate
> for the added cruft.

My, that sounds familiar.  Oleg and I have pursued that before, though
not in exactly the same context.  It sure gets complicated quickly in
the corners.  But we would still like to see it get done one way or
another.

> > But I'm not entirely convinced that we'll really need them when we
> > conclude on fully cleaning up the whole picture.
> 
> I really don't know at this point.  I tried to make it share one of
> the related fields but there needs to be a per-task field which is
> protected by siglock and there currently isn't any, so...

My point was that I am not yet convinced we'll need any new bookkeeping of
that sort once we fully work out the group-stop interactions.  We're still
discussing that in the other threads.  So we'll see where that goes.


Thanks,
Roland
