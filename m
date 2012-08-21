Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598Ab2HUUFh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 16:05:37 -0400
Received: from mga11.intel.com ([192.55.52.93]:48892 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314Ab2HUUFc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 16:05:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,804,1336374000"; 
   d="scan'208";a="207768904"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: Borislav Petkov <bp@amd64.org>, "H. Peter Anvin" <hpa@zytor.com>
CC: Henrique de Moraes Holschuh <hmh@hmh.eng.br>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Subject: RE: [PATCH 04/11] x86/microcode_core_early.c: Define interfaces for
 early load ucode
Thread-Topic: [PATCH 04/11] x86/microcode_core_early.c: Define interfaces
 for early load ucode
Thread-Index: AQHNfRunwqP95+1vaUy4HYughHZSRZdgoT4A//+XQYCAANiLAIAARpuAgAHdegCAAGU7gIAAAxCAgAEVvBA=
Date: Tue, 21 Aug 2012 20:05:30 +0000
Message-ID: <3E5A0FA7E9CA944F9D5414FEC6C712200778846C@ORSMSX105.amr.corp.intel.com>
References: <1345277729-8399-1-git-send-email-fenghua.yu@intel.com>
 <1345277729-8399-5-git-send-email-fenghua.yu@intel.com>
 <20120818224442.GB32120@khazad-dum.debian.net>
 <3E5A0FA7E9CA944F9D5414FEC6C71220077879BF@ORSMSX105.amr.corp.intel.com>
 <503078A2.9030204@zytor.com>
 <3E5A0FA7E9CA944F9D5414FEC6C7122007787B22@ORSMSX105.amr.corp.intel.com>
 <20120820140630.GD24149@aftab.osrc.amd.com> <50329951.9030805@zytor.com>
 <20120820201947.GC15006@aftab.osrc.amd.com>
In-Reply-To: <20120820201947.GC15006@aftab.osrc.amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Borislav Petkov [mailto:bp@amd64.org]
> Sent: Monday, August 20, 2012 1:20 PM
> To: H. Peter Anvin
> Cc: Yu, Fenghua; Henrique de Moraes Holschuh; Ingo Molnar; Thomas
> Gleixner; Mallick, Asit K; Tigran Aivazian; Andreas Herrmann; Borislav
> Petkov; linux-kernel; x86
> Subject: Re: [PATCH 04/11] x86/microcode_core_early.c: Define
> interfaces for early load ucode
> 
> On Mon, Aug 20, 2012 at 01:08:49PM -0700, H. Peter Anvin wrote:
> > On 08/20/2012 07:06 AM, Borislav Petkov wrote:
> > >
> > > Or,
> > >
> > > in case we want to supply more vendor-specific stuff early at boot,
> we
> > > could do:
> > >
> > > kernel/x86/<vendor>/microcode...
> > > 		|-> bios_overrides
> > > 		|-> ...
> > >
> > > and have this layout extensible from the beginning...
> > >
> > Does that make sense, though?
> 
> Only time will tell. I was simply saying that we should leave ourselves
> the door opened, should we need functionality like that in the future.
> 
> > I'm a bit concerned about having multiple files named microcode.bin
> by
> > default; the pathname isn't as sticky as the filename when people
> move
> > things around...
> 
> Ok, I see.
> 
> How about the following scheme then:
> 
> kernel/x86/<vendor>-microcode.bin
> kernel/x86/<vendor>-bios-overrides.blob
> ...
> 
> ?
> 
> All I'm saying is maybe we should impose some sanity rules now before
> people go crazy with this and things get out of hands...

We might name the cpio directory as:

kernel/x86/microcode/GenuineIntel.bin
kernel/x86/microcode/AuthenticAMD.bin
kernel/x86/acpi/...
etc.

This is expendable for the future usage.
 
Plus I will add a doc on the cpio directory, supported directory names and how to add new stuffs in the directory.

Thanks.

-Fenghua


Thanks.

-Fenghua
