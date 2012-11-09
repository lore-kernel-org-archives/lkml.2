Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753Ab2KIPeH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 10:34:07 -0500
Received: from mga01.intel.com ([192.55.52.88]:6941 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750922Ab2KIPeF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 10:34:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,746,1344236400"; 
   d="scan'208";a="246535991"
Message-ID: <509D226B.30904@linux.intel.com>
Date: Fri, 09 Nov 2012 07:34:03 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: svaidy@linux.vnet.ibm.com
CC: Mel Gorman <mgorman@suse.de>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        akpm@linux-foundation.org, mjg59@srcf.ucam.org,
        paulmck@linux.vnet.ibm.com, dave@linux.vnet.ibm.com,
        maxime.coquelin@stericsson.com, loic.pallardy@stericsson.com,
        kmpark@infradead.org, kamezawa.hiroyu@jp.fujitsu.com, lenb@kernel.org,
        rjw@sisk.pl, gargankita@gmail.com, amit.kachhap@linaro.org,
        thomas.abraham@linaro.org, santosh.shilimkar@ti.com,
        linux-pm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/8][Sorted-buddy] mm: Linux VM Infrastructure to
 support Memory Power Management
References: <20121106195026.6941.24662.stgit@srivatsabhat.in.ibm.com> <20121108180257.GC8218@suse.de> <20121109051247.GA499@dirshya.in.ibm.com>
In-Reply-To: <20121109051247.GA499@dirshya.in.ibm.com>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/8/2012 9:14 PM, Vaidyanathan Srinivasan wrote:
> * Mel Gorman <mgorman@suse.de> [2012-11-08 18:02:57]:
> 
>> On Wed, Nov 07, 2012 at 01:22:13AM +0530, Srivatsa S. Bhat wrote:
>>> ------------------------------------------------------------
> 
> Hi Mel,
> 
> Thanks for detailed review and comments.  The goal of this patch
> series is to brainstorm on ideas that enable Linux VM to record and
> exploit memory region boundaries.
> 
> The first approach that we had last year (hierarchy) has more runtime
> overhead.  This approach of sorted-buddy was one of the alternative
> discussed earlier and we are trying to find out if simple requirements
> of biasing memory allocations can be achieved with this approach.
> 
> Smart reclaim based on this approach is a key piece we still need to
> design.  Ideas from compaction will certainly help.

reclaim may be needed for the embedded use case
but at least we are also looking at memory power savings that come for content-preserving power states.
For that, Linux should *statistically* not be actively using (e.g. read or write from it) a percentage of memory...
and statistically clustering is quite sufficient for that.

(for example, if you don't use a DIMM for a certain amount of time,
the link and other pieces can go to a lower power state,
even on todays server systems.
In a many-dimm system..  if each app is, on a per app basis,
preferring one dimm for its allocations, the process scheduler will
help us naturally keeping the other dimms "dark")

If you have to actually free the memory, it is a much much harder problem,
increasingly so if the region you MUST free is quite large.

if one solution can solve both cases, great, but lets not make both not happen
because one of the cases is hard...
(and please lets not use moving or freeing of pages as a solution for at least the
content preserving case)
