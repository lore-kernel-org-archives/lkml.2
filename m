Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932541Ab0HDKqo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 06:46:44 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52591 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757404Ab0HDKqn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 06:46:43 -0400
Subject: Re: [PATCH repost] sched: export sched_set/getaffinity to modules
From: Peter Zijlstra <peterz@infradead.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Sridhar Samudrala <sri@us.ibm.com>,
        Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        netdev <netdev@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dmitri Vorobiev <dmitri.vorobiev@movial.com>,
        Jiri Kosina <jkosina@suse.cz>, Thomas Gleixner <tglx@linutronix.de>,
        Andi Kleen <ak@linux.intel.com>
In-Reply-To: <20100727045534.GA4316@redhat.com>
References: <4C2CA5C5.4040402@kernel.org>
	 <20100701144624.GA11171@redhat.com> <4C2CABF2.2020801@kernel.org>
	 <1277996135.1917.198.camel@laptop> <4C2E2987.9040702@us.ibm.com>
	 <1278094270.1917.288.camel@laptop> <20100702210637.GA12433@redhat.com>
	 <20100726171230.GA27644@redhat.com> <1280166688.3375.5.camel@localhost>
	 <20100726180834.GA26988@redhat.com>  <20100727045534.GA4316@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 04 Aug 2010 12:45:59 +0200
Message-ID: <1280918759.1923.968.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-07-27 at 07:55 +0300, Michael S. Tsirkin wrote:

> Peter, could you please indicate whether you think this is the way to
> go, too?

I really dislike it, as you indicated, you now want priority too..

It seems the problem is that we normally don't consider work done by
kernel threads for user processes part of that process.

I'm not sure what work you're doing, but I'm pretty sure there's similar
things already in the kernel -- think about the work done by encryption
threads for encrypted sockets and stuff.

If you want proper containment of work caused by a process, I'd suggest
you start by looking at curing the general problem, instead of special
casing this one case.
