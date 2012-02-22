Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762Ab2BVOXu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 09:23:50 -0500
Received: from exchange.solarflare.com ([216.237.3.220]:9756 "EHLO
	ocex02.SolarFlarecom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751746Ab2BVOXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 09:23:47 -0500
Message-ID: <1329920626.3258.174.camel@deadeye>
Subject: Re: [PATCH v10 05/11] seccomp: add system call filtering using BPF
From: Ben Hutchings <bhutchings@solarflare.com>
To: Indan Zupancic <indan@nul.nu>
CC: Will Drewry <wad@chromium.org>, <linux-kernel@vger.kernel.org>,
        <linux-arch@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <kernel-hardening@lists.openwall.com>, <netdev@vger.kernel.org>,
        <x86@kernel.org>, <arnd@arndb.de>, <davem@davemloft.net>,
        <hpa@zytor.com>, <mingo@redhat.com>, <oleg@redhat.com>,
        <peterz@infradead.org>, <rdunlap@xenotime.net>,
        <mcgrathr@chromium.org>, <tglx@linutronix.de>, <luto@mit.edu>,
        <eparis@redhat.com>, <serge.hallyn@canonical.com>, <djm@mindrot.org>,
        <scarybeasts@gmail.com>, <pmoore@redhat.com>,
        <akpm@linux-foundation.org>, <corbet@lwn.net>,
        <eric.dumazet@gmail.com>, <markus@chromium.org>,
        <keescook@chromium.org>
Date: Wed, 22 Feb 2012 14:23:46 +0000
In-Reply-To: <38d58caa17befe422065efe5dc451a34.squirrel@webmail.greenhost.nl>
References: <1329845435-2313-1-git-send-email-wad@chromium.org>
	 <1329845435-2313-5-git-send-email-wad@chromium.org>
	 <38d58caa17befe422065efe5dc451a34.squirrel@webmail.greenhost.nl>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [88.96.1.126]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-6.800.1017-18726.000
X-TM-AS-Result: No--10.025500-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-22 at 09:19 +0100, Indan Zupancic wrote:
[...]
> Alternative approach: Tell the arch at filter install time and only run the
> filters with the same arch as the current system call. If no filters are run,
> deny the systemcall.
>
> Advantages:
> 
> - Filters don't have to check the arch every syscall entry.
> 
> - Secure by default. Filters don't have to do anything arch specific to
>   be secure, no surprises possible.
> 
> - If a new arch comes into existence, there is no chance of old filters
>   becoming buggy and insecure. This is especially true for archs that
>   had only one mode, but added another one later on: Old filters had no
>   need to check the mode at all.
[...]

What about when there are multiple layers of restrictions?  So long as
any one layer covers the new architecture, there is no default-deny even
though the other layers might not cover it.

I would have thought the way to make sure the architecture is always
checked is to pack it together with the syscall number.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

