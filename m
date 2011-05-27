Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800Ab1E0VcY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 17:32:24 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:59136 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754148Ab1E0VcW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 17:32:22 -0400
Subject: Re: [PATCH 01/10] mm: Introduce the memory regions data structure
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: svaidy@linux.vnet.ibm.com
Cc: Ankita Garg <ankita@in.ibm.com>, linux-arm-kernel@lists.infradead.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-pm@lists.linux-foundation.org, thomas.abraham@linaro.org
In-Reply-To: <20110527182041.GM5654@dirshya.in.ibm.com>
References: <1306499498-14263-1-git-send-email-ankita@in.ibm.com>
	 <1306499498-14263-2-git-send-email-ankita@in.ibm.com>
	 <1306510203.22505.69.camel@nimitz>
	 <20110527182041.GM5654@dirshya.in.ibm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Fri, 27 May 2011 14:31:52 -0700
Message-ID: <1306531912.22505.84.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-27 at 23:50 +0530, Vaidyanathan Srinivasan wrote:
> The overall idea is to have a VM data structure that can capture
> various boundaries of memory, and enable the allocations and reclaim
> logic to target certain areas based on the boundaries and properties
> required. 

It's worth noting that we already do targeted reclaim on boundaries
other than zones.  The lumpy reclaim and memory compaction logically do
the same thing.  So, it's at least possible to do this without having
the global LRU designed around the way you want to reclaim.

Also, if you get _too_ dependent on the global LRU, what are you going
to do if our cgroup buddies manage to get cgroup'd pages off the global
LRU?  

-- Dave

