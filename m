Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680Ab1BGUGD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 15:06:03 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33036 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752838Ab1BGUGB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 15:06:01 -0500
Message-ID: <4D50505D.2070402@zytor.com>
Date: Mon, 07 Feb 2011 12:04:45 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Thunderbird/3.1.7
MIME-Version: 1.0
To: castet.matthieu@free.fr
CC: Ingo Molnar <mingo@elte.hu>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-security-module@vger.kernel.org, Matthias Hopf <mhopf@suse.de>,
        rjw@sisk.pl, Andrew Morton <akpm@linux-foundation.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH] NX protection for kernel data : fix 32 bits S3 suspend
References: <4D473FD5.1090903@free.fr> <20110201080223.GB20372@elte.hu> <1296566732.4d4809cc1f963@imp.free.fr> <20110202062632.GA12256@elte.hu> <4D4CA3FD.6000901@zytor.com> <1296924395.4d4d7eeb6f1fe@imp.free.fr> <4D4F31BC.3000709@zytor.com> <1297108754.4d504f1281802@imp.free.fr>
In-Reply-To: <1297108754.4d504f1281802@imp.free.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2011 11:59 AM, castet.matthieu@free.fr wrote:
> For .39 I hope we could remove most of the RWX rights after init (This means
> make low memory trampoline NX or !RW).
> This should be possible on :
> - 32 bit if wakeup use trampoline_32 [1] that doesn't enable paging in low
> memory (can be NX)
> - trampoline_64 need fix to support NX on data section. It tries to read data
> section before enabling NX. A possible fix is to use its own page table [2]. And
> the kernel one can be NX.

No, you're really barking down the wrong path on this.  The trampoline
code is tiny; I don't think it is really worth trying to NX-ify it.  The
additional complexity caused by not being able to execute in this space
will really damage some other incoming code, so it isn't an option as
far as I'm concerned.

	-hpa
