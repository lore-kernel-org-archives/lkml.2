Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487Ab0DFLU3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 07:20:29 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39899 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753071Ab0DFLUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 07:20:22 -0400
Subject: Re: [RFC][PATCH] lockdep: WARN about local_irq_{en,dis}able in NMI
 context
From: Peter Zijlstra <peterz@infradead.org>
To: David Miller <davem@davemloft.net>
Cc: fweisbec@gmail.com, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu, acme@redhat.com,
       paulus@samba.org
In-Reply-To: <20100406.041342.183031470.davem@davemloft.net>
References: <20100405194055.GA5265@nowhere>
	 <20100406.025049.267615796.davem@davemloft.net>
	 <1270552321.1595.42.camel@laptop>
	 <20100406.041342.183031470.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 06 Apr 2010 13:20:19 +0200
Message-ID: <1270552819.1595.63.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-04-06 at 04:13 -0700, David Miller wrote:
> From: Peter Zijlstra <peterz@infradead.org>
> Date: Tue, 06 Apr 2010 13:12:01 +0200
> 
> > One thing we can do is make the code WARN about this, how about
> > something like the below
> 
> It's going to warn every bootup in cpu_clock() on x86.

*sigh*, yes, we could hack around that I suppose.. it would be nice to
automate this check though, I bet you don't fancy tracking down more
such splats than you have to.

You could of course insert the debug code into your arch routines but
that would limit the coverage checks to whatever you happen to run.

