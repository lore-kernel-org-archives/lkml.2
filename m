Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179Ab0JKUfs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 16:35:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11771 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755726Ab0JKUfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 16:35:47 -0400
Date: Mon, 11 Oct 2010 16:35:18 -0400
From: Don Zickus <dzickus@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>
Subject: Re: [PATCH -v3 3/6] x86, NMI, Rewrite NMI handler
Message-ID: <20101011203518.GB24567@redhat.com>
References: <1286606987-19879-1-git-send-email-ying.huang@intel.com>
 <1286606987-19879-3-git-send-email-ying.huang@intel.com>
 <1286813635.2336.617.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286813635.2336.617.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 11, 2010 at 06:13:55PM +0200, Peter Zijlstra wrote:
> On Sat, 2010-10-09 at 14:49 +0800, Huang Ying wrote:
> > notify_die(DIE_NMI_IPI);
> > notify_die(DIE_NMI);
> > /* process io port 0x61 */
> > nmi_watchdog_touch();
> > unknown_nmi(); 
> 
> Why keep NMI_IPI? What the heck is it for?
> 
> I'd like to see:
> 
>  DIE_NMI
>  DIE_NMI_UNKNOWN
> 
> In DIE_NMI we walk the chain and deal with NMIs, in DIE_NMI_UNKNOWN we
> try to consume extra NMIs where possible (like the much discussed extra
> PMU interrupts).

Yeah, there was another much discussed thread about creating an NMI
notifier chain (instead of using the die_chain).  And then re-arrange
handlers according to a priority scheme.

I wouldn't mind have Ingo commit most of this patchset to a temporary
work-in-progress branch and have us build more changes on top.  A lot of
these changes are a good stepping stone towards simplifying things.

Cheers,
Don
