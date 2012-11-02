Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760482Ab2KBQiE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 12:38:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60964 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759926Ab2KBQiC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 12:38:02 -0400
Message-ID: <5093F6DA.7040709@zytor.com>
Date: Fri, 02 Nov 2012 09:37:46 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: "Zhang, Jun" <jun.zhang@intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Fleming, Matt" <matt.fleming@intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] To crash dump, we need keep other memory type except
 E820_RAM, because other type come from BIOS or firmware is used by other
 code(for example: PCI_MMCONFIG).
References: <88DC34334CA3444C85D647DBFA962C270FD7EAD3@SHSMSX102.ccr.corp.intel.com> <50909120.3040101@zytor.com> <88DC34334CA3444C85D647DBFA962C270FD7EB0B@SHSMSX102.ccr.corp.intel.com> <5090AB3C.5050405@zytor.com> <88DC34334CA3444C85D647DBFA962C270FD7EB3A@SHSMSX102.ccr.corp.intel.com> <5090B966.4040605@zytor.com> <88DC34334CA3444C85D647DBFA962C270FD7EF68@SHSMSX102.ccr.corp.intel.com> <c6a025f9-0ac5-45d7-bda9-7f9bc8eaf9ab@email.android.com> <88DC34334CA3444C85D647DBFA962C270FD7F039@SHSMSX102.ccr.corp.intel.com>
In-Reply-To: <88DC34334CA3444C85D647DBFA962C270FD7F039@SHSMSX102.ccr.corp.intel.com>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/2012 01:49 AM, Zhang, Jun wrote:
> Hello, Anvin
> 
> Thank for your advice.
> 
> Hello, All
> 
> the next patch is made by 2), please review it. Thanks!
> 

No, it is not.

You are still modifying the behavior of the kernel depending on
CONFIG_CRASH_DUMP.

CONFIG_CRASH_DUMP doesn't mean "we are doing a crash dump".  It means
"it is possible to use this kernel to do a crash dump".

Either you are using standard kernel parameters in a standard way which
is what option 2 was supposed to be -- it should require no kernel
changes! -- or you have to put something in a code path specific to a
crash dump.

	-hpa

