Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933455Ab2KEWvF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 17:51:05 -0500
Received: from mga09.intel.com ([134.134.136.24]:44218 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933360Ab2KEWvC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 17:51:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,718,1344236400"; 
   d="scan'208";a="215538479"
Date: Mon, 5 Nov 2012 14:51:01 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        peterz@infradead.org, mingo@elte.hu, jolsa@redhat.com,
        namhyung.kim@lge.com
Subject: Re: [PATCH v2 03/16] perf, core: Add a concept of a weightened sample
Message-ID: <20121105225101.GB25167@tassilo.jf.intel.com>
References: <1352123463-7346-1-git-send-email-eranian@google.com>
 <1352123463-7346-4-git-send-email-eranian@google.com>
 <20121105200147.GB7962@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121105200147.GB7962@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +
> >  	if (sample_type & PERF_SAMPLE_READ)
> >  		size += event->read_size;
> >  
> > @@ -4080,6 +4083,9 @@ void perf_output_sample(struct perf_output_handle *handle,
> >  	if (sample_type & PERF_SAMPLE_PERIOD)
> >  		perf_output_put(handle, data->period);
> >  
> > +	if (sample_type & PERF_SAMPLE_WEIGHT)
> > +		perf_output_put(handle, data->weight);
> > +
> 
> Yeap, it should go after PERF_SAMPLE_STACK_USER

There was a bug I recently noticed but haven't investigated so far.

When I do -b -W --transaction the flags/weights get corrupted.

May be related to that.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
