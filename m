Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934434Ab2KBS0X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 14:26:23 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:44891 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762175Ab2KBS0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 14:26:21 -0400
Date: Fri, 2 Nov 2012 14:24:30 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        linux-mm@kvack.org, ngupta@vflare.org, minchan@kernel.org,
        fschmaus@gmail.com, andor.daam@googlemail.com, ilendir@googlemail.com,
        akpm@linux-foundation.org, mgorman@suse.de
Subject: Re: [PATCH 2/5] mm: frontswap: lazy initialization to allow tmem
 backends to build/run as modules
Message-ID: <20121102182429.GA30100@konrad-lan.dumpdata.com>
References: <1351696074-29362-1-git-send-email-dan.magenheimer@oracle.com>
 <1351696074-29362-3-git-send-email-dan.magenheimer@oracle.com>
 <50915A5C.8000303@linux.vnet.ibm.com>
 <d7588a48-9f47-4f3a-852c-3fac916de75c@default>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d7588a48-9f47-4f3a-852c-3fac916de75c@default>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > +	frontswap_enabled = 1;
> > 
> > If frontswap_enabled is going to be on all the time, then what point
> > does it serve?  By extension, can all of the static inline wrappers in
> > frontswap.h be done away with?

Hm, or the frontswap_enabled can be converted to a "frontswap_flag"
which has:

#define FRONTSWAP_ON (1<<1)
#define FRONTSWAP_BACKEND_ON (1<<2)

or so? And then we can see if we can squash the 'backend_registerd'
and 'frontswap_enabled' together.
> 
> The intent of frontswap_enabled and cleancache_enabled was
> to avoid the overhead of a function call at the point where
> each frontswap/cleancache "hooks" is placed, using a global
> variable check instead.  I'm not sure if this minor
> performance tuning effort is worth preserving:  If not,
> I agree frontswap_enabled and the static inline wrappers (as
> well as their cleancache brethren) could be done away with **;
> if worth preserving, then I think frontswap_enabled could
> be set in the init method instead but the check for enabled
> in the frontswap init method and the cleancache init_fs
> method would need to be removed else lazy initialization
> wouldn't work.

Either way, that should be a seperate patch.
> 
> Dan
> 
> ** Note to anyone that tries this:  There is a subtle but
> clever hack in the wrappers suggested by Jeremy Fitzhardinge
> that disables the wrappers at compile-time as well as
> runtime.  IOW, make sure you test-compile both with
> CONFIG_{CLEANCACHE|FRONTSWAP} _and_ with them unconfig'd.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
