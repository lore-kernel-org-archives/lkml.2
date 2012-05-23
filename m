Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758647Ab2EWQvJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 12:51:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42183 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751520Ab2EWQvG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 12:51:06 -0400
Message-ID: <4FBD1567.1070101@kernel.org>
Date: Wed, 23 May 2012 09:50:47 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Borislav Petkov <borislav.petkov@amd.com>, mingo@kernel.org,
        linux-kernel@vger.kernel.org, frank.arnold@amd.com,
        akpm@linux-foundation.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/mce] x86/bitops: Move BIT_64() for a wider use
References: <1337684026-19740-1-git-send-email-bp@amd64.org> <tip-e8f380e00840f694599e6ab42806639f7de26f11@git.kernel.org> <1337789429.9783.16.camel@laptop> <4FBD0C47.70600@zytor.com> <20120523161932.GN14757@aftab.osrc.amd.com> <1337790571.9783.28.camel@laptop> <4FBD10D5.6080602@zytor.com> <CA+55aFx383ZXZPrbe+C2Cv=Rr=FsARfs8=OXs-B0hK4Dzb-QLg@mail.gmail.com> <4FBD1493.7000104@zytor.com>
In-Reply-To: <4FBD1493.7000104@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2012 09:47 AM, H. Peter Anvin wrote:
> 
> BIT(0), okay.  I thought we were talking about BIT_64() here...
> 
> Any reason we can't just tell people to use BIT() for a native "unsigned
> long" type (32/64 bits) and BIT_64() if they really want a 64-bit result?
> 
> There are good reasons for the latter.  Consider, for example:
> 
> 	u64 msr;
> 	...
> 	msr &= ~BIT_64(1);
> 
> This *better* not be an unsigned 32 bit value, or we just chopped off
> the upper half.  In this case and similar ones the 64-bitness of the
> result really matters.
> 

To better clarify my concern: my concern is that if we make BIT() be a
DWIM type, it will appear to work in most situations.  As such, we'll
see things in headers like:

#define MSR_BLAH_FOO	BIT(31)
#define MSR_BLAH_BAR	BIT(32)

... and *almost all the time* the above will work.  But if you use
MSR_BLAH_FOO inverted, then you get truncation.

	-hpa

