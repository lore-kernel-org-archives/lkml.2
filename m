Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758410Ab2IMPwV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 11:52:21 -0400
Received: from mga01.intel.com ([192.55.52.88]:20041 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758338Ab2IMPwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 11:52:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,417,1344236400"; 
   d="scan'208";a="221623545"
Date: Thu, 13 Sep 2012 08:52:18 -0700
From: Andi Kleen <ak@linux.intel.com>
To: David Ahern <dsahern@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, acme@ghostprotocols.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf, tools: Stop perf stat -p when profiled process
 exits v2
Message-ID: <20120913155218.GE4092@tassilo.jf.intel.com>
References: <1347460832-32118-1-git-send-email-andi@firstfloor.org>
 <5050A21A.3030102@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5050A21A.3030102@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 08:54:18AM -0600, David Ahern wrote:
> On 9/12/12 8:40 AM, Andi Kleen wrote:
> >-		while(!done) sleep(1);
> >+		char piddir[40];
> >+		if (target.pid && access("/proc", X_OK) == 0)
> >+			snprintf(piddir, sizeof piddir, "/proc/%d", atoi(target.pid));
> 
> else path has piddir not set. 

It doesn't need to be set for else?

> target.pid can have multiple pids in it, so this fails if a user
> specified -p pid1,pid2 -- it will only check if the first process
> died.

Ok.   I suppose can make it simply not check for that case.

-Andi
