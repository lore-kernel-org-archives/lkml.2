Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751805Ab2LTSWM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 13:22:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55323 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750875Ab2LTSWF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 13:22:05 -0500
Message-ID: <50D35713.1090506@zytor.com>
Date: Thu, 20 Dec 2012 10:21:07 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Stefani Seibold <stefani@seibold.net>
CC: Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org,
        x86@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        ak@linux.intel.com, aarcange@redhat.com, john.stultz@linaro.org,
        xemul@parallels.com, gorcunov@openvz.org,
        andriy.shevchenko@linux.intel.com,
        Roland McGrath <mcgrathr@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H.J. Lu" <hjl.tools@gmail.com>
Subject: Re: [PATCH 6/6] Add 32 bit VDSO support for 32 and 64 bit kernels
References: <1355823656-13902-1-git-send-email-stefani@seibold.net>  <1355823656-13902-7-git-send-email-stefani@seibold.net>  <50D09733.3080502@zytor.com> <1355849558.26967.24.camel@wall-e>  <50D0B986.7020009@zytor.com> <1355862759.28056.14.camel@wall-e>  <CALCETrX2zAA-X7fjoPNSERq0kVDDY43O_u=Oqjq77_ggf64j9A@mail.gmail.com>  <1355989294.24672.9.camel@wall-e>  <a881f355-720c-40aa-ad96-60fc86e96d53@email.android.com> <1356025992.25530.1.camel@wall-e>
In-Reply-To: <1356025992.25530.1.camel@wall-e>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2012 09:53 AM, Stefani Seibold wrote:
> 
> In a 32 bit kernel a VDSO can mapped on an fix address VDSO_HIGH_BASE
> (kernel parameter vdso32=2 or CONFIG_COMPAT_VDSO), which is 0xffffe000.
> There is no available page BEFORE nor AFTER the page, so it is not
> possible to have VVAR or HPET as a part of that list!!!!
> 

[Cc: Roland, Linus, H.J.]

The pages before it are safe to use, because they are kernel internal
and hence not ABI (and in fact depend on the kernel configuration
parameters.)  So pushing down the start of the fixmap region is not a
problem.  This means that to retain this compatibility the existing
entry points need to be at the end, which is more painful than we'd
like, but nevertheless there.

Do we know what actually used these fixed address, if anything, ever?

	-hpa

