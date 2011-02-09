Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663Ab1BILQr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 06:16:47 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:44801 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754584Ab1BILQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 06:16:41 -0500
Subject: Re: [RFC PATCH V3 2/3] cpuidle: list based cpuidle driver
 registration and selection
From: Peter Zijlstra <peterz@infradead.org>
To: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
Cc: arjan@linux.intel.com, lenb@kernel.org, suresh.b.siddha@intel.com,
        benh@kernel.crashing.org, venki@google.com, ak@linux.intel.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110208105203.9998.35678.stgit@tringupt.in.ibm.com>
References: <20110208105146.9998.22103.stgit@tringupt.in.ibm.com>
	 <20110208105203.9998.35678.stgit@tringupt.in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Feb 2011 12:17:43 +0100
Message-ID: <1297250263.13327.159.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-08 at 16:22 +0530, Trinabh Gupta wrote:
> A cpuidle_driver is global in nature as it provides routines
> for all the CPUS. Each CPU registered with the cpuidle subsystem is
> represented as a cpuidle_device. A cpuidle_device structure
> points to the low level idle routines for that CPU provided by
> a certain driver. In other words, a cpuidle driver creates a
> cpuidle_device structure for each CPU that it registers with the
> cpuidle subsystem. Whenever cpuidle idle loop is called, the cpuidle
> subsystem picks the cpuidle_device structure for that cpu and
> calls one of the low level idle routines through that structure. 

Why all this per-cpu nonsense? I thought we all agreed that ACPI tables
specifying non-uniform C states were considered buggy and we should
simply use the intersection of all cpus.



