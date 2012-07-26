Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751321Ab2GZIIt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 04:08:49 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33876 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766Ab2GZIIp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 04:08:45 -0400
Message-ID: <1343290109.26034.82.camel@twins>
Subject: Re: [PATCH 08/11] perf tool: precise mode requires exclude_guest
From: Peter Zijlstra <peterz@infradead.org>
To: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Robert Richter <robert.richter@amd.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Gleb Natapov <gleb@redhat.com>
Date: Thu, 26 Jul 2012 10:08:29 +0200
In-Reply-To: <5010D2B1.3000206@gmail.com>
References: <1342826756-64663-1-git-send-email-dsahern@gmail.com>
	 <1342826756-64663-9-git-send-email-dsahern@gmail.com>
	 <20120723181358.GC6717@infradead.org> <500EAF23.8060909@gmail.com>
	 <20120724161507.GG3732@erda.amd.com> <500EDB50.3070704@gmail.com>
	 <20120724180312.GJ6717@infradead.org> <5010D2B1.3000206@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-25 at 23:16 -0600, David Ahern wrote:

> Peter's patch (see https://lkml.org/lkml/2012/7/9/298) changes kernel 
> side to require the use of exclude_guest if the precise modifier is 
> used, returning -EOPNOTSUPP if exclude_guest is not set. This patch goes 
> after the user experience: Today if a user specifies -e <event>:p all 
> other modifiers are reset - including exclude_guest. Going forward we 
> need :p to imply :pH if a user has not specified a GH modifer.
> 
> We could do nothing and handle the unsupported error and try setting the 
> exclude_guest option - like perf handles other new parameters. But 
> EOPNOTSUPP is not uniquely tied to this error -- e.g., it could be the 
> BTS is not supported (:pp). Also, we have no easy way to discriminate :p 
> from :pG or :pGH. It seems to me perf should not silently undo a user 
> request on the modifier, but inform the user the request is wrong. For 
> example if a user request -e cycles:pG it should not be silently turned 
> into :pH.
> 
> And then yesterday, Robert stated that none of the exclude_xxxx 
> modifiers can be set for the AMD if the precise modifier is used, so we 
> cannot blindly set exclude_guest if precise_ip is set.
> 
> So, seems to me perf need's one action for Intel processors and another 
> for AMD.

No, we just need to teach the IBS code about SVM enter/exit.

