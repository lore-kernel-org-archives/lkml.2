Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109Ab0LVVV1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 16:21:27 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53340 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751841Ab0LVVV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 16:21:26 -0500
Date: Wed, 22 Dec 2010 22:21:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Tejun Heo <tj@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Len Brown <lenb@kernel.org>,
        Jack Steiner <steiner@sgi.com>, Lori Gilbertson <loriann@sgi.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Early kernel messages are overflowing the static log buffer
Message-ID: <20101222212112.GC3139@elte.hu>
References: <4D06B317.2090608@sgi.com>
 <20101222130946.GC13412@elte.hu>
 <20101222131719.GA8061@htj.dyndns.org>
 <4D1249ED.9040008@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D1249ED.9040008@sgi.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Travis <travis@sgi.com> wrote:

> Thanks.
> 
> I have a patchset almost ready for submission.  We have a giant
> system (6 racks with some huge amount of nodes) for a few more
> days, and the buffer still overflowed with my changes.  So I'm
> making one more tweak to cut down the amount of characters generated
> without losing information.

Also feel free to make judgement calls to cut information - people _think_ they need 
all that boot time noise but it's rarely useful. Memory layout is - but a lot of 
other details are not. So dont try to preserve things at any cost.

> This doesn't really help the log buffer overflow problem as KERN_DEBUG
> messages still end up in the buffer.  The pr_debug() macro does compile
> out the messages if the system does not have KERNEL debug set, though
> distros also have this set as a default.

Make the whole printout dependent on a percpu-debug boot parameter? (and default the 
switch to off?)

Thanks,

	Ingo
