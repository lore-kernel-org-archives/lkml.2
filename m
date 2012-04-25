Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758928Ab2DYUga (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 16:36:30 -0400
Received: from mga01.intel.com ([192.55.52.88]:64157 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758800Ab2DYUg2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 16:36:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="158345938"
From: "Moore, Robert" <robert.moore@intel.com>
To: "sedat.dilek@gmail.com" <sedat.dilek@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>
CC: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Lin, Ming M" <ming.m.lin@intel.com>
Subject: RE: Warning: pnp 00:0b: can't evaluate _CRS: 12311
Thread-Topic: Warning: pnp 00:0b: can't evaluate _CRS: 12311
Thread-Index: AQHNITY8ggyhHlhlsU+L3vOq3I8c0JaoxPuAgACoCICAAAZTgIACkBZQ
Date: Wed, 25 Apr 2012 20:36:14 +0000
Message-ID: <94F2FBAB4432B54E8AACC7DFDE6C92E346A77806@ORSMSX101.amr.corp.intel.com>
References: <CA+icZUWVwUr19xL0Dn5mHnZjQaVjj6VYD3BMMktEWO0vgoZEXw@mail.gmail.com>
	<CA+icZUUGFaz0c-tHa9EGUxZaxPj_M=zrE+kE0dv5UMoA6GyN3w@mail.gmail.com>
	<CAErSpo5vZSf_EZr6-XnAA8N2Luv6rA92YtZsidWZCZ8rarkPUQ@mail.gmail.com>
 <CA+icZUU+asnLWAevwqKBgnvrmKNitL8-0+8ijDii4pt9VsjspA@mail.gmail.com>
In-Reply-To: <CA+icZUU+asnLWAevwqKBgnvrmKNitL8-0+8ijDii4pt9VsjspA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q3PKaepF009432

> >>> [    0.294037] pnp 00:0b: can't evaluate _CRS: 12311

It sure would be nice if this error message would include the full pathname to the _CRS method. As it stands, it is rather difficult to determine just what caused this.


> -----Original Message-----
> From: Sedat Dilek [mailto:sedat.dilek@googlemail.com]
> Sent: Monday, April 23, 2012 3:27 PM
> To: Bjorn Helgaas
> Cc: linux-acpi@vger.kernel.org; Len Brown; linux-
> kernel@vger.kernel.org; Moore, Robert; Lin, Ming M
> Subject: Re: Warning: pnp 00:0b: can't evaluate _CRS: 12311
> 
> On Tue, Apr 24, 2012 at 12:04 AM, Bjorn Helgaas <bhelgaas@google.com>
> wrote:
> > On Mon, Apr 23, 2012 at 6:03 AM, Sedat Dilek
> <sedat.dilek@googlemail.com> wrote:
> >> On Mon, Apr 23, 2012 at 11:48 AM, Sedat Dilek
> >> <sedat.dilek@googlemail.com> wrote:
> >>> [ Please CC me I am not subscribed to this ML ]
> >>>
> >>> Hi,
> >>>
> >>> with a self-compiled linux-3.4-rc4 I am seeing this
> bugs/failures/warnings:
> >>>
> >>> [ Â  Â 0.241572] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
> >>>
> >>> [ Â  Â 0.279385] Â pci0000:00: ACPI _OSC request failed (AE_ERROR),
> >>> returned control mask: 0x1d
> >>>
> >>> [ Â  Â 0.293699] system 00:0a: Plug and Play ACPI device, IDs PNP0c02
> >>> (active) [ Â  Â 0.294032] ACPI Error: Invalid/unsupported resource
> descriptor:
> >>> Type 0x00 (20120320/utresrc-650)
> >>> [ Â  Â 0.294037] pnp 00:0b: can't evaluate _CRS: 12311
> >>>
> >>> The same outputs I have seen also with an unsupported drm-intel-
> next
> >>> kernel from Ubuntu/PPA archives [1].
> >>>
> >>> What does ist mean? Is it harmless? Buggy firmware/bios?
> >>>
> >>> Do you need more background infos (dmesg, kernel-config, etc.)?
> >>>
> >>> Regards,
> >>> - Sedat -
> >>>
> >>> [1]
> >>> http://kernel.ubuntu.com/~kernel-ppa/mainline/drm-intel-
> next/current
> >>> /
> >>
> >> I have upgraded this Samsung series-5 notebook from BIOS version
> 05XK
> >> to 06XK, but the pnp/_CRS warning still remains.
> >
> > Resource type 0 is "reserved" per the ACPI spec, so this is likely a
> > BIOS defect. Â However, we might be able to handle it better than we
> > currently do.
> >
> > I would expect all versions of Linux would report this error -- can
> > you confirm that or identify a version that didn't complain? Â Also,
> > can you collect an acpidump (see
> > http://www.lesswatts.org/projects/acpi/utilities.php)?
> >
> > In acpi_ut_validate_resource(), we return
> AE_AML_INVALID_RESOURCE_TYPE
> > (0x3017 == 12311), which explains the messages you see. Â The comments
> > in acpi_ut_walk_aml_resources() suggest that we can't continue
> because
> > the length may be bogus if the type is invalid. Â But I suspect that
> if
> > we just treat it as a zero-length descriptor and ignore it, things
> > will probably work, and that's likely what Windows does.
> >
> > Bjorn
> 
> [ Removed Adam Belay <abelay@mit.edu> (email-address does not exist
> anymore) ]
> 
> Yeah, I asked today on #ubuntu-kernel and people there were very
> helpful and gave some good explanations (AE_AML_INVALID_RESOURCE_TYPE
> etc.).
> 
> The acpidump.log I pastebin-ed today, so here it is :-).
> 
> The kernel shipped with Ubuntu/precise does not show the pnp/_CSR
> issue, this is linux-image-3.2.0-23-generic (3.2.0-23.36).
> 
> Hope this helps.
> 
> - Sedat -
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
