Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755Ab2DWRJH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 13:09:07 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:19094 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754668Ab2DWRJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 13:09:03 -0400
Date: Mon, 23 Apr 2012 13:03:27 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Luck, Tony" <tony.luck@intel.com>, "Liu, Jinsong" <jinsong.liu@intel.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@amd64.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 1/3] Add mcelog support for xen platform
Message-ID: <20120423170327.GC22364@phenom.dumpdata.com>
References: <DE8DF0795D48FD4CA783C40EC8292335154EFC@SHSMSX101.ccr.corp.intel.com>
 <20120421041454.GA29704@phenom.dumpdata.com>
 <20120421104502.GB17005@aftab.osrc.amd.com>
 <3908561D78D1C84285E8C5FCA982C28F170EF841@ORSMSX104.amr.corp.intel.com>
 <4F958098.1050402@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F958098.1050402@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2012 at 09:17:28AM -0700, H. Peter Anvin wrote:
> On 04/23/2012 08:27 AM, Luck, Tony wrote:
> >> Because, if you'd hooked into it, just imagine one fine day, when we
> >> remove mcelog support, what screaming the xen people will be doing when
> >> mcelog doesn't work anymore.
> > 
> > Agreed. Even before we get to deleting mcelog, "struct mce" can change (new
> > fields could be added) ... and you don't want to have your hypervisor to
> > have to know which version of Linux it is talking to.
> 
> This is a great example on the fundamental problem with Xen, or rather
> the approach that Xen has taken of grabbing random kernel internals and
> claiming them as APIs (or, in some cases even as ABIs.)  A lot of these

I am _not_ claiming that. If I left you with that impression from my
responses - my fault for not getting my point across (the sleep deprevation
is probably not helping either).

I am _not_ stating that the usage of 'mce_log' or 'struct mce' MUST
remain the same from now on. No. I am saying that the driver will be
changed lock-step as Tony and Boris see fit in changing the functions.

And currently the way the existing MCE drivers do this - is by using
mce_log. This driver does is too - since the in-tree drivers do it this way.
When they change to use a different mechanism - this driver will as well.

> have had problems that are now very nearly unfixable, and that has
> seriously stalled out the ability of evolve the Linux kernel in some
> areas.  Note that the cost of this is borne by the development
> community, not by the Xen maintainers.

The ones I know that you are unhappy about are the MMU paravirt interfaces
and I did mention to you that once some prototype work is done and
it showed success, I will work on removing said support.

Why don't you send me your unhappy list so that is on my radar as well please?

> 
> 	-hpa
> 
> -- 
> H. Peter Anvin, Intel Open Source Technology Center
> I work for Intel.  I don't speak on their behalf.
> 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
