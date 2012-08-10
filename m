Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310Ab2HJTWQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 15:22:16 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:51421 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932Ab2HJTWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 15:22:13 -0400
MIME-Version: 1.0
In-Reply-To: <1344502295.9195.7.camel@mfleming-mobl1.ger.corp.intel.com>
References: <20120805172903.5f8bb24c@zougloub.eu>
	<501EF3A2.20200@zytor.com>
	<501F83F20200007800092C1C@nat28.tlf.novell.com>
	<20120806125216.GA11863@srcf.ucam.org>
	<501FDDD30200007800092DDE@nat28.tlf.novell.com>
	<20120806091627.2ad5ed2e@zougloub.eu>
	<20120806223208.5301be0d@zougloub.eu>
	<20120806230629.153d33bd@zougloub.eu>
	<5020DC5F02000078000931C2@nat28.tlf.novell.com>
	<1344331830.7208.6.camel@mfleming-mobl1.ger.corp.intel.com>
	<50210F0702000078000932EB@nat28.tlf.novell.com>
	<1344502295.9195.7.camel@mfleming-mobl1.ger.corp.intel.com>
Date: Fri, 10 Aug 2012 12:22:12 -0700
X-Google-Sender-Auth: ffh7kZZcBlC9946gZMtVRIDvB6A
Message-ID: <CAE9FiQUuQAEzin2uXRXWhMXAviu8MXLDkfjFbFJMWB4xkKimFA@mail.gmail.com>
Subject: Re: [Regression] "x86-64/efi: Use EFI to deal with platform wall
 clock" prevents my machine from booting
From: Yinghai Lu <yinghai@kernel.org>
To: Matt Fleming <matt.fleming@intel.com>
Cc: Jan Beulich <JBeulich@suse.com>, Ingo Molnar <mingo@kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, cJ-ko@zougloub.eu,
        "H. PeterAnvin" <hpa@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 9, 2012 at 1:51 AM, Matt Fleming <matt.fleming@intel.com> wrote:
> On Tue, 2012-08-07 at 11:50 +0100, Jan Beulich wrote:
>> >
>> > I managed to find a machine to reproduce this on and it looks like the
>> > ASUS firmware engineers are upto their old tricks of referencing
>> > physical addresses after we've taken control of the memory map,
>>
>> Yippie. On such systems we simply can't do any runtime calls.
>> Should we add a command line option forcing efi_native to false,
>> thus suppressing all runtime calls? Or would the "noefi" one be
>> enough already?
>
> I think a better solution for this, seeing as there appear to be *so*
> many ASUS machines in the wild with this inability to do virtual EFI
> calls, is to provide a 1:1 mapping as well as our regular virt->phys
> mapping for the benefit of the firmware. We can load our special page
> table in efi_call_*, etc.
>
> One thing to note is that because of breakage seen on Apple machines
> last time Matthew tried this approach, we (the kernel) can't actually
> access the 1:1 mapping, it would exist purely for the benefit of
> firmware that was broken enough to reference physical addresses after
> SetVirtualAddressMap().
>

What is solution for this regression?

It seems Jan's commit broke our setup with UEFI too.

Assume other systems with AMI code base would have same problem.

Thanks

Yinghai
