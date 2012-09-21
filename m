Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932930Ab2IUJl4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 05:41:56 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:55197 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932742Ab2IUJlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 05:41:55 -0400
Date: Fri, 21 Sep 2012 12:41:52 +0300 (EEST)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: Glauber Costa <glommer@parallels.com>
cc: Christoph Lameter <cl@linux.com>, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com,
        devel@openvz.org, Tejun Heo <tj@kernel.org>, linux-mm@kvack.org,
        Suleiman Souhlal <suleiman@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v3 09/16] sl[au]b: always get the cache from its page in
 kfree
In-Reply-To: <505C33D3.5000202@parallels.com>
Message-ID: <alpine.LFD.2.02.1209211240410.3619@tux.localdomain>
References: <1347977530-29755-1-git-send-email-glommer@parallels.com> <1347977530-29755-10-git-send-email-glommer@parallels.com> <00000139d9fe8595-8905906d-18ed-4d41-afdb-f4c632c2d50a-000000@email.amazonses.com> <5059777E.8060906@parallels.com>
 <CAOJsxLFgwOqUcLHEwYNERwn1Uvp4-8CmvRKTfBFAHD6p_-6c7g@mail.gmail.com> <505C33D3.5000202@parallels.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Sep 2012, Glauber Costa wrote:
> > We should assume that most distributions enable CONFIG_MEMCG_KMEM,
> > right? Therfore, any performance impact should be dependent on whether
> > or not kmem memcg is *enabled* at runtime or not.
> > 
> > Can we use the "static key" thingy introduced by tracing folks for this?
>
> Yes.
> 
> I am already using static keys extensively in this patchset, and that is
> how I intend to handle this particular case.

Cool.

The key point here is that !CONFIG_MEMCG_KMEM should have exactly *zero* 
performance impact and CONFIG_MEMCG_KMEM disabled at runtime should have 
absolute minimal impact.

			Pekka
