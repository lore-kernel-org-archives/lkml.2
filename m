Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758480Ab0GHTGp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 15:06:45 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60470 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756682Ab0GHTGo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 15:06:44 -0400
Subject: Re: high power consumption in recent kernels
From: Peter Zijlstra <peterz@infradead.org>
To: Norbert Preining <preining@logic.at>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, akpm <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, tglx <tglx@linutronix.de>
In-Reply-To: <1278604779.1900.157.camel@laptop>
References: <20100706164539.GA14783@gamma.logic.tuwien.ac.at>
	 <1278579992.1900.17.camel@laptop> <20100708045711.398d4e26@infradead.org>
	 <1278590303.1900.91.camel@laptop>
	 <20100708120421.GF20841@gamma.logic.tuwien.ac.at>
	 <1278591779.1900.97.camel@laptop>
	 <20100708124627.GA7754@gamma.logic.tuwien.ac.at>
	 <1278595426.1900.130.camel@laptop>  <1278604779.1900.157.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 08 Jul 2010 21:06:31 +0200
Message-ID: <1278615991.1900.187.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-08 at 17:59 +0200, Peter Zijlstra wrote:

> OK, so Arjan said the gain could come from tricking the idle governor
> into not using deeper C states. He also said he significantly cured said
> governor in .35.
> 
> Mike could you re-run your netperf tests that showed the 10% throughput
> gain? Hopefully the fixed governor will yield the same result and we can
> kill off this ratelimit thing.

FWIW, on my test-box, 35-rc4-tip, using ondemand:

with    nohz_ratelimit() : ~2119.54 MB/s
without nohz_ratelimit() : ~2353.03 MB/s

Seems to suggest we should simply kill the thing..
