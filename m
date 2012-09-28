Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758051Ab2I1M1c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 08:27:32 -0400
Received: from mga01.intel.com ([192.55.52.88]:24837 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757800Ab2I1M12 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 08:27:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,502,1344236400"; 
   d="scan'208";a="227730941"
Date: Fri, 28 Sep 2012 20:27:19 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Borislav Petkov <bp@amd64.org>, Conny Seidel <conny.seidel@amd.com>,
        Jan Kara <jack@suse.cz>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <jweiner@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] CPU hotplug, writeback: Don't call
 writeback_set_ratelimit() too often during hotplug
Message-ID: <20120928122719.GA3067@localhost>
References: <20120924102324.GA22303@aftab.osrc.amd.com>
 <20120924142305.GD12264@quack.suse.cz>
 <20120924143609.GH22303@aftab.osrc.amd.com>
 <20120924201650.6574af64.conny.seidel@amd.com>
 <20120924181927.GA25762@aftab.osrc.amd.com>
 <5060AB0E.3070809@linux.vnet.ibm.com>
 <5060C714.8030606@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5060C714.8030606@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 02:18:20AM +0530, Srivatsa S. Bhat wrote:
> 
> From: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> 
> The CPU hotplug callback related to writeback calls writeback_set_ratelimit()
> during every state change in the hotplug sequence. This is unnecessary
> since num_online_cpus() changes only once during the entire hotplug operation.
> 
> So invoke the function only once per hotplug, thereby avoiding the
> unnecessary repetition of those costly calculations.
> 
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> ---

Looks good to me. I'll include it in the writeback tree.

Thanks,
Fengguang
