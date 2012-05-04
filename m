Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759138Ab2EDR50 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 13:57:26 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55989 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164Ab2EDR5Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 13:57:25 -0400
Message-ID: <1336154226.6509.49.camel@twins>
Subject: Re: [PATCH 4/9] perf: Generic intel uncore support
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: mingo@elte.hu, andi@firstfloor.org, eranian@google.com, jolsa@redhat.com,
        ming.m.lin@intel.com, linux-kernel@vger.kernel.org
Date: Fri, 04 May 2012 19:57:06 +0200
In-Reply-To: <4FA3862E.7030203@intel.com>
References: <1335924440-11242-1-git-send-email-zheng.z.yan@intel.com>
	  <1335924440-11242-5-git-send-email-zheng.z.yan@intel.com>
	 <1336065156.22523.34.camel@twins> <4FA3862E.7030203@intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-04 at 15:33 +0800, Yan, Zheng wrote:
> Thank you for your suggestion. One reason I choose hash table is that I'm uncertain
> the system behavior when hot-plug a CPU, the PCI uncore device is probed first or
> the CPU data is initialized first? If the PCI device is probed first, I think your
> code won't work because topology_physical_package_id may return incorrect id.

It had better first initialize the cpu data before it starts probing its
devices. Doing it the other way around just doesn't make any sense.
