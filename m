Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758121Ab2EJKKl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 06:10:41 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45073 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757911Ab2EJKKj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 06:10:39 -0400
Message-ID: <1336644337.2527.95.camel@twins>
Subject: Re: [PATCH 4/9] perf: Generic intel uncore support
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: mingo@elte.hu, andi@firstfloor.org, eranian@google.com, jolsa@redhat.com,
        ming.m.lin@intel.com, linux-kernel@vger.kernel.org,
        hpa <hpa@zytor.com>
Date: Thu, 10 May 2012 12:05:37 +0200
In-Reply-To: <4FAB6F99.6010408@intel.com>
References: <1335924440-11242-1-git-send-email-zheng.z.yan@intel.com>
	  <1335924440-11242-5-git-send-email-zheng.z.yan@intel.com>
	 <1336065156.22523.34.camel@twins> <4FAB6F99.6010408@intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-10 at 15:34 +0800, Yan, Zheng wrote:
> 
> This code doesn't work for PCI uncore device if there are offline CPUs,
> because topology_physical_package_id() always return 0 for offline CPUs.

Hmm, that sounds wrong.. one would expect something like BAD_APICID, -1
or the correct number. hpa should we fix that?

Anyway,

> So besides the per CPU variable, we still need another data structure
> to track the uncore boxes. Do you still want to use per CPU variable?

Well you don't really need the value for offline CPUs, until they're
online right? So all you need to do is iterate all the box muck in a
hotplug handler and set the right pointer, no? (I suspect this would
need to be done in CPU_STARTING).
