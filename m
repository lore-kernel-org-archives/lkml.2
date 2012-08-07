Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591Ab2HGKuV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 06:50:21 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:46342 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113Ab2HGKuU convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:2>);
	Tue, 7 Aug 2012 06:50:20 -0400
Message-Id: <50210F0702000078000932EB@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Tue, 07 Aug 2012 11:50:15 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Matt Fleming" <matt.fleming@intel.com>
Cc: "Ingo Molnar" <mingo@kernel.org>, "Matthew Garrett" <mjg59@srcf.ucam.org>,
        <linux-efi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <cJ-ko@zougloub.eu>, "H. PeterAnvin" <hpa@zytor.com>
Subject: Re: [Regression] "x86-64/efi: Use EFI to deal with platform
 wall clock" prevents my machine from booting
References: <20120805172903.5f8bb24c@zougloub.eu>
 <501EF3A2.20200@zytor.com> <501F83F20200007800092C1C@nat28.tlf.novell.com>
 <20120806125216.GA11863@srcf.ucam.org>
 <501FDDD30200007800092DDE@nat28.tlf.novell.com>
 <20120806091627.2ad5ed2e@zougloub.eu>
 <20120806223208.5301be0d@zougloub.eu>
 <20120806230629.153d33bd@zougloub.eu>
 <5020DC5F02000078000931C2@nat28.tlf.novell.com>
 <1344331830.7208.6.camel@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <1344331830.7208.6.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 07.08.12 at 11:30, Matt Fleming <matt.fleming@intel.com> wrote:
> On Tue, 2012-08-07 at 08:14 +0100, Jan Beulich wrote:
>> That's not surprising. The question really is what goes wrong
>> when the call is being made - page fault, some other fault, or
>> silent hang. A page fault would point to an incorrect memory
>> map as the prime candidate for causing the problem. My
>> primary suspect would be #NM, i.e. the implementation using
>> floating point (SSE to be precise) instructions when they're
>> unavailable.
> 
> I managed to find a machine to reproduce this on and it looks like the
> ASUS firmware engineers are upto their old tricks of referencing
> physical addresses after we've taken control of the memory map,

Yippie. On such systems we simply can't do any runtime calls.
Should we add a command line option forcing efi_native to false,
thus suppressing all runtime calls? Or would the "noefi" one be
enough already?

Jan

