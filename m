Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751Ab2KSOcn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 09:32:43 -0500
Received: from mga02.intel.com ([134.134.136.20]:50362 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752498Ab2KSOcm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 09:32:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,279,1352102400"; 
   d="scan'208";a="221684516"
Date: Mon, 19 Nov 2012 16:32:36 +0200
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Rob Clark <rob.clark@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>, patches@linaro.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Jamie Lokier <jamie@shareable.org>
Subject: Re: [PATCH] ARM: add get_user() support for 8 byte types
Message-ID: <20121119143236.GA3296@intel.com>
References: <1352495853-9790-1-git-send-email-rob.clark@linaro.org>
 <201211151339.08016.arnd@arndb.de>
 <CAF6AEGuJReNtwUZX6HVZCE8GHuyEAyC8bM0GqZuVMV1=DrGJVw@mail.gmail.com>
 <201211151439.41393.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201211151439.41393.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 15, 2012 at 02:39:41PM +0000, Arnd Bergmann wrote:
> On Thursday 15 November 2012, Rob Clark wrote:
> > > I still haven't heard a conclusive argument why we need to use get_user()
> > > rather than copy_from_user() in the DRM code. Is this about a fast path
> > > where you want to shave off a few cycles for each call, or does this
> > > simplify the code structure, or something else?
> > 
> > well, it is mostly because it seemed like a good idea to first try to
> > solve the root issue, rather than having to fix things up in each
> > driver when someone from x86-world introduces a 64b get_user()..
> 
> As pointed out by hpa earlier, x86-32 doesn't have a 64b get_user
> either. I don't think we have a lot of drivers that are used only
> on 64-bit x86 and on 32-bit ARM but not on 32-bit x86.

Ouch. I didn't realize that x86-32 doesn't have it. All the systems
where I've run the new code are 64bit so I never noticed the problem.

I see there was a patch [1] posted a long time ago to implement 64bit
get_user() on x86-32. I wonder what happened to it?

[1] https://lkml.org/lkml/2004/4/20/96

-- 
Ville Syrjälä
Intel OTC
