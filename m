Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209Ab0HOGIP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 02:08:15 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:38740 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1750771Ab0HOGIO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 02:08:14 -0400
X-Authenticated: #28250155
X-Provags-ID: V01U2FsdGVkX194/q8Sm4F4Sn9a5Gvqc29Z2Bx/O0PW+BVkR0d//j
	2DuW9tYvXcyJ9E
From: Sven Joachim <svenjoac@gmx.de>
To: Greg KH <greg@kroah.com>
Cc: Alok Kataria <akataria@vmware.com>, Greg KH <gregkh@suse.de>,
        stable@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [stable] 2.6.34.4 build failure
References: <87sk2h1yki.fsf@turtle.gmx.de> <20100814211043.GC7799@kroah.com>
Date: Sun, 15 Aug 2010 08:08:10 +0200
In-Reply-To: <20100814211043.GC7799@kroah.com> (Greg KH's message of "Sat, 14
	Aug 2010 14:10:43 -0700")
Message-ID: <87hbiwl86t.fsf@turtle.gmx.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-08-14 23:10 +0200, Greg KH wrote:

> On Sat, Aug 14, 2010 at 08:46:21AM +0200, Sven Joachim wrote:
>> 2.6.34.4 failed to build here:
>> 
>> ,----
>> |   CC      arch/x86/kernel/cpu/vmware.o
>> | arch/x86/kernel/cpu/vmware.c: In function 'vmware_get_tsc_khz':
>> | arch/x86/kernel/cpu/vmware.c:66: error: 'preset_lpj' undeclared (first use in this function)
>> | arch/x86/kernel/cpu/vmware.c:66: error: (Each undeclared identifier is reported only once
>> | arch/x86/kernel/cpu/vmware.c:66: error: for each function it appears in.)
>> | arch/x86/kernel/cpu/vmware.c:68: error: 'HZ' undeclared (first use in this function)
>> | make[3]: *** [arch/x86/kernel/cpu/vmware.o] Error 1
>> | make[2]: *** [arch/x86/kernel/cpu] Error 2
>> | make[1]: *** [arch/x86/kernel] Error 2
>> | make: *** [arch/x86] Error 2
>> `----
>> 
>> The .config file follows.
>
> If you add:
> 	#include <linux/jiffies.h>
> to that file, does it then build?

Yes, that does of course help.

> Odd that this isn't showing up in the .35 kernel :(

I just double-checked whether it was due to some configuration change
that I made, but it wasn't.  Just running 'yes "" | make oldconfig'
produced a configuration that builds with 2.6.35.2.

Anyway, including <linux/jiffies.h> seems to be a reasonable precaution
measure to me, but I'm just a layman.

Regards,
        Sven
