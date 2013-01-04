Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163Ab3ADQWe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 11:22:34 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:43578 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755099Ab3ADQWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 11:22:33 -0500
X-Greylist: delayed 415 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Jan 2013 11:22:32 EST
Message-ID: <1357316128.8203.33.camel@mfleming-mobl1.ger.corp.intel.com>
Subject: Re: [RFC PATCH 1/2] efi: Make 'efi_enabled' a function to query EFI
 facilities
From: Matt Fleming <matt@console-pimps.org>
To: Tim Gardner <rtg.canonical@gmail.com>
Cc: Steve Langasek <steve.langasek@canonical.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Olof Johansson <olof@lixom.net>, Tony Luck <tony.luck@intel.com>,
        David Airlie <airlied@linux.ie>,
        Corentin Chary <corentincj@iksaif.net>,
        Dave Jiang <dave.jiang@intel.com>, Peter Jones <pjones@redhat.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, tim.gardner@canonical.com
Date: Fri, 04 Jan 2013 16:15:28 +0000
In-Reply-To: <50E6F086.5020209@gmail.com>
References: <1357219085-4312-1-git-send-email-matt@console-pimps.org>
	 <1357219085-4312-2-git-send-email-matt@console-pimps.org>
	 <50E6F086.5020209@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-01-04 at 08:08 -0700, Tim Gardner wrote:
> On 01/03/2013 06:18 AM, Matt Fleming wrote:
> > From: Matt Fleming <matt.fleming@intel.com>
> > 
> 
> snip
> 
> >  /*
> > - * We play games with efi_enabled so that the compiler will, if possible, remove
> > - * EFI-related code altogether.
> > + * We play games with efi_enabled so that the compiler will, if
> > + * possible, remove EFI-related code altogether.
> >   */
> > +#define EFI_BOOT		0x00000001 /* Were we booted from EFI? */
> > +#define EFI_SYSTEM_TABLES	0x00000002 /* Can we use EFI system tables? */
> > +#define EFI_CONFIG_TABLES	0x00000004 /* Can we use EFI config tables? */
> > +#define EFI_RUNTIME_SERVICES	0x00000004 /* Can we use runtime services? */
> > +#define EFI_MEMMAP		0x00000008 /* Can we use EFI memory map? */
> > +#define EFI_64BIT		0x00000010 /* Is the firmware 64-bit? */
> > +
> 
> Your use of test_bit() and set_bit() imply that these macros should be
> bit numbers, not bit masks. It'll work until you define a mask with an
> integer value greater then 31.

They're not intended to be bitmasks in the sense that no two bits are
set in each constant (and I am aware of the upper limit).

I have no problem changing the above values to bit numbers if that would
be less confusing.

-- 
Matt Fleming, Intel Open Source Technology Center

