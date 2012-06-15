Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756730Ab2FOLrc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 07:47:32 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60776 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754923Ab2FOLrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 07:47:31 -0400
Date: Fri, 15 Jun 2012 12:47:25 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] irq/core changes for v3.5
Message-ID: <20120615114725.GC24246@sirena.org.uk>
References: <20120522032554.GA11358@gmail.com>
 <Pine.LNX.4.64.1206121201130.6800@axis700.grange>
 <alpine.LFD.2.02.1206121639420.3086@ionos>
 <CA+55aFxNy2-DnWVDUiOuF+NncRBUC=frZN+CTLsJ+o2ofXtZYQ@mail.gmail.com>
 <alpine.LFD.2.02.1206121732230.3086@ionos>
 <CA+55aFxC0436vCDwX8nUnKNa3ZZi=ZhL0w6eMk0hM3oKTz4LJw@mail.gmail.com>
 <Pine.LNX.4.64.1206130857070.17854@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1206130857070.17854@axis700.grange>
X-Cookie: Flame on!
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2012 at 09:03:27AM +0200, Guennadi Liakhovetski wrote:

> To make this simpler I'm attaching below a list of (I think) all 
> occurrences of the invalid request_threaded_irq() uses.

Scanning through the list most of these are for internal IRQs from MFDs
where it'd be a bug if the primary IRQ ever existed in the first place
as we're already in threaded context, though obviously there's no
problem with them marking themselves as _ONESHOT.
