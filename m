Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487Ab1BGT7c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 14:59:32 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:47925 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753233Ab1BGT7a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 14:59:30 -0500
Message-ID: <1297108754.4d504f1281802@imp.free.fr>
Date: Mon, 07 Feb 2011 20:59:14 +0100
From: castet.matthieu@free.fr
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: castet.matthieu@free.fr, Ingo Molnar <mingo@elte.hu>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-security-module@vger.kernel.org, Matthias Hopf <mhopf@suse.de>,
        rjw@sisk.pl, Andrew Morton <akpm@linux-foundation.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH] NX protection for kernel data : fix 32 bits S3 suspend
References: <4D473FD5.1090903@free.fr> <20110201080223.GB20372@elte.hu> <1296566732.4d4809cc1f963@imp.free.fr> <20110202062632.GA12256@elte.hu> <4D4CA3FD.6000901@zytor.com> <1296924395.4d4d7eeb6f1fe@imp.free.fr> <4D4F31BC.3000709@zytor.com>
In-Reply-To: <4D4F31BC.3000709@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
User-Agent: Internet Messaging Program (IMP) 3.2.8
X-Originating-IP: 81.57.151.96
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for cleaning the patch.

Selon "H. Peter Anvin" <hpa@zytor.com>:
> On 02/05/2011 08:46 AM, castet.matthieu@free.fr wrote:
>
> No, the problem is that the code is braindamaged and don't take into
> account reserved areas or have a mechanism for marking the reserved
> areas so that kernel_physical_mapping_init can do the right thing... and
> then it's hacked around instead of done properly.
>
> We obviously need to reserve this memory very early in order to make
> sure it exists, and init_memory_mapping() ->
> kernel_physical_mapping_init() really should be able to deal with that
> (for example by walking the list of reserved memory regions and look
> which ones of them should have specific protection bits -- not just NX
> -- set appropriately.)
>
> The trampoline unification patch could have made this less broken, but
> that code is certainly not ready for .38.
>
For .39 I hope we could remove most of the RWX rights after init (This means
make low memory trampoline NX or !RW).
This should be possible on :
- 32 bit if wakeup use trampoline_32 [1] that doesn't enable paging in low
memory (can be NX)
- trampoline_64 need fix to support NX on data section. It tries to read data
section before enabling NX. A possible fix is to use its own page table [2]. And
the kernel one can be NX.


Matthieu


[1]
http://marc.info/?l=linux-acpi&m=129616540303575&w=2

[2]
http://marc.info/?l=linux-kernel&m=129590778414274&w=2
