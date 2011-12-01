Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936Ab1LARpk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 12:45:40 -0500
Received: from casper.infradead.org ([85.118.1.10]:47838 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755341Ab1LARpj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 12:45:39 -0500
Message-ID: <1322761515.4699.49.camel@twins>
Subject: Re: [PATCH] jump_label: jump_label for boot options.
From: Peter Zijlstra <peterz@infradead.org>
To: Jason Baron <jbaron@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        rostedt@goodmis.org
Date: Thu, 01 Dec 2011 18:45:15 +0100
In-Reply-To: <1322761185.4699.47.camel@twins>
References: <20111201115353.563f79fc.kamezawa.hiroyu@jp.fujitsu.com>
	 <20111201154036.GA2443@redhat.com> <1322756898.4699.30.camel@twins>
	 <20111201165009.GB2443@redhat.com> <1322761185.4699.47.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-12-01 at 18:39 +0100, Peter Zijlstra wrote:
> +#define SCHED_FEAT(name, enabled)                                      \
> +static __always_inline bool static_branch_##name(struct jump_label_key *key) \
> +{                                                                      \
> +       return static_branch_##enabled(key);                            \
> +}
> +
> +#include "features.h"
> +
> +#undef SCHED_FEAT
> +
> +#if defined(CONFIG_SCHED_DEBUG) && defined(HAVE_JUMP_LABEL)
> +static struct jump_label_key sched_feat_keys[__SCHED_FEAT_NR];
> +#define sched_feat(x) (static_branch(&sched_feat_keys[__SCHED_FEAT_##x])) 

#define sched_feat(x) static_branch_##x(&sched_feat_keys[__SCHED_FEAT_##x])

of course ;-)
