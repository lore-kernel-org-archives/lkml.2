Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756990Ab0JUGRE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 02:17:04 -0400
Received: from mga03.intel.com ([143.182.124.21]:62357 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752991Ab0JUGRC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 02:17:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,216,1286175600"; 
   d="scan'208";a="338657178"
Date: Thu, 21 Oct 2010 14:17:01 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>
Subject: Re: [tip:x86/mm] percpu: Introduce a read-mostly percpu API
Message-ID: <20101021061701.GA17054@sli10-conroe.sh.intel.com>
References: <1287544022.4571.7.camel@sli10-conroe.sh.intel.com>
 <tip-c957ef2c59e952803766ddc22e89981ab534606f@git.kernel.org>
 <20101021013833.GA21863@sli10-conroe.sh.intel.com>
 <1287639230.2545.117.camel@edumazet-laptop>
 <4CBFD5A6.3060308@zytor.com>
 <1287641277.4507.23.camel@edumazet-laptop>
 <4CBFD92B.5090503@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4CBFD92B.5090503@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 21, 2010 at 02:09:47PM +0800, H. Peter Anvin wrote:
> On 10/20/2010 11:07 PM, Eric Dumazet wrote:
> > Le mercredi 20 octobre 2010 à 22:54 -0700, H. Peter Anvin a écrit :
> > 
> >> L1_CACHE_BYTES is completely pointless, since if there is sharing to
> >> worry about *at all*, it's probably at the L2 or L3 cache levels.
> >>
> > 
> > I see, and we dont have better way to express this hint/requirement than
> > using PAGE_SIZE or INTERNODE_CACHE_SHIFT ?
> > 
> > In your patch you force a PAGE_SIZE alignement *before*
> > *(.data..percpu..page_aligned)   
> > 
> > If this alignment is really needed, this should be part of another
> > patch, since this fixes a previous bug in 2.6.36 ?
> > 
> 
> It was part of Shaohua's patch... I don't know if it does anything
> useful, but it also doesn't hurt.
This isn't a previous bug. see
#define DECLARE_PER_CPU_PAGE_ALIGNED(type, name)			\
	DECLARE_PER_CPU_SECTION(type, name, "..page_aligned")		\
	__aligned(PAGE_SIZE)
the ..page_aligned is already page aligned. I add it is because it can make
the .readmostly section guarantee to have no cache false sharing, because
I add the . = ALIGN(PAGE_SIZE); before .readmostly section, and .page_aligned
follows, but for sure this wates some memory.
