Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383Ab0HSQVT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 12:21:19 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:42315 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035Ab0HSQVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 12:21:17 -0400
Subject: Re: [PATCH] kernel-doc: be case insensitive when removing
 attributes
From: Johannes Berg <johannes@sipsolutions.net>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100819085710.fe790810.rdunlap@xenotime.net>
References: <1282227222.4507.8.camel@jlt3.sipsolutions.net>
	 <20100819085710.fe790810.rdunlap@xenotime.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 Aug 2010 18:21:15 +0200
Message-ID: <1282234875.4507.13.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-19 at 08:57 -0700, Randy Dunlap wrote:
> On Thu, 19 Aug 2010 16:13:42 +0200 Johannes Berg wrote:
> 
> > From: Johannes Berg <johannes.berg@intel.com>
> > 
> > There are valid attributes that could have upper
> > case letters, but we still want to remove, like
> > for example
> > 	__attribute__((aligned(NETDEV_ALIGN)))
> > as encountered in the wireless code.
> > 
> > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> > ---
> > I thought we did this before? Bit confused now :)
> 
> I have a similar patch, without patch description & signoff,
> so maybe it was from irc.  Oh, and it's in a different script location.

Oh, ok.

> @@ -1426,6 +1426,7 @@ sub dump_struct($$) {
>  	$members =~ s/kmemcheck_bitfield_.*?;//gos;
>  	# strip attributes
>  	$members =~ s/__aligned\s*\(\d+\)//gos;
> +	$members =~ s/__attribute__\s*\(\([a-zA-Z,_()\s\*]*\)\)//gos;
> 
> 
> If yours (below) does what is needed, that's fine with me.

Yes, it removes the warning for me.

johannes


