Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757875Ab1KKNtj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 08:49:39 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:40516 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752678Ab1KKNti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 08:49:38 -0500
Subject: Re: [PATCH v3] x86, efi: Calling __pa() with an ioremap'd address
 is invalid
From: Matt Fleming <matt@console-pimps.org>
To: huang ying <huang.ying.caritas@gmail.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Zhang Rui <rui.zhang@intel.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1321017132.3572.196.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1320680088-2584-1-git-send-email-matt@console-pimps.org>
	 <20111107202324.GA27515@srcf.ucam.org>
	 <CAC=cRTP5JxuYD2sU+cHi8yso68WTQREOboeQaeOPdqNMYorPkw@mail.gmail.com>
	 <1321017132.3572.196.camel@mfleming-mobl1.ger.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 11 Nov 2011 13:49:35 +0000
Message-ID: <1321019375.3572.200.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-11-11 at 13:12 +0000, Matt Fleming wrote:
> On Fri, 2011-11-11 at 09:02 +0800, huang ying wrote:
> > On Tue, Nov 8, 2011 at 4:23 AM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > > On Mon, Nov 07, 2011 at 03:34:48PM +0000, Matt Fleming wrote:
> > >
> > >> After the feedback from v1 I tried to unify the efi_ioremap()
> > >> implementations but ran into the issue detailed in the RH bug report
> > >> in the changelog. Unless we teach the x86 setup code that
> > >> EFI_RUNTIME_SERVICES_DATA regions should be part of the direct kernel
> > >> mapping table (even though they're marked as E820_RESERVED) I think
> > >> this patch makes the most sense.
> > >
> > > Honestly it seems like there may well be an argument for that. We're
> > > talking about executable code that the kernel will be calling - it seems
> > > theoretically neater for it to be added to the direct mapping. We're
> > > just heavily constrained by our collapsing of the EFI memory map onto
> > > the rather less fine-grained E820 one and the lack of any obvious way to
> > > extend that in an OS-specific manner. I guess we could expect the
> > > bootloader to conform to the standard and then re-walk the EFI memory
> > > map ourselves to fix things up, but eww...
> > 
> > Sorry for late.
> > 
> > Why ioremap_cache() can not work for some EFI_RUNTIME_SERVICES_DATA region?
> 
> It looks like ioremap_cache() maps the region with the NX bit set.

Sorry, ignore this nonsensical answer, obviously we shouldn't be
executing data.

Honestly, I'm not sure why it doesn't work.

-- 
Matt Fleming, Intel Open Source Technology Center

