Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362Ab2LXSdn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 13:33:43 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:64130 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183Ab2LXSdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 13:33:41 -0500
Date: Mon, 24 Dec 2012 10:33:34 -0800
From: Tejun Heo <tj@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 25/25] ipc: don't use [delayed_]work_pending()
Message-ID: <20121224183334.GB11817@htj.dyndns.org>
References: <1356141435-17340-1-git-send-email-tj@kernel.org>
 <1356141435-17340-26-git-send-email-tj@kernel.org>
 <20121221181523.0e0998e4.akpm@linux-foundation.org>
 <20121222022210.GA30177@htj.dyndns.org>
 <20121222110929.GA3567@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121222110929.GA3567@liondog.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Borislav.

On Sat, Dec 22, 2012 at 12:09:29PM +0100, Borislav Petkov wrote:
> Now you say those paths are not fast paths, but the reverse of
> this optimization is also true: what happens if people start using
> schedule_work() in fast paths without checking whether work is pending?
> A useless IRQ disable + locked operation + IRQ enable.

That's a really strange argument.  If we extend from that, we have to
optimize cold paths to prevent fast paths copy from them, which sounds
really silly to me.

If one looks at something happening in a path as cold as memory
hotplug and thinks about optimizing a coupld memory accesses, the
person's priorities need serious reconsideration.  I think approaches
like that are actively harmful.  They lead to unnecessary (and thus
difficult to comprehend) convolutions which don't really help anything
while deteoriorating code base.

I don't think we have cases where this actually matters but it could
be that we can add work_pending() tests to queue_work_on().  I *think*
that shouldn't break work scheduling semantics.  Not completely sure
tho.  Need to think about it more.

Thanks.

-- 
tejun
