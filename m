Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747Ab2I1JCn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 05:02:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:56965 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140Ab2I1JCl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 05:02:41 -0400
Message-ID: <1348822920.3292.60.camel@twins>
Subject: Re: [PATCH 04/31] perf, core: Add generic intx/intx_checkpointed
 counter modifiers
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, eranian@google.com,
        acme@redhat.com, Andi Kleen <ak@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>
Date: Fri, 28 Sep 2012 11:02:00 +0200
In-Reply-To: <1348806696-31170-5-git-send-email-andi@firstfloor.org>
References: <1348806696-31170-1-git-send-email-andi@firstfloor.org>
	 <1348806696-31170-5-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-27 at 21:31 -0700, Andi Kleen wrote:
> +                               intx           :  1, /* count inside transaction */
> +                               intx_checkpointed :  1, /* checkpointed in transaction */ 

I really hate those names.. what are they called in transactional memory
literature?

Also do we really need this? Using the event format stuff we could
equally well do:

{cpu/cycles/, cpu/cycles,intx/, cpu/cycles,intx_checkpointed/}

No need to push those bits through perf_event_attr::flags when you can
stuff then through perf_event_attr::config, esp. for very hardware
specific features.
