Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436Ab0KILXE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 06:23:04 -0500
Received: from mga01.intel.com ([192.55.52.88]:56194 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751682Ab0KILXB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 06:23:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,174,1288594800"; 
   d="scan'208";a="855674458"
Date: Tue, 9 Nov 2010 19:23:20 +0800
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
        chris@chris-wilson.co.uk
Subject: Re: [PATCH 2/4] tracing: introduce trace_set_clr_module_event
Message-ID: <20101109112320.GA21828@localhost.localdomain>
References: <1289293967-31761-1-git-send-email-yuanhan.liu@linux.intel.com>
 <1289293967-31761-2-git-send-email-yuanhan.liu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289293967-31761-2-git-send-email-yuanhan.liu@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 09, 2010 at 05:12:45PM +0800, Yuanhan Liu wrote:

[ snip ]

> +	for_each_token(token, p) {
> +		for_each_event(call, start, end) {
> +			if (strcmp(token, "*") == 0 ||
> +			    strcmp(token, call->name) == 0) 
> +				ftrace_event_enable_disable(call, set);
> +			else
> +				pr_warning("Failed to find trace event: %s "
> +					   "in module %s\n", token, mod->name);
Oops, sorry for this obvious error, will fix it.

Besides that, any comments? 

Thanks.

--
Yuanhan Liu
> +		
> +		}
> +	}
> +	kfree(buf);
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(trace_set_clr_module_event);
> +
> +
>  #else
>  static int trace_module_notify(struct notifier_block *self,
>  			       unsigned long val, void *data)
> -- 
> 1.7.2.3
