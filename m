Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932707Ab2EVAU4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 20:20:56 -0400
Received: from mga01.intel.com ([192.55.52.88]:31217 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932084Ab2EVAUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 20:20:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="169430363"
Subject: Re: [PATCH 3/3][RFC] x86: x2apic/cluster: Do not handle cpumask
 allocation errors
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Cyrill Gorcunov <gorcunov@openvz.org>, Yinghai Lu <yinghai@kernel.org>
Date: Mon, 21 May 2012 17:19:18 -0700
In-Reply-To: <20120518102659.GC31517@dhcp-26-207.brq.redhat.com>
References: <20120518102659.GC31517@dhcp-26-207.brq.redhat.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1337645958.1997.172.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-18 at 12:26 +0200, Alexander Gordeev wrote:
> With this fix allocations of cpumasks are assumed always successfull
> and possible failures result in BUG().

BUG check for memory allocation failures in IPI path is not a good idea.
We will be using IPI's to flush TLB's before we evict the pages for
recovering from low-memory conditions.  We need to provide a clean fall
back path.

So NAK.

thanks,
suresh

