Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753703Ab2FDRSL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 13:18:11 -0400
Received: from merlin.infradead.org ([205.233.59.134]:35958 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414Ab2FDRSK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 13:18:10 -0400
Message-ID: <1338830279.28282.117.camel@twins>
Subject: Re: [PATCH] cpuidle: menu: use nr_running instead of cpuload for
 calculating perf mult
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Vladimir Davydov <VDavydov@parallels.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        Len Brown <lenb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 04 Jun 2012 19:17:59 +0200
In-Reply-To: <33E662E8-48BF-49A7-A4A0-CB1A751AAEBC@parallels.com>
References: <1338805485-10874-1-git-send-email-vdavydov@parallels.com>
	 <1338805967.28282.12.camel@twins> <4FCCB486.4040905@linux.intel.com>
	 <1338817519.28282.54.camel@twins> <4FCCBC97.8060101@linux.intel.com>
	 <1338822509.28282.65.camel@twins> <4FCCD0CD.8080700@linux.intel.com>
	 <1338823568.28282.79.camel@twins> <4FCCD6B7.4030703@linux.intel.com>
	 <1338827607.28282.99.camel@twins> <4FCCE823.8090700@linux.intel.com>
	 <33E662E8-48BF-49A7-A4A0-CB1A751AAEBC@parallels.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-04 at 21:08 +0400, Vladimir Davydov wrote:
> But this_cpu_load(), which is currently used by cpuidle, does not
> return the "load average". It returns the value of cpuload at some
> moment in the past (actually, the value is updated in
> update_cpu_load()). This value is usually used for load balancing.
> 
> Moreover, this value does not reflect the real cpu load from the
> cpuidle pow, because it depends on tasks priority (nice) and, what is
> worse, with the introduction of cgroups it can be pretty arbitrary.
> For instance, each group of tasks is accounted just as a single task
> with standard priority "spreaded" among all cpus, no matter how many
> tasks are actually running in it. 

Indeed. 
