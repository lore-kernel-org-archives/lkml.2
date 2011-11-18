Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757886Ab1KRPMb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 10:12:31 -0500
Received: from merlin.infradead.org ([205.233.59.134]:57851 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181Ab1KRPMa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 10:12:30 -0500
Subject: Re: sched: Avoid SMT siblings in select_idle_sibling() if possible
From: Peter Zijlstra <peterz@infradead.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Mike Galbraith <efault@gmx.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Paul Turner <pjt@google.com>
Date: Fri, 18 Nov 2011 16:12:21 +0100
In-Reply-To: <1321556904.15339.25.camel@sbsiddha-desk.sc.intel.com>
References: <1321350377.1421.55.camel@twins>
	 <1321406062.16760.60.camel@sbsiddha-desk.sc.intel.com>
	 <1321435455.5072.64.camel@marge.simson.net>
	 <1321468646.11680.2.camel@sbsiddha-desk.sc.intel.com>
	 <1321495153.5100.7.camel@marge.simson.net>
	 <1321544313.6308.25.camel@marge.simson.net>
	 <1321545376.2495.1.camel@laptop>
	 <1321556904.15339.25.camel@sbsiddha-desk.sc.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1321629141.2197.4.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-17 at 11:08 -0800, Suresh Siddha wrote:
> 
> From: Suresh Siddha <suresh.b.siddha@intel.com>
> Subject: sched: cleanup domain traversal in select_idle_sibling
> 
> Instead of going through the scheduler domain hierarchy multiple times
> (for giving priority to an idle core over an idle SMT sibling in a busy
> core), start with the highest scheduler domain with the SD_SHARE_PKG_RESOURCES
> flag and traverse the domain hierarchy down till we find an idle group.
> 
> This cleanup also addresses an issue reported by Mike where the recent
> changes returned the busy thread even in the presence of an idle SMT
> sibling in single socket platforms.
> 
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> Cc: Mike Galbraith <efault@gmx.de> 

Thanks Suresh!
