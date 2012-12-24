Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408Ab2LXTlN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 14:41:13 -0500
Received: from mail.skyhub.de ([78.46.96.112]:49557 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753326Ab2LXTlL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 14:41:11 -0500
Date: Mon, 24 Dec 2012 20:41:01 +0100
From: Borislav Petkov <bp@alien8.de>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 25/25] ipc: don't use [delayed_]work_pending()
Message-ID: <20121224194101.GC5344@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>, Tejun Heo <tj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <1356141435-17340-1-git-send-email-tj@kernel.org>
 <1356141435-17340-26-git-send-email-tj@kernel.org>
 <20121221181523.0e0998e4.akpm@linux-foundation.org>
 <20121222022210.GA30177@htj.dyndns.org>
 <20121222110929.GA3567@liondog.tnic>
 <20121224183334.GB11817@htj.dyndns.org>
 <20121224184520.GC11817@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20121224184520.GC11817@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 24, 2012 at 10:45:20AM -0800, Tejun Heo wrote:
> I was confused a bit there. We can't. Nothing guarantees that the
> queuer sees the cleared PENDING before the work item starts execution,
> and I think ipc memory hotplug could also be broken from that.

Stupid question: why not clear PENDING after execution is done? I'm
looking at process_one_work() here.

> It's highly unlikely to actually happen and there may be external
> locking which prevents the race from actually happening, but there's
> nothing synchronizing queueing and the execution of the work item.
> Looking at that part of code only, it's possible that it fails to
> queue the work item after a memory hotplug event even though the
> previous queueing already started execution and processed a couple
> notifiers.

Maybe failure to queue could be signalled with a proper return value
from __queue_work()?

Btw, I'm afraid I don't understand the "memory hotplug event" aspect and
how that can influence the queueing - all it does it is list_add_tail,
basically.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
