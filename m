Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760770Ab2KBW7T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 18:59:19 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34585 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760565Ab2KBW7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 18:59:17 -0400
Date: Fri, 2 Nov 2012 15:59:12 -0700
From: Tejun Heo <tj@kernel.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Ric Wheeler <rwheeler@redhat.com>,
        Petr Matousek <pmatouse@redhat.com>, Kay Sievers <kay@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: Re: setting up CDB filters in udev (was Re: [PATCH v2 0/3] block:
 add queue-private command filter, editable via sysfs)
Message-ID: <20121102225912.GD27843@mtj.dyndns.org>
References: <1657557410.1945557.1351190120407.JavaMail.root@redhat.com>
 <20121031212241.GZ2945@htj.dyndns.org>
 <5093DD5E.6030808@redhat.com>
 <20121102153530.483453c7@pyramind.ukuu.org.uk>
 <20121102164828.GA3823@mtj.dyndns.org>
 <20121102172145.184abfe3@pyramind.ukuu.org.uk>
 <20121102173022.GA27843@mtj.dyndns.org>
 <20121102201824.41b2516d@pyramind.ukuu.org.uk>
 <20121102202131.GE9169@htj.dyndns.org>
 <20121102204825.7e4bd641@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121102204825.7e4bd641@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Alan.

On Fri, Nov 02, 2012 at 08:48:25PM +0000, Alan Cox wrote:
> If you look back through the archive you'll find people have been
> spending a good decade bitching about the lack of filter configurability
> and trying to get someone else to fix it.
> 
> The BPF filter is simpler than just about any other implementation
> because the tools exist and are used for lots of other things and it has
> an API that is precisely defined as well as kernel calls to run the
> filter.

Sure, if we *have* to go for flexible filtering, BPF would be the
right way to do it.  I'm just not convinced such flexibility is
justified.

> Some reasons for it
> 
> - giving people access to parts of disks

Are we gonna implement random range restriction inside a partition
too?  If we want to check against partition ranges for allowed SG_IO
commands, by all means, but it can easily be implemented as part of
the fixed filter.

> - allowing access to specific vendor specific commands on certain
>   non-standard CD and DVD drives so they can be used for burning but you
>   can't trash them

At this point, most burning commands are standardized, and optical
drives are generally on the way out.  If you absolutely have to use
some vendor specific commands, be root.

> - giving end users minimal access to things like SMART but only on drives
>   where it is safe

End users already have pretty good access to SMART data via udisks and
it's way more flexible and intelligent than some in-kernel filter.

> - giving a user a SCSI disk or partition to play with but preventing them
>   issuing weird ass commands that can disrupt other devices in the fabric
>   (like drive to drive transfers, some kinds of resets, management
>   commands)
> - minimising the ability of a VM to do damage if compromised while
>   maximising its raw access to a device

Maybe, I don't know.  It all sounds highly marginal to me.

For complex/intelligent access policies, kernel isn't the right place
to do it anyway - you want strong integration with the rest of the
system especially for desktop.  Ones which can justify kernel-side
filtering would be things which are pretty low-level and require low
overhead.  I think VMs fall in this category, but then again being
able to bypass standard filters seems workable enough for that.  Sure,
an extra layer of filtering on top could be nice but again I just
don't think that's a strong enough justification.

Thanks.

-- 
tejun
