Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758072Ab1JEPeN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 11:34:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:57013 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758049Ab1JEPeL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 11:34:11 -0400
Subject: Re: big picture UDP/IP performance question re 2.6.18  -> 2.6.32
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Christoph Lameter <cl@gentwo.org>
Cc: starlight@binnacle.cx, Eric Dumazet <eric.dumazet@gmail.com>,
        linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Willy Tarreau <w@1wt.eu>, Ingo Molnar <mingo@elte.hu>
Date: Wed, 05 Oct 2011 17:33:47 +0200
In-Reply-To: <alpine.DEB.2.00.1110050915160.30467@router.home>
References: <6.2.5.6.2.20111003112108.03a83a28@binnacle.cx>
	  <alpine.DEB.2.00.1110041358500.12199@router.home>
	 <1317820942.6766.26.camel@twins>
	 <alpine.DEB.2.00.1110050915160.30467@router.home>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317828827.6766.37.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-10-05 at 09:26 -0500, Christoph Lameter wrote:
> 
> > Also, for latency, we've got ftrace and a latencytracer, provide traces
> > that illustrate your fail.
> 
> We would need a backport of both to a kernel version that works with
> reasonable latencies so that we can figure out what caused these
> regressions for this particular case. Disabling network and kernel
> features usually gives you better performance but there are a lot of
> things in the hot paths these days that can not be disabled.

Well can can also just take the status quo and use tools like ftrace and
perf to find out what your hot paths are and where you're spending time.

On -rt we use the (irq)latencytracer a _lot_ to find problems, a
detailed function trace of WTH the kernel thinks its doing helps a lot
with trying to fix it.

Things like cyclictest are also useful to find application level
latencies, it can trace the entire latency path if needed.

Kernel level profiles are also a great tool to find out where you're
spending your time.
