Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751961Ab0DZOem (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 10:34:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:55934 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751128Ab0DZOek (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 10:34:40 -0400
Message-ID: <4BD5A43D.2060009@kernel.org>
Date: Mon, 26 Apr 2010 16:33:33 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Pekka J Enberg <penberg@cs.helsinki.fi>
CC: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Christoph Lameter <cl@linux.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Alex Shi <alex.shi@intel.com>, tim.c.chen@intel.com, npiggin@suse.de,
       rientjes@google.com
Subject: Re: [Bug #15713] hackbench regression due to commit 9dfc6e68bfe6e
References: <deuQKFRcc0B.A.3EG.BRSzLB@tosh> <YeFfFNFyTSF.A.vjH.sRSzLB@tosh>  <alpine.DEB.2.00.1004221045270.1204@router.home>  <4BD086D0.9090309@cs.helsinki.fi>  <alpine.DEB.2.00.1004232214520.29018@melkki.cs.helsinki.fi>  <1272265147.2078.648.camel@ymzhang.sh.intel.com>  <i2m84144f021004260022nb58e3e27vd351d6646b99f265@mail.gmail.com>  <4BD564BE.6020700@kernel.org> <x2o84144f021004260309k9edf9e88t92e4c988d12de234@mail.gmail.com> <4BD570A8.90304@kernel.org> <alpine.DEB.2.00.1004261710500.16526@melkki.cs.helsinki.fi>
In-Reply-To: <alpine.DEB.2.00.1004261710500.16526@melkki.cs.helsinki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 26 Apr 2010 14:33:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Pekka.

On 04/26/2010 04:17 PM, Pekka J Enberg wrote:
> Even if the cacheline is dirtied like in the struct kmem_cache_cpu case?

If my hypothesis is the case, I don't think dirtying or not would
matter.  It's about two cpus sharing a cache line which usually is a
bad idea but in this case happens to be a good idea because the two
cpus sit on the same cache.

> If that's the case, don't we want the per-CPU allocator to support back
> to back allocation for cores that are in the same package?

I think it's probably gonna be an over-engineering effort.  W/ percpu
allocator the rest of the cacheline would likely be occupied by
another percpu item for the cpu, so it's not really wasted.  It's just
used differently.  It would be good if we have a way to better pack
small hot ones (for the same cpu) into the same cachelines but I don't
think it would be wise to interleave stuff from different cpus.  It's
not like there's only single way to save a cacheline after all.

Thanks.

-- 
tejun
