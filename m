Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751526Ab2EXASh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 20:18:37 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:64128 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751000Ab2EXASf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 20:18:35 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ak0JAOR8vU95LBCV/2dsb2JhbABDswsEgSCBCIIVAQEFOhwjEAgDDgouFCUDIROIDLskFIppQYRfA5UXj3GCfA
Date: Thu, 24 May 2012 10:18:31 +1000
From: Dave Chinner <david@fromorbit.com>
To: Glauber Costa <glommer@parallels.com>
Cc: Christoph Lameter <cl@linux.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] slab+slob: dup name string
Message-ID: <20120524001831.GQ25351@dastard>
References: <alpine.DEB.2.00.1205212018230.13522@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1205220855470.17600@router.home>
 <4FBBAE95.6080608@parallels.com>
 <alpine.DEB.2.00.1205221216050.17721@router.home>
 <alpine.DEB.2.00.1205221529340.18325@chino.kir.corp.google.com>
 <1337773595.3013.15.camel@dabdike.int.hansenpartnership.com>
 <4FBCD328.6060406@parallels.com>
 <1337775878.3013.16.camel@dabdike.int.hansenpartnership.com>
 <alpine.DEB.2.00.1205230947490.30940@router.home>
 <4FBCF951.3040105@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FBCF951.3040105@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 06:50:57PM +0400, Glauber Costa wrote:
> On 05/23/2012 06:48 PM, Christoph Lameter wrote:
> >On Wed, 23 May 2012, James Bottomley wrote:
> >
> >>>>So, why not simply patch slab to rely on the string lifetime being the
> >>>>cache lifetime (or beyond) and therefore not having it take a copy?
> >
> >Well thats they way it was for a long time. There must be some reason that
> >someone started to add this copying business....  Pekka?
> >
> The question is less why we added, but rather why we're keeping.
> 
> Of course reasoning about why it was added helps (so let's try to
> determine that), but so far the only reasonably strong argument in
> favor of keeping it was robustness.

I'm pretty sure it was added because there are slab names
constructed by snprintf on a stack buffer, so the name doesn't exist
beyond the slab initialisation function call...

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
