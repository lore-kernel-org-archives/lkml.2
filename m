Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144Ab2GIQXO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 12:23:14 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:33950 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830Ab2GIQXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 12:23:12 -0400
Date: Mon, 9 Jul 2012 12:14:49 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH 1/4] xen/p2m: Optimize the
 get_phys_to_machine function a bit.
Message-ID: <20120709161448.GA17595@phenom.dumpdata.com>
References: <1341330038-21686-1-git-send-email-konrad.wilk@oracle.com>
 <1341330038-21686-2-git-send-email-konrad.wilk@oracle.com>
 <4FFAFBA4.4050603@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FFAFBA4.4050603@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 09, 2012 at 04:41:24PM +0100, David Vrabel wrote:
> On 03/07/12 16:40, Konrad Rzeszutek Wilk wrote:
> > Running perf tells me that the check for p2m_identity
> > is done a lot - more than it should.
> 
> This patch doesn't change the how often the check is done.  Is this just
> bad wording of the description?

Its bad wording plus it really does not change the assmebler code - I thought
it did but since there is only one "if" case it does not matter how
much I put unlikely in front of it - it is the only branch condition.

Perhaps if I make the code be put in a variable (register) that would
optimize this a bit more...


> > 
> > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > ---
> >  arch/x86/xen/p2m.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
> > index 64effdc..161bcdc 100644
> > --- a/arch/x86/xen/p2m.c
> > +++ b/arch/x86/xen/p2m.c
> > @@ -406,7 +406,7 @@ unsigned long get_phys_to_machine(unsigned long pfn)
> >  	 * and in p2m_*missing, so returning the INVALID_P2M_ENTRY
> >  	 * would be wrong.
> >  	 */
> > -	if (p2m_top[topidx][mididx] == p2m_identity)
> > +	if (unlikely(p2m_top[topidx][mididx] == p2m_identity))
> >  		return IDENTITY_FRAME(pfn);
> >  
> >  	return p2m_top[topidx][mididx][idx];
