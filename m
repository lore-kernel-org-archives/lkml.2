Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030874Ab2CFPBI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 10:01:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48604 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030778Ab2CFPBG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 10:01:06 -0500
Date: Tue, 6 Mar 2012 10:00:00 -0500
From: Don Zickus <dzickus@redhat.com>
To: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org, paulus@samba.org,
        mingo@elte.hu, acme@ghostprotocols.net,
        Vegard Nossum <vegardno@ifi.uio.no>, tony.luck@intel.com, bp@amd64.org,
        robert.richter@amd.com, lenb@kernel.org, minyard@acm.org,
        wim@iguana.be, linux-edac@vger.kernel.org, oprofile-list@lists.sf.net,
        linux-acpi@vger.kernel.org, openipmi-developer@lists.sourceforge.net,
        linux-watchdog@vger.kernel.org
Subject: Re: [PATCH v3 x86 1/2]  fix page faults by nmiaction in nmi if
 kmemcheck is enabled
Message-ID: <20120306150000.GK3083@redhat.com>
References: <1329717665.3448.28.camel@ThinkPad-T61>
 <1329735648.2293.307.camel@twins>
 <1329788560.3448.45.camel@ThinkPad-T61>
 <1329819437.2293.382.camel@twins>
 <1329990828.19165.36.camel@ThinkPad-T61>
 <1330340324.11248.60.camel@twins>
 <1330941917.24353.63.camel@ThinkPad-T61>
 <1330969747.11248.250.camel@twins>
 <20120305214545.GH3083@redhat.com>
 <1331028583.15778.3.camel@ThinkPad-T61>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331028583.15778.3.camel@ThinkPad-T61>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 06, 2012 at 06:09:43PM +0800, Li Zhong wrote:
> This patch tries to fix the problem of page fault exception caused by
> accessing nmiaction structure in nmi if kmemcheck is enabled. 
> 
> If kmemcheck is enabled, the memory allocated through slab are in pages
> that are marked non-present, so that some checks could be done in the
> page fault handling code ( e.g. whether the memory is read before
> written to ). 
> As nmiaction is allocated in this way, so it resides in a non-present
> page. Then there is a page fault while the nmi code accessing the
> nmiaction structure, which would then cause a warning by
> WARN_ON_ONCE(in_nmi()) in kmemcheck_fault(), called by do_page_fault().
> 
> v2: as Peter suggested, changed the nmiaction to use static storage.
> 
> v3: as Peter suggested, use macro to shorten the codes. Also keep the
> original usage of register_nmi_handler, so users of this call doesn't
> need change. 

Thanks Li!  Looks fine to me.  I'll run some tests to make sure things
still work correctly.

Cheers,
Don
