Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756929Ab2HIIvw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 04:51:52 -0400
Received: from mga09.intel.com ([134.134.136.24]:33216 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756841Ab2HIIvs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 04:51:48 -0400
Subject: Re: [Regression] "x86-64/efi: Use EFI to deal with platform wall
 clock" prevents my machine from booting
From: Matt Fleming <matt.fleming@intel.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: Ingo Molnar <mingo@kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        cJ-ko@zougloub.eu, "H. PeterAnvin" <hpa@zytor.com>
In-Reply-To: <50210F0702000078000932EB@nat28.tlf.novell.com>
References: <20120805172903.5f8bb24c@zougloub.eu> <501EF3A2.20200@zytor.com>
	 <501F83F20200007800092C1C@nat28.tlf.novell.com>
	 <20120806125216.GA11863@srcf.ucam.org>
	 <501FDDD30200007800092DDE@nat28.tlf.novell.com>
	 <20120806091627.2ad5ed2e@zougloub.eu> <20120806223208.5301be0d@zougloub.eu>
	 <20120806230629.153d33bd@zougloub.eu>
	 <5020DC5F02000078000931C2@nat28.tlf.novell.com>
	 <1344331830.7208.6.camel@mfleming-mobl1.ger.corp.intel.com>
	 <50210F0702000078000932EB@nat28.tlf.novell.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Date: Thu, 09 Aug 2012 09:51:35 +0100
Message-ID: <1344502295.9195.7.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-08-07 at 11:50 +0100, Jan Beulich wrote:
> > 
> > I managed to find a machine to reproduce this on and it looks like the
> > ASUS firmware engineers are upto their old tricks of referencing
> > physical addresses after we've taken control of the memory map,
> 
> Yippie. On such systems we simply can't do any runtime calls.
> Should we add a command line option forcing efi_native to false,
> thus suppressing all runtime calls? Or would the "noefi" one be
> enough already?

I think a better solution for this, seeing as there appear to be *so*
many ASUS machines in the wild with this inability to do virtual EFI
calls, is to provide a 1:1 mapping as well as our regular virt->phys
mapping for the benefit of the firmware. We can load our special page
table in efi_call_*, etc.

One thing to note is that because of breakage seen on Apple machines
last time Matthew tried this approach, we (the kernel) can't actually
access the 1:1 mapping, it would exist purely for the benefit of
firmware that was broken enough to reference physical addresses after
SetVirtualAddressMap().

