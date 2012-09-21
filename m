Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933190Ab2IUUHk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 16:07:40 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34207 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932081Ab2IUUHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 16:07:38 -0400
Date: Fri, 21 Sep 2012 13:07:33 -0700
From: Tejun Heo <tj@kernel.org>
To: Pekka Enberg <penberg@kernel.org>
Cc: Glauber Costa <glommer@parallels.com>, Christoph Lameter <cl@linux.com>,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, devel@openvz.org, linux-mm@kvack.org,
        Suleiman Souhlal <suleiman@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v3 09/16] sl[au]b: always get the cache from its page
 in kfree
Message-ID: <20120921200733.GM7264@google.com>
References: <1347977530-29755-1-git-send-email-glommer@parallels.com>
 <1347977530-29755-10-git-send-email-glommer@parallels.com>
 <00000139d9fe8595-8905906d-18ed-4d41-afdb-f4c632c2d50a-000000@email.amazonses.com>
 <5059777E.8060906@parallels.com>
 <CAOJsxLFgwOqUcLHEwYNERwn1Uvp4-8CmvRKTfBFAHD6p_-6c7g@mail.gmail.com>
 <505C33D3.5000202@parallels.com>
 <alpine.LFD.2.02.1209211240410.3619@tux.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1209211240410.3619@tux.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Sep 21, 2012 at 12:41:52PM +0300, Pekka Enberg wrote:
> > I am already using static keys extensively in this patchset, and that is
> > how I intend to handle this particular case.
> 
> Cool.
> 
> The key point here is that !CONFIG_MEMCG_KMEM should have exactly *zero* 
> performance impact and CONFIG_MEMCG_KMEM disabled at runtime should have 
> absolute minimal impact.

Not necessarily disagreeing, but I don't think it's helpful to set the
bar impossibly high.  Even static_key doesn't have "exactly *zero*"
impact.  Let's stick to as minimal as possible when not in use and
reasonable in use.

And, yeah, this one can be easily solved by using static_key.

Thanks.

-- 
tejun
