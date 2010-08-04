Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758467Ab0HDHOb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 03:14:31 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40760 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512Ab0HDHOa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 03:14:30 -0400
Subject: Re: periods and deadlines in SCHED_DEADLINE
From: Peter Zijlstra <peterz@infradead.org>
To: Andrea Bastoni <bastoni@cs.unc.edu>
Cc: Bjoern Brandenburg <bbb@email.unc.edu>, Raistlin <raistlin@linux.it>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Song Yuan <song.yuan@ericsson.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Nicola Manica <nicola.manica@disi.unitn.it>,
        Luca Abeni <lucabe72@email.it>,
        Claudio Scordino <claudio@evidence.eu.com>,
        Harald Gustafsson <harald.gustafsson@ericsson.com>,
        Giuseppe Lipari <lipari@retis.sssup.it>
In-Reply-To: <4C58E403.6060209@cs.unc.edu>
References: <1278682707.6083.227.camel@Palantir>
	 <1278685133.1900.201.camel@laptop>
	 <51F8E441-58D7-45E1-B7A0-7A717EDF08B5@email.unc.edu>
	 <1278693304.1900.266.camel@laptop> <1278752489.4390.97.camel@Palantir>
	 <F96CDA2C-534B-4344-B4B4-F890F9BA1D8E@email.unc.edu>
	 <1280828475.1923.444.camel@laptop>  <4C58E403.6060209@cs.unc.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 04 Aug 2010 09:14:05 +0200
Message-ID: <1280906045.1923.721.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-03 at 23:52 -0400, Andrea Bastoni wrote:
> Instead, if you want to use the cpuset + affinity to define possibly _overlapping_ clusters (or
> containers, or servers) to support different budgets on each CPU (something similar to cgroup,
> see [1,3]), forcing only two configuration (single cpu/full cluster) may be restrictive. 

cpusets doesn't allow overlapping load-balance domains as it stands
today. In that case it would end up being a single large domain.

With cpu affinity we can of course create whatever we want, hence my
suggestion to limit allowed affinity masks to 1 cpu or the full
load-balance domain.
