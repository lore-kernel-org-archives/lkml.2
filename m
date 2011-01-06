Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056Ab1AFJYt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 04:24:49 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42100 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319Ab1AFJYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 04:24:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=Q4VcGBeWnRNBEYLEjvmgrCn+lOFYhsyx9i5UY7UYNKpg5mTfCv/Zd8/1QQ4R7iU0ze
         n1N247dCYaNR4L65LCJbKsEnVHEPsavgzbLYDZO8aYH/3Nu8UAg6zb0KDqVxIIJIYptO
         VcB4EVwmGBP/IY/Uw/KhVNcAPn8v3n6Ok74Ws=
Message-ID: <4D258A55.2040003@gmail.com>
Date: Thu, 06 Jan 2011 10:24:37 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        "Brown, Len" <len.brown@intel.com>, steiner@sgi.com,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Len Brown <lenb@kernel.org>
Subject: Re: suspend hangs at platform phase [was: mmotm 2010-12-23-16-58
 uploaded]
References: <201012240132.oBO1W8Ub022207@imap1.linux-foundation.org> <201101052339.46453.rjw@sisk.pl> <4D24F4A9.8010301@gmail.com> <201101060028.43342.rjw@sisk.pl>
In-Reply-To: <201101060028.43342.rjw@sisk.pl>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2011 12:28 AM, Rafael J. Wysocki wrote:
> Two more questions:
> (1) Does the failing machine power off correctly with the kernel that fails to
>     suspend?

Poweroff is OK.

> (2) Is the failing suspend behavior reproducible if you run
>     "echo disk > /sys/power/state" instead of "pm-suspend" in the platform test?

Thanks for the hint no_console_suspend with hibernate shows somwthing
(opposing to suspend). I've sent a patch for the oops which occured due
to ioremap change. The ioremap change still needs to be reverted, obviously.

The oops in question:
http://www.fi.muni.cz/~xslaby/sklad/panics/suspend-oops.png

/proc/mtrr:
reg00: base=0x0b0000000 ( 2816MB), size=  256MB, count=1: uncachable
reg01: base=0x0c0000000 ( 3072MB), size= 1024MB, count=1: uncachable
reg02: base=0x000000000 (    0MB), size= 4096MB, count=1: write-back
reg03: base=0x100000000 ( 4096MB), size= 2048MB, count=1: write-back
reg04: base=0x180000000 ( 6144MB), size= 1024MB, count=1: write-back
reg05: base=0x1c0000000 ( 7168MB), size=  128MB, count=1: write-back
reg06: base=0x1c8000000 ( 7296MB), size=   64MB, count=1: write-back
reg07: base=0x0af600000 ( 2806MB), size=    2MB, count=1: uncachable

/debug/x86/pat_memtype_list:
PAT memtype list:
uncached-minus @ 0xaf5b0000-0xaf5b7000
uncached-minus @ 0xaf5be000-0xaf5c1000
uncached-minus @ 0xaf5be000-0xaf5c1000
uncached-minus @ 0xaf5be000-0xaf5bf000
uncached-minus @ 0xb0200000-0xb0201000
write-combining @ 0xd0000000-0xe0000000
write-combining @ 0xd0001000-0xd0021000
write-combining @ 0xd0030000-0xd0530000
uncached-minus @ 0xe0000000-0xf0000000
uncached-minus @ 0xfe6ff000-0xfe700000
uncached-minus @ 0xfe7e0000-0xfe800000
uncached-minus @ 0xfea00000-0xfea80000
uncached-minus @ 0xfeb40000-0xfeb60000
uncached-minus @ 0xfeb78000-0xfeb7c000
uncached-minus @ 0xfeb7c000-0xfeb7d000
uncached-minus @ 0xfeb7d000-0xfeb7e000
uncached-minus @ 0xfeb7f000-0xfeb80000
uncached-minus @ 0xfeb7f000-0xfeb80000
uncached-minus @ 0xfeb80000-0xfec00000
uncached-minus @ 0xfeb80000-0xfec00000
uncached-minus @ 0xfed00000-0xfed01000
uncached-minus @ 0xfed1f000-0xfed20000
uncached-minus @ 0xffff0000-0xffff1000

regards,
-- 
js
