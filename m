Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757Ab1DTCBi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 22:01:38 -0400
Received: from cantor.suse.de ([195.135.220.2]:37500 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751340Ab1DTCBh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 22:01:37 -0400
Date: Tue, 19 Apr 2011 19:01:28 -0700
From: Greg KH <gregkh@suse.de>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Hans Rosenfeld <hans.rosenfeld@amd.com>, linux-kernel@vger.kernel.org,
        stable@kernel.org, akpm@linux-foundation.org,
        "H. Peter Anvin" <hpa@linux.intel.com>, torvalds@linux-foundation.org,
        stable-review@kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [Stable-review] [12/28] x86, cpu: Clean up AMD erratum 400
 workaround
Message-ID: <20110420020128.GA27631@suse.de>
References: <20110419204117.979118654@clark.kroah.org>
 <1303263653.3464.65.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303263653.3464.65.camel@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 20, 2011 at 02:40:53AM +0100, Ben Hutchings wrote:
> On Tue, 2011-04-19 at 13:30 -0700, Greg KH wrote:
> > 2.6.32-longterm review patch.  If anyone has any objections, please let us know.
> > 
> > ------------------
> > 
> > From: Hans Rosenfeld <hans.rosenfeld@amd.com>
> > 
> > commit 9d8888c2a214aece2494a49e699a097c2ba9498b upstream.
> > 
> > Remove check_c1e_idle() and use the new AMD errata checking framework
> > instead.
> 
> Clean-up patches are generally not candidates for longterm updates.

This was added because a follow-on patch required it.

> However, I notice that the range of procesors considered to have erratum
> 400 was also changed:
> 
> [...]
> > +const int amd_erratum_400[] =
> > +	AMD_OSVW_ERRATUM(1, AMD_MODEL_RANGE(0xf, 0x41, 0x2, 0xff, 0xf),
> > +			    AMD_MODEL_RANGE(0x10, 0x2, 0x1, 0xff, 0xf));
> [...]
> > -	/* Family 0x0f models < rev F do not have C1E */
> > -	if (c->x86 == 0x0F && c->x86_model >= 0x40)
> > -		return 1;
> > -
> > -	if (c->x86 == 0x10) {
> > -		/*
> > -		 * check OSVW bit for CPUs that are not affected
> > -		 * by erratum #400
> > -		 */
> > -		if (cpu_has(c, X86_FEATURE_OSVW)) {
> [...]
> > -		}
> > -		return 1;
> [...]
> 
> Family 0x0f model 0x40 and model 0x41 stepping 0 and 1 are excluded.
> Family 0x10 model 0x00, 0x01 and model 0x02 stepping 0 are excluded.
> Is that the real fix here?

In this patch, no, it's just infrastructure for a later one.
And I think the bug you noticed here was also fixed in a later patch in
the series, right?

thanks,

greg k-h
