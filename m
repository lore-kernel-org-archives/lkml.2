Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156Ab2EaA3i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 20:29:38 -0400
Received: from mga03.intel.com ([143.182.124.21]:53687 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753056Ab2EaA3h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 20:29:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="149722874"
Message-ID: <1338424236.14538.216.camel@ymzhang.sh.intel.com>
Subject: Re: [PATCH 2/2] x86 mce: use new printk recursion disabling
 interface
From: Yanmin Zhang <yanmin_zhang@linux.intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: ShuoX Liu <shuox.liu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, andi@firstfloor.org,
        Tony Luck <tony.luck@intel.com>, Ingo Molnar <mingo@elte.hu>
Date: Thu, 31 May 2012 08:30:36 +0800
In-Reply-To: <20120530090844.GA23663@liondog.tnic>
References: <4FBC444A.6060500@intel.com>
	 <20120523100138.GA13506@x1.osrc.amd.com> <4FBDCE4A.7050900@intel.com>
	 <20120524061145.GA18284@liondog.tnic>
	 <20120524155611.b7aeff4d.akpm@linux-foundation.org>
	 <1337905811.14538.206.camel@ymzhang.sh.intel.com>
	 <4FBF3295.7090608@intel.com> <4FBF32E8.90101@intel.com>
	 <20120525074114.GA5417@liondog.tnic> <4FC2DDFF.3020600@intel.com>
	 <20120530090844.GA23663@liondog.tnic>
Organization: MCG
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-30 at 11:08 +0200, Borislav Petkov wrote:
> On Mon, May 28, 2012 at 10:07:59AM +0800, ShuoX Liu wrote:
> > Boris,
> > I checked code and found some other functions in do_machine_check() also
> > would printk something. Such as add_taint(). So i think we'd better
> > place the recursion check at the beginning and the end of
> > do_machine_check(). Also more printks later(maybe) added will benefit
> > from this. Do you agree?
> 
> I'm not sure we want to disable printk recursion for add_taint() - it
> doesn't spit out any useful information wrt MCE so we could ignore it.
add_taint might be not a good case here. We could move the recursion check
flag setting around mce_panic.


> 
> Btw, I forgot to ask: this printk recursion disabling, do you have a
> real usecase where you don't get the MCE info in dmesg and with your
> patch it works or is this purely hypothetical?
We hit it when running a MTBF testing on a Android atom mobile.

Thanks,
Yanmin


