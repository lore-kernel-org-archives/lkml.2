Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752445Ab2KECjb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 21:39:31 -0500
Received: from mga01.intel.com ([192.55.52.88]:38324 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406Ab2KECja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 21:39:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,712,1344236400"; 
   d="scan'208";a="242512314"
Message-ID: <509726D0.4010606@zytor.com>
Date: Mon, 05 Nov 2012 03:39:12 +0100
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
Subject: Re: [PATCH] crash dump: don't delete non-E820_RAM during init
References: <88DC34334CA3444C85D647DBFA962C270FD7EAD3@SHSMSX102.ccr.corp.intel.com> <50909120.3040101@zytor.com> <88DC34334CA3444C85D647DBFA962C270FD7EB0B@SHSMSX102.ccr.corp.intel.com> <5090AB3C.5050405@zytor.com> <88DC34334CA3444C85D647DBFA962C270FD7EB3A@SHSMSX102.ccr.corp.intel.com> <5090B966.4040605@zytor.com> <88DC34334CA3444C85D647DBFA962C270FD7EF68@SHSMSX102.ccr.corp.intel.com> <c6a025f9-0ac5-45d7-bda9-7f9bc8eaf9ab@email.android.com> <88DC34334CA3444C85D647DBFA962C270FD7F039@SHSMSX102.ccr.corp.intel.com> <5093F6DA.7040709@zytor.com> <88DC34334CA3444C85D647DBFA962C270FD7F4B6@SHSMSX102.ccr.corp.intel.com>
In-Reply-To: <88DC34334CA3444C85D647DBFA962C270FD7F4B6@SHSMSX102.ccr.corp.intel.com>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2012 02:37 AM, Zhang, Jun wrote:
> Hello, Gortmaker
> I will modify my subject. Thanks!
> 
> Hello, Anvin
> from our three options, I think third option is better. But in 3) option, there are two choose, 3.1) is like memmap=REMOVERAM, 3.2) is memmap=CRASHKDUMP.
> In 3.1) we maybe need ifdef/endif within the { } of the function (like exactmap).
> In 3.2) we can remove the ifdef/endif. 
> Which one is the better? Maybe you have a better solution, please share it. 
> Thanks!
> 
> Next is our three option.
> 1)  my patch.
> 2)  modify kexec, only pass two parameters -- memmap=544K@64K 
>     memmap=64964K@32768K, in kernel setup_memory_map, we can remove RAM 
>     range.
> 3)  add extra optional, 3.1) like memmap=REMOVERAM
>                    3.2) like memmap=CRASHKDUMP
> 

Again, 2 would be better because it is a localized change to kexec.  If
that works I don't see why there is any reason to change anything else.

	-hpa


