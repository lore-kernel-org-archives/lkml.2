Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755179Ab2EOKdF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 06:33:05 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49583 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705Ab2EOKdE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 06:33:04 -0400
Message-ID: <1337077973.27694.24.camel@twins>
Subject: Re: [GIT PULL 0/8] Annotation weekly ponies delivery
From: Peter Zijlstra <peterz@infradead.org>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, arnaldo.melo@gmail.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Date: Tue, 15 May 2012 12:32:53 +0200
In-Reply-To: <1337007985.1552.5.camel@leonhard>
References: <1336852387-16322-1-git-send-email-acme@infradead.org>
	 <CA+55aFxeqrCj71fSe2r9kwzyO9q2BT9A89f7nLUgbrTG_uPP2g@mail.gmail.com>
	 <1336994000.2443.24.camel@twins>  <20120514115551.GA6479@gmail.com>
	 <1337007985.1552.5.camel@leonhard>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-15 at 00:06 +0900, Namhyung Kim wrote:

> perf_evlist__config_attrs() has this:
> 
> 	if (evlist->cpus->map[0] < 0)
> 		opts->no_inherit = true;
> 
> meaning that per task profiling won't enable event inheritance. I don't
> know why it's needed though.

Because you cannot have inherited per-task counters. It only works for
per-task-per-cpu counters. Otherwise you'll have a scalability
nightmare.


