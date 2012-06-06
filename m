Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261Ab2FFBAU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 21:00:20 -0400
Received: from mga11.intel.com ([192.55.52.93]:37798 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752921Ab2FFBAS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 21:00:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="175277391"
Message-ID: <4FCEABA1.5030602@intel.com>
Date: Wed, 06 Jun 2012 09:00:17 +0800
From: "Yan, Zheng" <zheng.z.yan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120424 Thunderbird/12.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf, x86: Fix Intel shared extra MSR allocation
References: <1338520856-21020-1-git-send-email-zheng.z.yan@intel.com>  <CABPqkBScjC5fJbTc1rYtbtRqOCyJ+7QUbdE32DgMcffBAGJNVw@mail.gmail.com>  <CAAM7YAkYgUjwQptYvyeVawzcD5x4c-bTT_=+6AMyUb+-6HoMuQ@mail.gmail.com>  <1338891271.28282.155.camel@twins>  <CABPqkBSv8CbMzUiRsN2uOF1v6rFTpzhQqNbo7OKe-nzsus0GDg@mail.gmail.com>  <1338892071.28282.157.camel@twins>  <CABPqkBSqLpa4X-WbR0PkouYvhODT78r3pxWq70=PTj1j=a307Q@mail.gmail.com>  <1338898024.28282.160.camel@twins> <1338899999.28282.164.camel@twins>  <CABPqkBRCMAnPH3UW0=afMw4-YXgwQ5D-NLMEtnNWde_Tzh3aew@mail.gmail.com>  <1338901490.28282.167.camel@twins> <1338903031.28282.175.camel@twins> <1338904586.28282.183.camel@twins>
In-Reply-To: <1338904586.28282.183.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2012 09:56 PM, Peter Zijlstra wrote:
>> @@ -1157,14 +1163,14 @@ __intel_shared_reg_get_constraints(struct cpu_hw_events *cpuc,
>> >  	struct event_constraint *c = &emptyconstraint;
>> >  	struct er_account *era;
>> >  	unsigned long flags;
>> > -	int orig_idx = reg->idx;
>> > +	int idx = reg->idx;
>> >  
>> >  	/* already allocated shared msr */
>> >  	if (reg->alloc)
>> >  		return NULL; /* call x86_get_event_constraint() */
> I'm afraid that needs to be:
> 
> 	/*
> 	 * reg->alloc can be set due to existing state, so for fake cpuc
> 	 * we need to ignore this, otherwise we might fail to allocate
> 	 * proper fake state for this extra reg constraint. Also see
> 	 * the comment below.
> 	 */
> 	if (reg->alloc && !cpuc->is_fake)
> 		return NULL; /* call x86_get_event_constraints() */
> 
Agree

Regards
Yan, Zheng



