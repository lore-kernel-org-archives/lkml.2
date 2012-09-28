Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341Ab2I1Iut (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 04:50:49 -0400
Received: from casper.infradead.org ([85.118.1.10]:56737 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038Ab2I1Iup convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 04:50:45 -0400
Message-ID: <1348822202.3292.53.camel@twins>
Subject: Re: [PATCH 03/31] perf, x86: Basic Haswell PEBS support
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, eranian@google.com,
        acme@redhat.com, Andi Kleen <ak@linux.intel.com>
Date: Fri, 28 Sep 2012 10:50:02 +0200
In-Reply-To: <1348806696-31170-4-git-send-email-andi@firstfloor.org>
References: <1348806696-31170-1-git-send-email-andi@firstfloor.org>
	 <1348806696-31170-4-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-27 at 21:31 -0700, Andi Kleen wrote:
> +       INTEL_UEVENT_CONSTRAINT(0x11d0, 0xf), /* MEM_UOPS_RETIRED.STLB_MISS_LOADS */
> +       INTEL_UEVENT_CONSTRAINT(0x12d0, 0xf), /* MEM_UOPS_RETIRED.STLB_MISS_STORES */
> +       INTEL_UEVENT_CONSTRAINT(0x21d0, 0xf), /* MEM_UOPS_RETIRED.LOCK_LOADS */

Did you miss umask 22, LOCK_STORES ? (I haven't looked at the SDM yet,
just seeing a glitch in the pattern).

> +       INTEL_UEVENT_CONSTRAINT(0x41d0, 0xf), /* MEM_UOPS_RETIRED.SPLIT_LOADS */
> +       INTEL_UEVENT_CONSTRAINT(0x42d0, 0xf), /* MEM_UOPS_RETIRED.SPLIT_STORES */
> +       INTEL_UEVENT_CONSTRAINT(0x81d0, 0xf), /* MEM_UOPS_RETIRED.ALL_LOADS */
> +       INTEL_UEVENT_CONSTRAINT(0x82d0, 0xf), /* MEM_UOPS_RETIRED.ALL_STORES */ 

Just wondering, are there all d0 events? Or is this a specific subset?
That is, why not use:

	INTEL_EVENT_CONSTRAINT(0xd0, 0xf), /* MEM_UOPS_RETIRED.* */

