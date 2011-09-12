Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757599Ab1ILOra (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 10:47:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2412 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755899Ab1ILOr2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 10:47:28 -0400
Date: Mon, 12 Sep 2011 10:47:18 -0400
From: Jason Baron <jbaron@redhat.com>
To: Joe Perches <joe@perches.com>
Cc: Jim Cromie <jim.cromie@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, gregkh@suse.de,
        Bart Van Assche <bvanassche@acm.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] dynamic_debug: consolidate repetitive struct _ddebug
 descriptor definitions
Message-ID: <20110912144717.GB2555@redhat.com>
References: <94c0e3275b0bf7d2cad8e7909da1482a867e7bc6.1314725877.git.jbaron@redhat.com>
 <20110908165230.a7505321.akpm@linux-foundation.org>
 <1315534396.11939.10.camel@Joe-Laptop>
 <20110908204200.6cf7abc2.akpm@linux-foundation.org>
 <1315540963.11939.12.camel@Joe-Laptop>
 <CAO+b5-oOHXEhnA+zpwA9GR7k1TX3Wn6XuOdc3TB4MPNiSpskiw@mail.gmail.com>
 <CAJfuBxx=r_P7em_naUN_c96A++V4v6nfd8B_V2dppRag-z_qwg@mail.gmail.com>
 <1315602252.23777.5.camel@Joe-Laptop>
 <CAJfuBxwtefLyJcz1EbKvsGJ+XMtJiRW7A3Yy+wHXgL3GpUXbSg@mail.gmail.com>
 <1315607527.23777.21.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315607527.23777.21.camel@Joe-Laptop>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 09, 2011 at 03:32:05PM -0700, Joe Perches wrote:
> > The trick is then to allow those users to define flag-chars that they like
> > (mnemonic value), and that work with the dynamic-debug mini-language
> > implemented in $CONTROL reader.
> 
> I don't think that's a problem really.
> 
> I think a simple control/test variable as either value
> or mask would work fine.
> 
> Take a single bit control to either test as mask
> or test as level.  No mnemonic letters needed.
> 
> pr_debug_mask(mask, fmt, ...)
> pr_debug_level(level, fmt, ...)
> 
> could set the appropriate type bit in the struct
> so the test works as appropriate.
> 
> echo 'value <foo>' > <debugfs>/dynamic_debug/control
> 
> > But that begs the question - is there a reason why __aligned(4)
> > wouldnt work for 32 bit machines ?   It would reduce the footprint
> > for small machines.
> 
> No real idea why it's aligned(8).  Jason?
> 

I think when I first implemented it, I noticed that subsystems that did
similar things, set aligned(8) in include/asm-generic/vmlinux.lds.h. For
example, FTRACE_EVENTS() sets ALIGN(8)...I know that not a great reason
thouh :( Don't remember if I tried ALIGN(4), but if it saves space, we
can look at it...

Also, as I mentioned before, we probably need an extra array of pointers into
the dynamic debug structures. see: https://lkml.org/lkml/2011/1/26/463.

thanks,

-Jason
