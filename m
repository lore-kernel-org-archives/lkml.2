Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727Ab0H3N3J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 09:29:09 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:52328 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536Ab0H3N3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 09:29:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DVV8JNHz91H3zSaKq9UMINnUOn8z79/p/Vc8zNwLGxKHrmOwn3jEYh0zSkUdx5+r/b
         YOFn8N54poCZYqQei1D9f61CfDyTrMLj/IFyjrByo4DX9M4fONMH47MEbdkBbf8+HmwX
         GBKhNpmQFClAMrisKwwp7SsUeElwl7VxEHuyA=
Date: Mon, 30 Aug 2010 15:59:45 +0200
From: Andreas Herrmann <herrmann.der.user@googlemail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, k8-gart: Decouple handling of garts and
 northbridges
Message-ID: <20100830135945.GA4749@loge.amd.com>
References: <20100827075945.GA5348@loge.amd.com>
 <4C77F164.8000100@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C77F164.8000100@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 27, 2010 at 10:09:56AM -0700, H. Peter Anvin wrote:
> On 08/27/2010 12:59 AM, Andreas Herrmann wrote:
> > From: Andreas Herrmann <andreas.herrmann3@amd.com>
> > 
> > So far we only provide num_k8_northbridges. This is required in
> > different areas (e.g. L3 cache index disable, GART). But not all AMD
> > CPUs provide a GART. Thus it is useful to split off the GART handling
> > from the generic caching of AMD northbridge misc devices.
> > 
> > Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
> > ---
> >  arch/x86/include/asm/k8.h             |   13 +++++---
> >  arch/x86/kernel/cpu/intel_cacheinfo.c |    4 +-
> >  arch/x86/kernel/k8.c                  |   52 +++++++++++++++++++--------------
> >  arch/x86/kernel/pci-gart_64.c         |   27 +++++++++++------
> >  drivers/char/agp/amd64-agp.c          |   33 ++++++++++++++------
> >  drivers/edac/amd64_edac.c             |    2 +-
> >  6 files changed, 82 insertions(+), 49 deletions(-)
> > 
> > 
> > Please apply.
> > 
> 
> From just looking at it: isn't this patch going to break compiling with
> CONFIG_K8_NB=n?

Good catch.

Compiled for me after deselecting CONFIG_CPU_SUP_AMD but deselecting
PCI breaks compilation of the L3 cache index disable code. But that
stuff requires PCI support.

Will send updated patch(es) to fix this.


Thanks,

Andreas

