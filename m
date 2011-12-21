Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861Ab1LUVaZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 16:30:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49160 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752454Ab1LUVaW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 16:30:22 -0500
Date: Wed, 21 Dec 2011 16:30:10 -0500
From: Dave Jones <davej@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <ak@linux.intel.com>, Thomas Renninger <trenn@suse.de>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        kay.sievers@vrf.org, kay.sievers@vrfy.org
Subject: Re: [PATCH 7/8] cpufreq: Add support for x86 cpuinfo auto loading v3
Message-ID: <20111221213009.GA2568@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>,
	Thomas Renninger <trenn@suse.de>, Andi Kleen <andi@firstfloor.org>,
	linux-kernel@vger.kernel.org, kay.sievers@vrf.org,
	kay.sievers@vrfy.org
References: <1324338394-4670-1-git-send-email-andi@firstfloor.org>
 <1324338394-4670-8-git-send-email-andi@firstfloor.org>
 <201112211203.26153.trenn@suse.de>
 <20111221201227.GA9262@alboin.amr.corp.intel.com>
 <4EF23E41.40608@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EF23E41.40608@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 21, 2011 at 12:14:57PM -0800, H. Peter Anvin wrote:
 > On 12/21/2011 12:12 PM, Andi Kleen wrote:
 > >>> +static const struct x86_cpu_id powernow_k8_ids[] = {
 > >>> +	{ X86_VENDOR_AMD, 0xf, },
 > >>> +	{ X86_VENDOR_AMD, 0x10, },
 > >>> +	{ X86_VENDOR_AMD, 0x11, },
 > >>> +	{ X86_VENDOR_AMD, 0x12, },
 > >>> +	{ X86_VENDOR_AMD, 0x13, },
 > >>> +	{ X86_VENDOR_AMD, 0x14, },
 > >> { X86_VENDOR_AMD, 0x15, },
 > >>
 > >> Should also have BullDozer family included.
 > > 
 > > I think it really needs a cpuid feature bit for the hwpstate.  This is
 > > not in one of the normal CPUID leaves, so the amd specific CPU init
 > > code would need to set it.
 > > 
 > > I added 0x15 for now, but it would be good if someone with the hardware
 > > fixed it like this.
 > > 
 > > Then could just add a match on "AMD-hw pstate" or so.
 > > 
 > 
 > Agreed.  This is literally screaming for a synthetic CPUID bit.

A synthetic one is pointless, because you'd just be duplicating something
similar to the above in generic code that would need updating for every new stepping.

If anything other than powernow-k8 cared, there might be a more
compelling argument, but I don't see the point in moving something that
only this driver cares about to common code.

	Dave

