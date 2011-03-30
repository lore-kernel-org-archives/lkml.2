Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447Ab1C3BRe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 21:17:34 -0400
Received: from mga09.intel.com ([134.134.136.24]:11473 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755420Ab1C3BRc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 21:17:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,265,1299484800"; 
   d="scan'208";a="726741480"
Subject: Re: [PATCH]mmap: add alignment for some variables
From: Shaohua Li <shaohua.li@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-mm <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>, Rik van Riel <riel@redhat.com>,
        Hugh Dickins <hughd@google.com>
In-Reply-To: <20110329180611.a71fe829.akpm@linux-foundation.org>
References: <1301277536.3981.27.camel@sli10-conroe>
	 <m2oc4v18x8.fsf@firstfloor.org>	<1301360054.3981.31.camel@sli10-conroe>
	 <20110329152434.d662706f.akpm@linux-foundation.org>
	 <1301446882.3981.33.camel@sli10-conroe>
	 <20110329180611.a71fe829.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Mar 2011 09:17:23 +0800
Message-ID: <1301447843.3981.48.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-30 at 09:06 +0800, Andrew Morton wrote:
> On Wed, 30 Mar 2011 09:01:22 +0800 Shaohua Li <shaohua.li@intel.com> wrote:
> 
> > +/*
> > + * Make sure vm_committed_as in one cacheline and not cacheline shared with
> > + * other variables. It can be updated by several CPUs frequently.
> > + */
> > +struct percpu_counter vm_committed_as ____cacheline_internodealigned_in_smp;
> 
> The mystery deepens.  The only cross-cpu writeable fields in there are
> percpu_counter.lock and its companion percpu_counter.count.  If CPUs
> are contending for the lock then that itself is a problem - how does
> adding some padding to the struct help anything?
I had another patch trying to address the lock contention (for case
OVERCOMMIT_GUESS), will send out soon. But thought better to have the
correct alignment for OVERCOMMIT_NEVER case.

Thanks,
Shaohua

