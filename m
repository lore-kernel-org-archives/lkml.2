Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531Ab1KHL2D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 06:28:03 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:50073 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755028Ab1KHL2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 06:28:00 -0500
Subject: Re: [PATCH] x86, efi: Convert efi_phys_get_time() args to physical
 addresses
From: Matt Fleming <matt@console-pimps.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        x86@kernel.org, Zhang Rui <rui.zhang@intel.com>,
        "Ma, Maurice" <maurice.ma@intel.com>
In-Reply-To: <4EB82CA9.5080703@zytor.com>
References: <1318330333-4617-1-git-send-email-matt@console-pimps.org>
	 <1320665471.3572.110.camel@mfleming-mobl1.ger.corp.intel.com>
	 <4EB82CA9.5080703@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Nov 2011 11:27:53 +0000
Message-ID: <1320751673.3572.128.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-07 at 11:08 -0800, H. Peter Anvin wrote:
> On 11/07/2011 03:31 AM, Matt Fleming wrote:
> > 
> > Ping?
> > 
> 
> Is this -stable material?

I don't think so. It only affects things early in boot (before
efi_enter_virtual_mode()) is called. Once we've called
SetVirtualAddressMap() we call virt_efi_get_time() to get the time and
everything works fine.

I don't think this bug is even visible to the user apart from the "Oops:
efitime: can't read time!" message displayed on boot. It certainly
doesn't cause a crash or anything like that.

-- 
Matt Fleming, Intel Open Source Technology Center

