Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755014Ab1DLTUZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 15:20:25 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:51639 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754587Ab1DLTUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 15:20:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xv1LiEcKERAP0Qe0fyt9H5p1Wz77jzgVqA75q/oHMB2s5PgKo4w1QWxSTGxxEcjrp2
         CVv4Wh+IBKFBda1kZiWCckCIXsploCsS4wNxa/S7mhQMCdoK7wJvVIJEGNckFunixKp0
         wUlEbukBkpHCA3d1MWph59ntQNwiQ1I8eko74=
Date: Wed, 13 Apr 2011 04:20:14 +0900
From: Tejun Heo <tj@kernel.org>
To: Richard Weinberger <richard@nod.at>
Cc: Christoph Lameter <cl@linux.com>, linux-kernel@vger.kernel.org,
        user-mode-linux-devel@lists.sourceforge.net, penberg@kernel.org,
        hpa@zytor.com
Subject: Re: um: this_cpu_cmpxchg16b_emu
Message-ID: <20110412192014.GF16342@mtj.dyndns.org>
References: <201104121609.56901.richard@nod.at>
 <alpine.DEB.2.00.1104121309480.14692@router.home>
 <201104122041.11460.richard@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201104122041.11460.richard@nod.at>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 12, 2011 at 08:41:11PM +0200, Richard Weinberger wrote:
> Am Dienstag 12 April 2011, 20:10:37 schrieb Christoph Lameter:
> > On Tue, 12 Apr 2011, Richard Weinberger wrote:
> > > This patch implements this_cpu_cmpxchg16b_emu() for UML.
> > 
> > Is this really necessary? Just undefine CONFIG_CMPXCHG_LOCAL for UML and
> > the asm code will not be used.
> 
> UML includes arch/x86/Kconfig.cpu which defines CONFIG_CMPXCHG_LOCAL automatically.
> Just disabling CONFIG_CMPXCHG_LOCAL for UML is IMHO not very nice.
> When chpxchg is available also UML should use it...

Ugh... I'd really like to avoid things like this for UML.  Is there
any SLUB performance sensitive workload running on UML?  I've never
seen any UML in production environment.  Wouldn't it be better to keep
things simple?

Thanks.

-- 
tejun
