Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759183Ab1CDAcz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 19:32:55 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:54082 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759138Ab1CDAcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 19:32:54 -0500
Subject: Re: [PATCH] Make /proc/slabinfo 0400
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Matt Mackall <mpm@selenic.com>
Cc: Dan Rosenberg <drosenberg@vsecurity.com>, cl@linux-foundation.org,
        penberg@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <1299193700.3062.260.camel@calx>
References: <1299174652.2071.12.camel@dan>  <1299185882.3062.233.camel@calx>
	 <1299186986.2071.90.camel@dan>  <1299188667.3062.259.camel@calx>
	 <1299191400.2071.203.camel@dan>  <1299193700.3062.260.camel@calx>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Thu, 03 Mar 2011 16:32:49 -0800
Message-ID: <1299198769.8493.2981.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-03 at 17:08 -0600, Matt Mackall wrote:
> > I appreciate your input on this, you've made very reasonable points.
> > I'm just not convinced that those few real users are being substantially
> > inconvenienced, even if there's only a small benefit for the larger
> > population of users who are at risk for attacks.  Perhaps others could
> > contribute their opinions to the discussion.


Kees Cook was nice enough to point out a few of the ways this can get
misused.  It looks like the basic pattern is to use slabinfo to
determine where an object was likely to have been allocated in the slab
in order to more precisely target the next stage of the attack.

I do see how much easier slabinfo makes this.  Do any of the attacks
that we know about rely on anything _but_ trying to figure out when a
slab page got consumed?

If I were an attacker, I'd probably just start watching /proc/meminfo
for when Slab/SReclaimable/SUnreclaim get bumped.  That'll also give me
a pretty good indicator of where my object is in the slab.

Granted, doing that still puts one more level of opaqueness in the way.
slabinfo definitely makes it more straightforward.

-- Dave

