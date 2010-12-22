Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285Ab0LVPAH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 10:00:07 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:58298 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463Ab0LVPAF (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 22 Dec 2010 10:00:05 -0500
Date: Wed, 22 Dec 2010 09:59:17 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com,
        Jan Beulich <JBeulich@novell.com>, xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad@kernel.org>
Subject: Re: [PATCH 02/10] xen/p2m: change p2m_missing_* to p2m_identity_*
Message-ID: <20101222145917.GB1760@dumpdata.com>
References: <1292967460-15709-1-git-send-email-konrad.wilk@oracle.com>
 <1292967460-15709-3-git-send-email-konrad.wilk@oracle.com>
 <4D112D13.8010208@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D112D13.8010208@goop.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 21, 2010 at 02:41:23PM -0800, Jeremy Fitzhardinge wrote:
> On 12/21/2010 01:37 PM, Konrad Rzeszutek Wilk wrote:
> > From: Konrad Rzeszutek Wilk <konrad@kernel.org>
> >
> > We are going to alter how we think about P2M. Most of the
> > P2M contains MFN, and areas that are not populated are
> > considered to be "missing". Missing means that the PFN
> > is either not set for this guest (not have that much memory
> > allocated) or is under the balloon driver ownership.
> >
> > We are instead now going to think of those not populated
> > areas as "identity." Meaning that that the PFN for which
> > we would get the p2m_identity we will provide the the PFN
> > value back instead of P2M_MISSING. Essentially treating
> > those regions as PFN==MFN.
> >
> 
> This renames missing -> identity, but does it actually change the
> functionality?  Doesn't it just leave it being misnamed?  It would
> probably be better to fold in the actual identity implementation as well.

You sure? It would be a lot of changes in one patch. This patch is
a nop - so no functional changes except the name change.

Let me annotate the git tree to mention this.

> >  		mid_mfn_mfn = virt_to_mfn(mid_mfn);
> > -		if (cmpxchg(top_mfn_p, missing_mfn, mid_mfn_mfn) != missing_mfn)
> > +		if (cmpxchg(top_mfn_p, identity_mfn, mid_mfn_mfn) !=
> > +		    identity_mfn)
> 
> Don't wrap this.

Checkpatch.pl was unhappy without it. I can ignore this.
