Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022Ab1LMTGn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 14:06:43 -0500
Received: from mga11.intel.com ([192.55.52.93]:60045 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821Ab1LMTGl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 14:06:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="95752254"
Date: Tue, 13 Dec 2011 11:06:32 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Christoph Lameter <cl@linux.com>,
        lee.schermerhorn@hp.com, David Rientjes <rientjes@google.com>
Subject: Re: [patch v3]numa: add a sysctl to control interleave allocation
 granularity from each node to improve I/O performance
Message-ID: <20111213190632.GA5830@tassilo.jf.intel.com>
References: <1323655125.22361.376.camel@sli10-conroe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323655125.22361.376.camel@sli10-conroe>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 09:58:45AM +0800, Shaohua Li wrote:
> If mem plicy is interleaves, we will allocated pages from nodes in a round
> robin way. This surely can do interleave fairly, but not optimal.
> 
> Say the pages will be used for I/O later. Interleave allocation for two pages
> are allocated from two nodes, so the pages are not physically continuous. Later

I would prefer to add a new policy (INTERLEAVE_MULTI or so) for this
instead of a global sysctl, that takes the additional parameter.

Also I don't like having more per task state. Could you compute this
from the address instead even for the process policy case?

-Andi
