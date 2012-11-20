Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583Ab2KTQ1M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 11:27:12 -0500
Received: from relay3.sgi.com ([192.48.152.1]:56316 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751789Ab2KTQ1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 11:27:10 -0500
Date: Tue, 20 Nov 2012 10:27:07 -0600
From: Russ Anderson <rja@sgi.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dimitri Sivanich <sivanich@sgi.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Russ Anderson <rja@sgi.com>
Subject: Re: [patch] x86, UV: integer wrap bug in uv_hub_ipi_value()
Message-ID: <20121120162706.GB11150@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
References: <20121117151611.GB16900@elgon.mountain> <20121120004834.GE5060@sgi.com> <20121120042855.GE6186@mwanda> <20121120111055.64845785@pyramind.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121120111055.64845785@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 11:10:55AM +0000, Alan Cox wrote:
> On Tue, 20 Nov 2012 07:28:56 +0300 Dan Carpenter <dan.carpenter@oracle.com> wrote:
> > On Mon, Nov 19, 2012 at 06:48:34PM -0600, Russ Anderson wrote:
> > > On Sat, Nov 17, 2012 at 06:16:11PM +0300, Dan Carpenter wrote:
> > > > This is a static checker fix.  The problem is that we store the bits
> > > > from "uv_apicid_hibits" into "apicid" (the high 16 bits) but then we
> > > > shift it 16 bit to the left.  "apicid" is an int so it wraps and we lose
> > > > them.
> > > 
> > > Is this the complete patch?  phys_apicid is an int, but gets
> > > cast as unsigned long.  Doesn't phys_apicid also have to be
> > > changed to unsigned long?  And why ulong instead of uint (on x86_64)?
> > 
> > Uint is 32bit across all arches in linux and unix, according to
> > wikipedia. 
> 
> For Linux yes, if Wackypedia claims it for "unix" it's wrong 8) and varies
> between 16 and 36bits that I can think of.

64 bit int on old Cray cpus (unicos).  :-)

> If you specifically want 32bits use "u32", it's not going to make any
> actual difference to unsigned int but it makes the requirement explicit.

I very much agree.  I prefer u32, u64 (etc) because they are
unambiguous.  It removes all doubt as to the actual meaning.

Conversly, the fact that "long" has different meanings makes
it at best problematic.  Was the code written assuming "long"
was 32 or 64 bits?  Having data types that can have different
sizes is just asking for trouble.

-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
