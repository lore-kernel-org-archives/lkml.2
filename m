Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758652Ab1FPSgo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 14:36:44 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45476 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687Ab1FPSgh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 14:36:37 -0400
Subject: Re: [PATCH 1/3] stop_machine: kill __stop_machine()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Tejun Heo <tj@kernel.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
        "x86@kernel.org" <x86@kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20110616182805.GD2611@htj.dyndns.org>
References: <1308071218-5912-1-git-send-email-tj@kernel.org>
	 <1308071218-5912-2-git-send-email-tj@kernel.org>
	 <1308226372.13240.42.camel@twins>
	 <1308245872.2682.369.camel@sbsiddha-MOBL3.sc.intel.com>
	 <1308246910.13240.238.camel@twins>
	 <1308248260.2682.413.camel@sbsiddha-MOBL3.sc.intel.com>
	 <20110616182805.GD2611@htj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 16 Jun 2011 20:36:02 +0200
Message-ID: <1308249362.13240.275.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-16 at 20:28 +0200, Tejun Heo wrote:
> Peter, I don't think it's that simple.  get_online_cpus() itself can't
> create circular dependency by itself.  It allows recursing.  The chain
> involves cpu_hotplug_begin() which returns with hotplug mutex held.


Right, its like:

 mutex_lock(&a);
 get_online_cpus();

vs

 cpu_hotplug_begin()
 mutex_lock(&a);


that will really deadlock
