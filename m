Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914Ab2FDUpR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 16:45:17 -0400
Received: from mga11.intel.com ([192.55.52.93]:39855 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753557Ab2FDUpO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 16:45:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="160615647"
Message-ID: <4FCD1E57.5070706@linux.intel.com>
Date: Mon, 04 Jun 2012 13:45:11 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Vladimir Davydov <vdavydov@parallels.com>, Ingo Molnar <mingo@elte.hu>,
        Len Brown <lenb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpuidle: menu: use nr_running instead of cpuload for
 calculating perf mult
References: <1338805485-10874-1-git-send-email-vdavydov@parallels.com>       <1338805967.28282.12.camel@twins> <4FCCB486.4040905@linux.intel.com>      <1338817519.28282.54.camel@twins> <4FCCBC97.8060101@linux.intel.com>     <1338822509.28282.65.camel@twins> <4FCCD0CD.8080700@linux.intel.com>    <1338823568.28282.79.camel@twins> <4FCCD6B7.4030703@linux.intel.com>   <1338827607.28282.99.camel@twins> <4FCCE823.8090700@linux.intel.com>  <1338830167.28282.115.camel@twins> <4FCCEF94.6010805@linux.intel.com> <1338841878.28282.133.camel@twins>
In-Reply-To: <1338841878.28282.133.camel@twins>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/4/2012 1:31 PM, Peter Zijlstra wrote:
> 
> And like I said many times now, if you inflate some of the idle periods,
> the work shifts (it doesn't become less) and a next idle period will be
> smaller -- since we'll only become idle again once all work is done.

this is what is not really correct.

you can be idle for many reasons, not just because you have no work
left. most common is waiting for a disk IO. the idle period for that
will not get shorter just because the previous one took more time.


