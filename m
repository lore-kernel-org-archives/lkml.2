Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471Ab0JTUzg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 16:55:36 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:48016 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754697Ab0JTUzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 16:55:35 -0400
Date: Thu, 21 Oct 2010 02:25:30 +0530
From: Dipankar Sarma <dipankar@in.ibm.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>,
        Trinabh Gupta <trinabh@linux.vnet.ibm.com>,
        Venkatesh Pallipadi <venki@google.com>, peterz@infradead.org,
        lenb@kernel.org, suresh.b.siddha@intel.com, benh@kernel.crashing.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC V1] cpuidle: add idle routine registration and cleanup
 pm_idle pointer
Message-ID: <20101020205530.GA22317@in.ibm.com>
Reply-To: dipankar@in.ibm.com
References: <20101019183522.17992.86937.stgit@tringupt.in.ibm.com>
 <4CBDE5AB.4040401@linux.intel.com>
 <AANLkTi=cetw_mdp_3s+T4OxTfcMT2u4cdVPKxOp7jbVU@mail.gmail.com>
 <4CBDEB14.2030304@linux.vnet.ibm.com>
 <4CBF06D5.7020508@linux.vnet.ibm.com>
 <4CBF0854.6080903@linux.intel.com>
 <4CBF0C04.5070705@linux.intel.com>
 <4CBF12CB.9050604@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CBF12CB.9050604@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 20, 2010 at 09:03:23AM -0700, Arjan van de Ven wrote:
>  On 10/20/2010 8:34 AM, Andi Kleen wrote:
> >
> >I think the right option is still to put cpuidle on a diet.
> >There's no reason an idle handler needs to be that bloated.
> >
> >If it was 2K or so just including it into the core would be fine.
> >
> >Ignoring code size completely is generally a wrong trade off imho.
> 
> I'm not ignoring code size.
> I'm saying that a 7Kb component that everyone on this architecture
> uses in practice versus adding 0.5Kb in ADDITION to that for
> everyone for the theoretical case
> of someone NOT using cpuidle is the wrong tradeoff.

The 0.5kb is necessary because we want to move from dangling
pm_idle to a simple registration mechanism. 

> having it go on a diet? I'm all for it. Killing off the ladder
> governor for example is a step.
> But really. 7Kb. There's lots of lower hanging fruit as well. 7Kb is
> not a reason to make such a bad tradeoff.

Given the number of archs using this, doing this incrementally
seems to be the best way to go. The registration part first,
trimming cpuidle, moving other archs to the registration
mechanism later eventually deprecating pm_idle.

Thanks
Dipankar

