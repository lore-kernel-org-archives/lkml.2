Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756615Ab1HDB7n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 21:59:43 -0400
Received: from mga01.intel.com ([192.55.52.88]:6589 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756618Ab1HDB7h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 21:59:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,313,1309762800"; 
   d="scan'208";a="37680458"
From: Andi Kleen <andi@firstfloor.org>
To: Rafael Aquini <aquini@redhat.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Stephen Wilson <wilsons@start.ca>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/mempolicy.c: make sys_mbind & sys_set_mempolicy aware of task_struct->mems_allowed
References: <20110803123721.GA2892@x61.redhat.com>
Date: Wed, 03 Aug 2011 18:59:33 -0700
In-Reply-To: <20110803123721.GA2892@x61.redhat.com> (Rafael Aquini's message
	of "Wed, 3 Aug 2011 09:37:27 -0300")
Message-ID: <m2d3gm0we2.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael Aquini <aquini@redhat.com> writes:

> Among several other features enabled when CONFIG_CPUSETS is defined,
> task_struct is enhanced with the nodemask_t mems_allowed element that
> serves to register/report on which memory nodes the task may obtain
> memory. Also, two new lines that reflect the value registered at
> task_struct->mems_allowed are added to the '/proc/[pid]/status' file:

As Christoph said this was intentionally designed this way. Originally
there was some consideration of "relative policies", but that is not
implemented and had various issues. 

They're orthogonal mechanisms.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
