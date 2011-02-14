Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241Ab1BNUzp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 15:55:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58277 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751140Ab1BNUzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 15:55:43 -0500
Message-ID: <4D5996A8.3070605@zytor.com>
Date: Mon, 14 Feb 2011 12:55:04 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: matthieu castet <castet.matthieu@free.fr>
CC: Ingo Molnar <mingo@elte.hu>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-security-module@vger.kernel.org, Matthias Hopf <mhopf@suse.de>,
        rjw@sisk.pl, Andrew Morton <akpm@linux-foundation.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH] NX protection for kernel data : fix 32 bits S3 suspend
References: <4D473FD5.1090903@free.fr> <20110201080223.GB20372@elte.hu> <1296566732.4d4809cc1f963@imp.free.fr> <20110202062632.GA12256@elte.hu> <4D4CA3FD.6000901@zytor.com> <1296924395.4d4d7eeb6f1fe@imp.free.fr> <4D4F31BC.3000709@zytor.com> <1297108754.4d504f1281802@imp.free.fr> <4D50505D.2070402@zytor.com> <4D56B0E6.5040600@free.fr>
In-Reply-To: <4D56B0E6.5040600@free.fr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2011 08:10 AM, matthieu castet wrote:
>>
>> No, you're really barking down the wrong path on this.  The trampoline
>> code is tiny; I don't think it is really worth trying to NX-ify it.  The
> Even if the trampoline is tiny, a hole is a hole.
> 
> The trampoline code job is to jump from low memory (realmode) to
> somewhere in kernel text.
> Why should we enable paging or use kernel page table for doing that ?
> 

That's not the problem.  The problem is that most of the "trampoline
codes" need parameters which need to be written by the kernel before
invocation.  Separating the address spaces out into text and
writable-for-the-kernel data is possible, but messy since the individual
chunks each have different addressing constraints.  I tried to get them
into the same link, but that has turned out to be very difficult and
probably will require a fair bit of restructuring, especially the code
shared with the boot code.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

