Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576Ab0DSSMI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 14:12:08 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44185 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752746Ab0DSSMG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 14:12:06 -0400
Date: Mon, 19 Apr 2010 20:11:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Avi Kivity <avi@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       zhiteng.huang@intel.com, tim.c.chen@intel.com,
       Arnaldo Carvalho de Melo <acme@infradead.org>
Subject: Re: [PATCH V5 1/3] perf & kvm: Enhance perf to collect KVM guest os
 statistics from host side
Message-ID: <20100419181154.GA14631@elte.hu>
References: <1271655161.2078.603.camel@ymzhang.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271655161.2078.603.camel@ymzhang.sh.intel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


FYI, i found a few problems that need fixing:

> +	unsigned long ip;
> +	if (perf_guest_cbs && perf_guest_cbs->is_in_guest())

missing newline.

> +	int misc = 0;
> +	if (perf_guest_cbs && perf_guest_cbs->is_in_guest()) {

ditto.

> +			PERF_RECORD_MISC_GUEST_KERNEL;
> +	} else
> +		misc |= user_mode(regs) ? PERF_RECORD_MISC_USER :
> +			PERF_RECORD_MISC_KERNEL;

- unbalanced curly braces
- missing curly brace for multi-line statement.
- unnecessary line-break due to col80 warning from checkpatch

> +extern struct perf_guest_info_callbacks *perf_guest_cbs;
> +extern int perf_register_guest_info_callbacks(
> +		struct perf_guest_info_callbacks *);
> +extern int perf_unregister_guest_info_callbacks(
> +		struct perf_guest_info_callbacks *);

- unnecessary line-break due to col80 warning from checkpatch

> +static inline int perf_register_guest_info_callbacks
> +(struct perf_guest_info_callbacks *) {return 0; }
> +static inline int perf_unregister_guest_info_callbacks
> +(struct perf_guest_info_callbacks *) {return 0; }

- invalid C: function parameter needs name even if unused
- missing space after opening curly brace

Please provide delta fixes.

	Ingo
