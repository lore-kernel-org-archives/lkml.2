Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905Ab1BWBIw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 20:08:52 -0500
Received: from mga02.intel.com ([134.134.136.20]:43864 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751697Ab1BWBIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 20:08:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,209,1297065600"; 
   d="scan'208";a="605526528"
Subject: Re: [PATCH 1/6] perf-events: Add support for supplementary event
 registers v5
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <1298388053.2217.204.camel@twins>
References: <1298221019.2318.62.camel@localhost>
	 <1298388053.2217.204.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Feb 2011 09:09:08 +0800
Message-ID: <1298423348.2835.3.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-22 at 23:20 +0800, Peter Zijlstra wrote:
> On Mon, 2011-02-21 at 00:56 +0800, Lin Ming wrote:
> > @@ -225,7 +225,10 @@ struct perf_event_attr {
> >         };
> >  
> >         __u32                   bp_type;
> > -       __u64                   bp_addr;
> > +       union {
> > +               __u64           bp_addr;
> > +               __u64           event_extra; /* Extra for some events */
> > +       };
> >         __u64                   bp_len;
> >  }; 
> 
> I did s/event_extra/config1/g and:
> 
> Index: linux-2.6/include/linux/perf_event.h
> ===================================================================
> --- linux-2.6.orig/include/linux/perf_event.h
> +++ linux-2.6/include/linux/perf_event.h
> @@ -227,9 +230,12 @@ struct perf_event_attr {
>  	__u32			bp_type;
>  	union {
>  		__u64		bp_addr;
> -		__u64		config1; /* Extra for some events */
> +		__u64		config1;	/* extension of config0 */
> +	};
> +	union {
> +		__u64		bp_len;
> +		__u64		config2;	/* extension of config1 */
>  	};
> -	__u64			bp_len;
>  };
>  
>  /*
> 
> Giving us basically 192 bits of config{,1,2} space and the possibility
> of eventually deprecating the bp_ stuff.

OK, 

Do you mean it's possible to encode bp_type/bp_addr/bp_len into
config1/config2?


