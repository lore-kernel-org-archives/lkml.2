Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757013Ab0HQHFZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 03:05:25 -0400
Received: from mail.skyhub.de ([78.46.96.112]:34467 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756825Ab0HQHFY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 03:05:24 -0400
Date: Tue, 17 Aug 2010 09:05:20 +0200
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: akataria@vmware.com, the arch/x86 maintainers <x86@kernel.org>,
        Greg KH <gregkh@suse.de>, "greg@kroah.com" <greg@kroah.com>,
        "ksrinivasan@novell.com" <ksrinivasan@novell.com>,
        LKML <linux-kernel@vger.kernel.org>, borislav.petkov@amd.com
Subject: Re: [Patch] Skip cpu_calibrate for kernel running under
 hypervisors.
Message-ID: <20100817070520.GD32714@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>, akataria@vmware.com,
	the arch/x86 maintainers <x86@kernel.org>, Greg KH <gregkh@suse.de>,
	"greg@kroah.com" <greg@kroah.com>,
	"ksrinivasan@novell.com" <ksrinivasan@novell.com>,
	LKML <linux-kernel@vger.kernel.org>, borislav.petkov@amd.com
References: <1281986754.23253.32.camel@ank32.eng.vmware.com>
 <4C69D02F.6090601@zytor.com>
 <1282024311.20786.2.camel@ank32.eng.vmware.com>
 <4C6A2C98.4060605@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4C6A2C98.4060605@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, Aug 16, 2010 at 11:30:48PM -0700

> On 08/16/2010 10:51 PM, Alok Kataria wrote:
> >>
> >> I'm somewhat reluctant to take this one, since it assumes all the
> >> hypervisors act the same.  This seems rather inherently wrong.  In fact,
> >> the whole statement is fishy as heck... instead of being dependent on
> >> AMD and so on, 
> > 
> > The check about being on AMD is something that was already there. 
> > 
> 
> I know it was... and calibrate_cpu() seems to be an AMD-specific
> function, but that's rather crappy.  I'm thinking that perhaps we should
> make it an x86_init function, then the AMD CPU detection can install it
> and the vmware hypervisor detection can uninstall it.

Btw, can we revisit this AMD-specific issue? IIUC, Alok you're seeing
a mismatch between the calibrated TSC value and the cpu frequency even
on cpus which have the CONSTANT_TSC bit set, i.e. their TSC is counting
with P0 frequency. Can you please elaborate more on what systems you're
seeing this (cpu family, chipset, etc)?

Thanks.

-- 
Regards/Gruss,
    Boris.
