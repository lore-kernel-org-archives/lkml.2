Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759902Ab0HEIK5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 04:10:57 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52927 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759708Ab0HEIKz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 04:10:55 -0400
Subject: Re: lockdep and oops_in_progress
From: Peter Zijlstra <peterz@infradead.org>
To: Dave Airlie <airlied@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <AANLkTi=gnsPUPomCUXRLgV0PhNxtBaXiCheDU=yRV0Kx@mail.gmail.com>
References: <AANLkTi=gnsPUPomCUXRLgV0PhNxtBaXiCheDU=yRV0Kx@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 05 Aug 2010 10:10:49 +0200
Message-ID: <1280995849.1923.1515.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-05 at 16:21 +1000, Dave Airlie wrote:
> Hi guys,
> 
> I was debugging a wierd issue with suspend/resume and fbcon/X with
> some recent work Jesse and myself did to try and make sure a pinned
> fbcon always gets the text on it with a panic or oops occurs.
> 
> It does this by testing the oops_in_progress flag, however once any
> lockdep issue occurs it looks to me that we leave this flag set
> forever, in most places I can see in oops code etc they call
> bust_spinlocks(1) then bust_spinlocks(0) to balance the
> oops_in_progress value, but lockdep never seems to reset it.
> 
> I'm wondering if there is an inherent reason for this or if I whip up
> a patch to reset once the lockdep is printed if this would cause any
> issues?

That's debug_locks_off(), right? I don't think there's a particular
reason we keep it set, cleaning that up might take a bit of work but
shouldn't be too hard.

Ingo, do you remember anything about that?, I think that bit comes from
before my time.
