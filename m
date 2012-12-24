Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376Ab2LXS4E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 13:56:04 -0500
Received: from mail.skyhub.de ([78.46.96.112]:42290 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753129Ab2LXSz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 13:55:59 -0500
Date: Mon, 24 Dec 2012 19:55:55 +0100
From: Borislav Petkov <bp@alien8.de>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 25/25] ipc: don't use [delayed_]work_pending()
Message-ID: <20121224185555.GA5344@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>, Tejun Heo <tj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <1356141435-17340-1-git-send-email-tj@kernel.org>
 <1356141435-17340-26-git-send-email-tj@kernel.org>
 <20121221181523.0e0998e4.akpm@linux-foundation.org>
 <20121222022210.GA30177@htj.dyndns.org>
 <20121222110929.GA3567@liondog.tnic>
 <20121224183334.GB11817@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20121224183334.GB11817@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 24, 2012 at 10:33:34AM -0800, Tejun Heo wrote:
> If one looks at something happening in a path as cold as memory
> hotplug and thinks about optimizing a coupld memory accesses, the
> person's priorities need serious reconsideration. I think approaches
> like that are actively harmful. They lead to unnecessary (and thus
> difficult to comprehend) convolutions which don't really help anything
> while deteoriorating code base.

Maybe I'm not expressing myself clearly enough so let me try again: all
I'm saying is, I don't like the idea of needlessly toggling interrupts
and having a locked operation just to understand that there's work
pending.

Basically, with the amount of bloat we're adding to the kernel, the
couple of instructions we're adding here and there and think they won't
harm us, tends to crop up with time until we're too damn slow to do
anything.

Now, you're saying that optimizing cold paths is something that calls
for serious reconsideration of a person's priorities, and I'm saying
just don't do anything in code that's not necessary. Fullstop. If this
is leading to convolutions, then the design is suboptimal and needs
adjustment. If [delayed_]work_pending is being abused, then fix it or
add a new primitive which only checks for pending work and doesn't
unconditionally toggle interrupts.

> I don't think we have cases where this actually matters but it could
> be that we can add work_pending() tests to queue_work_on(). I *think*
> that shouldn't break work scheduling semantics. Not completely sure
> tho. Need to think about it more.

Yes, something like that.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
