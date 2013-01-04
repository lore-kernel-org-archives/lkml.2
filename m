Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147Ab3ADQSh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 11:18:37 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48645 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754899Ab3ADQSf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 11:18:35 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <1357316128.8203.33.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1357219085-4312-1-git-send-email-matt@console-pimps.org> <1357219085-4312-2-git-send-email-matt@console-pimps.org> <50E6F086.5020209@gmail.com> <1357316128.8203.33.camel@mfleming-mobl1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [RFC PATCH 1/2] efi: Make 'efi_enabled' a function to query EFI facilities
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Fri, 04 Jan 2013 08:17:51 -0800
To: Matt Fleming <matt@console-pimps.org>,
        Tim Gardner <rtg.canonical@gmail.com>
CC: Steve Langasek <steve.langasek@canonical.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        Tony Luck <tony.luck@intel.com>, David Airlie <airlied@linux.ie>,
        Corentin Chary <corentincj@iksaif.net>,
        Dave Jiang <dave.jiang@intel.com>, Peter Jones <pjones@redhat.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, tim.gardner@canonical.com
Message-ID: <0adaa194-413d-497e-aecf-3ac7c16c9134@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well, *I* am confused as heck.  They look like bitmasks, we normally use decimal numbers for bit numbers as a matter of style.

Matt Fleming <matt@console-pimps.org> wrote:

>On Fri, 2013-01-04 at 08:08 -0700, Tim Gardner wrote:
>> On 01/03/2013 06:18 AM, Matt Fleming wrote:
>> > From: Matt Fleming <matt.fleming@intel.com>
>> > 
>> 
>> snip
>> 
>> >  /*
>> > - * We play games with efi_enabled so that the compiler will, if
>possible, remove
>> > - * EFI-related code altogether.
>> > + * We play games with efi_enabled so that the compiler will, if
>> > + * possible, remove EFI-related code altogether.
>> >   */
>> > +#define EFI_BOOT		0x00000001 /* Were we booted from EFI? */
>> > +#define EFI_SYSTEM_TABLES	0x00000002 /* Can we use EFI system
>tables? */
>> > +#define EFI_CONFIG_TABLES	0x00000004 /* Can we use EFI config
>tables? */
>> > +#define EFI_RUNTIME_SERVICES	0x00000004 /* Can we use runtime
>services? */
>> > +#define EFI_MEMMAP		0x00000008 /* Can we use EFI memory map? */
>> > +#define EFI_64BIT		0x00000010 /* Is the firmware 64-bit? */
>> > +
>> 
>> Your use of test_bit() and set_bit() imply that these macros should
>be
>> bit numbers, not bit masks. It'll work until you define a mask with
>an
>> integer value greater then 31.
>
>They're not intended to be bitmasks in the sense that no two bits are
>set in each constant (and I am aware of the upper limit).
>
>I have no problem changing the above values to bit numbers if that
>would
>be less confusing.

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
