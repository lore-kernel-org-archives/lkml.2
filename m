Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542Ab1LUUMv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 15:12:51 -0500
Received: from mga09.intel.com ([134.134.136.24]:30975 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751418Ab1LUUMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 15:12:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="90116933"
Date: Wed, 21 Dec 2011 12:12:27 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Thomas Renninger <trenn@suse.de>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        hpa@zytor.com, kay.sievers@vrf.org, davej@redhat.com,
        kay.sievers@vrfy.org
Subject: Re: [PATCH 7/8] cpufreq: Add support for x86 cpuinfo auto loading
 v3
Message-ID: <20111221201227.GA9262@alboin.amr.corp.intel.com>
References: <1324338394-4670-1-git-send-email-andi@firstfloor.org>
 <1324338394-4670-8-git-send-email-andi@firstfloor.org>
 <201112211203.26153.trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201112211203.26153.trenn@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +static const struct x86_cpu_id powernow_k8_ids[] = {
> > +	{ X86_VENDOR_AMD, 0xf, },
> > +	{ X86_VENDOR_AMD, 0x10, },
> > +	{ X86_VENDOR_AMD, 0x11, },
> > +	{ X86_VENDOR_AMD, 0x12, },
> > +	{ X86_VENDOR_AMD, 0x13, },
> > +	{ X86_VENDOR_AMD, 0x14, },
> { X86_VENDOR_AMD, 0x15, },
> 
> Should also have BullDozer family included.

I think it really needs a cpuid feature bit for the hwpstate.  This is
not in one of the normal CPUID leaves, so the amd specific CPU init
code would need to set it.

I added 0x15 for now, but it would be good if someone with the hardware
fixed it like this.

Then could just add a match on "AMD-hw pstate" or so.

-Andi
