Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756300Ab2EYNcT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 09:32:19 -0400
Received: from mga02.intel.com ([134.134.136.20]:52450 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755622Ab2EYNcP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 09:32:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="148391866"
Message-ID: <4FBF89C3.3050308@linux.intel.com>
Date: Fri, 25 May 2012 06:31:47 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Dan Williams <dan.j.williams@intel.com>, mroos@linux.ee,
        linux-scsi@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH 1/4] async: introduce 'async_domain' type
References: <20120525074813.21933.91876.stgit@dwillia2-linux.jf.intel.com>  <20120525075027.21933.75815.stgit@dwillia2-linux.jf.intel.com> <1337932267.2932.7.camel@dabdike.int.hansenpartnership.com>
In-Reply-To: <1337932267.2932.7.camel@dabdike.int.hansenpartnership.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/25/2012 12:51 AM, James Bottomley wrote:
> On Fri, 2012-05-25 at 00:50 -0700, Dan Williams wrote:
>> This is in preparation for teaching async_synchronize_full() to sync all
>> pending async work, and not just on the async_running domain.  This
>> conversion is functionally equivalent, just embedding the existing list
>> in a new async_domain type.
> 
> This looks good, but I want Arjan and others who invented the async code
> to speed up boot to comment on all of this.  What was the intention of
> async_synchronize_full() and if it wasn't to synchronise all domains,
> should we fix the documentation and add a new primitive to do that,
> since boot clearly assumes the all domains behaviour.

it was not what was intended originally (the domains were supposed to be
completely independent beasts), however I can see that this is confusing
and even undesired, so I am ok with the change.
Ideally we get a way to have an async domain opt out of the global sync,
but until I get an actual user of that into mainline, don't worry about it.
