Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891Ab1DGQmu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 12:42:50 -0400
Received: from one.firstfloor.org ([213.235.205.2]:44737 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860Ab1DGQms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 12:42:48 -0400
Date: Thu, 7 Apr 2011 18:42:45 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andy Lutomirski <luto@mit.edu>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFT/PATCH v2 2/6] x86-64: Optimize vread_tsc's barriers
Message-ID: <20110407164245.GA21838@one.firstfloor.org>
References: <cover.1302137785.git.luto@mit.edu> <80b43d57d15f7b141799a7634274ee3bfe5a5855.1302137785.git.luto@mit.edu> <BANLkTi=RkeFMpcb36RrJ=+eYm-xk4B2zYw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=RkeFMpcb36RrJ=+eYm-xk4B2zYw@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> But before that, I would check that the second lfence is needed AT
> ALL. I don't know whether we ever tried the "only barrier before"
> version, because quite frankly, if you call this thing in a loop, then

> a single barrier will still mean that there are barriers in between
> iterations. So...

The testers will call it in a loop, but real users (e.g. using it for
a logging timestamp) may not.

I'm sure a single barrier would have fixed the testers, as you point out,
but the goal wasn't to only fix testers.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
