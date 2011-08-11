Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752440Ab1HKSau (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 14:30:50 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48687 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339Ab1HKSat convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 14:30:49 -0400
Subject: Re: [PATCH v2 0/2] new cpumask for hotpluggable CPUs
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Turquette <mturquette@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linaro-dev@lists.linaro.org, patches@linaro.org, gregkh@suse.de
Date: Thu, 11 Aug 2011 20:30:23 +0200
In-Reply-To: <1313006614-28702-1-git-send-email-mturquette@ti.com>
References: <1313006614-28702-1-git-send-email-mturquette@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1313087423.8491.11.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-10 at 13:03 -0700, Mike Turquette wrote:
> This patch series introduces a new cpumask which tracks CPUs that
> support hotplugging.  The purpose of this patch series is to provide a
> simple method for kernel code to know which CPUs can be hotplugged and
> which ones cannot.  Potential users of this code might be a thermal
> mitigation technique which uses hotplug to lower temperature, or a power
> capping mechanism which uses hotplug to lower power consumption.
> 
> All the of usual cpumask helper functions are created for this new mask.
> The second patch in this series simply sets the bit for elligible CPUs
> while they are being registered.  The cpumask itself is static after
> boot and should not change (like the possbile mask).

I still most strongly object to people using hotplug for these goals.

Why do you need to go through the entire dance of hotplug just to idle a
cpu? Hotplug not only idles the cpu but tears down (and rebuilds) an
insane amount of resources associated with the cpu.

Nacked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
