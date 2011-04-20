Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520Ab1DTRc4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 13:32:56 -0400
Received: from mga01.intel.com ([192.55.52.88]:20133 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751366Ab1DTRcz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 13:32:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,247,1301900400"; 
   d="scan'208";a="912336955"
Date: Wed, 20 Apr 2011 10:32:52 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Willy Tarreau <w@1wt.eu>, Dmitry Torokhov <dtor@vmware.com>,
        Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        stable@kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable-review@kernel.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [Stable-review] [24/28] USB: xhci - fix unsafe macro
 definitions
Message-ID: <20110420173252.GA5343@xanatos>
References: <20110419204119.285492847@clark.kroah.org>
 <1303264924.3464.69.camel@localhost>
 <20110420053925.GC16291@1wt.eu>
 <1303302875.3464.96.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303302875.3464.96.camel@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 20, 2011 at 01:34:35PM +0100, Ben Hutchings wrote:
> On Wed, 2011-04-20 at 07:39 +0200, Willy Tarreau wrote:
> > On Wed, Apr 20, 2011 at 03:02:04AM +0100, Ben Hutchings wrote:
> > > On Tue, 2011-04-19 at 13:31 -0700, Greg KH wrote:
> > > > 2.6.32-longterm review patch.  If anyone has any objections, please let us know.
> > > > 
> > > > ------------------
> > > > 
> > > > From: Dmitry Torokhov <dtor@vmware.com>
> > > > 
> > > > commit 5a6c2f3ff039154872ce597952f8b8900ea0d732 upstream.
> > > > 
> > > > Macro arguments used in expressions need to be enclosed in parenthesis
> > > > to avoid unpleasant surprises.
> > > 
> > > Do you know of any specific uses of these macros where the missing
> > > parentheses caused 'unpleasant surprises'?
> > 
> > In my opinion, this type of fix should be backported even if the current
> > code does not appear to be at risk, otherwise a later fix in the kernel
> > could cause a serious regression when backported to -stable. For instance,
> > if we later have to backport this patch (cut'n'pasted) :
> [...]
> 
> I agree, but would like to know whether there is an immediate effect.

No immediate breakage, AFAIK.  Dmitry found the issue by inspection.

Sarah Sharp
