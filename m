Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753049Ab2DBWLH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 18:11:07 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44815 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358Ab2DBWLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 18:11:04 -0400
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
Date: Tue, 03 Apr 2012 00:10:57 +0200
Message-ID: <1333404657.2960.81.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-04-01 at 11:11 +0800, Yan, Zheng wrote:
> >> +static struct intel_uncore_box *uncore_event_to_box(struct perf_event *event)
> >> +{
> >> +       int phyid = topology_physical_package_id(smp_processor_id());
> > 
> > Who says that this event has anything to do with the current cpu?
> > 
> Because perf core schedules event on the basis of cpu. 

This appears true for all the current callchains, however there's no
comment in there making clear you thought about this, nor to remind you
future users respect this constraint.



