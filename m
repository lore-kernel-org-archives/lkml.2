Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678Ab2DBWYo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 18:24:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:35146 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716Ab2DBWYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 18:24:43 -0400
Subject: Re: [PATCH 2/5] perf: generic intel uncore support
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: mingo@elte.hu, andi@firstfloor.org, eranian@google.com,
        linux-kernel@vger.kernel.org, ming.m.lin@intel.com
In-Reply-To: <4F77C75B.4060105@intel.com>
References: <1332916998-10628-1-git-send-email-zheng.z.yan@intel.com>
	 <1332916998-10628-3-git-send-email-zheng.z.yan@intel.com>
	 <1333163902.2960.63.camel@laptop>  <4F77C75B.4060105@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 03 Apr 2012 00:24:39 +0200
Message-ID: <1333405479.2960.86.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-04-01 at 11:11 +0800, Yan, Zheng wrote:
> 
> >> +static int __init uncore_type_init(struct intel_uncore_type *type)
> >> +{
> >> +       struct intel_uncore_pmu *pmus;
> >> +       struct attribute_group *events_group;
> >> +       struct attribute **attrs;
> >> +       int i, j;
> >> +
> >> +       pmus = kzalloc(sizeof(*pmus) * type->num_boxes, GFP_KERNEL);
> >> +       if (!pmus)
> >> +               return -ENOMEM;
> > 
> > Hmm, but if you have a pmu per number of boxes, then what do you need
> > that  pmu->box reference for?
> 
> Type->num_boxes is number of boxes within one physical cpu. pmu->box_hash
> is needed because there can be several physical cpus in a system.  

Ah, indeed. 

