Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751612Ab0CQDBV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 23:01:21 -0400
Received: from ppp167-251-209.static.internode.on.net ([59.167.251.209]:60017
	"EHLO cheesypoof.guarana.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751079Ab0CQDBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 23:01:20 -0400
X-Greylist: delayed 613 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Mar 2010 23:01:19 EDT
Date: Wed, 17 Mar 2010 13:51:01 +1100
From: Kevin Easton <caf@guarana.org>
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: Re: ATA 4 KiB sector issues.
Message-ID: <20100317025101.GA13339@guarana.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268752993.21384.23.camel@mulgrave.site>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> On Wed, 2010-03-17 at 00:20 +0900, Tejun Heo wrote:

...

> > Well, the thing is that
> > 
> > * Anything remotely modern (>= XP) doesn't give a hoot about cylinder
> >   alignment.
> > 
> > * Anything older (<= 2000) is very likely to get confused with custom
> >   geometry starting from the BIOS itself.  For those cases, the only
> >   thing we can do is aligning partitions to cylinders abiding BIOS
> >   supplied geometry parameters which will usually be 255/63.
> > 
> > So, using custom geometry doesn't help compatibility at all.
> 
> Our partitioning tool still obey the integral cylinder rule ... we can
> argue about whether they should, but what we need is a strategy for
> fixing what is rather than what should be.

James / Tejun,

Can't we fix the problem by defaulting to aligning partitions to
start on an LBA that is a multiple of 64260 ?

Such partitions will always be 4KiB-aligned, *and* start-of-cylinder
aligned (assuming 255/63, as seems to be the norm).

Sure, that reduces your partition granularity to almost-32-MiB, but
that's pretty small potatoes these days (and it's only a *default*, so
you could always override that if you really cared, and didn't need 
the compatibility).

    - Kevin

