Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525Ab2BTA4W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 19:56:22 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57615 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751467Ab2BTA4V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 19:56:21 -0500
Message-ID: <4F419A28.1060903@zytor.com>
Date: Sun, 19 Feb 2012 16:56:08 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, mingo@kernel.org,
        tglx@linutronix.de, akpm@linux-foundation.org, hjl.tools@gmail.com
Subject: Re: [PATCH 02/30] x86-64: Use explicit sizes in sigcontext.h, prepare
 for x32
References: <1329696488-16970-1-git-send-email-hpa@zytor.com> <1329696488-16970-3-git-send-email-hpa@zytor.com> <CA+55aFy__c1j=APK9tjJ__daYtZN74GySANxBZ9kT9e1Zx9DXQ@mail.gmail.com>
In-Reply-To: <CA+55aFy__c1j=APK9tjJ__daYtZN74GySANxBZ9kT9e1Zx9DXQ@mail.gmail.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2012 04:51 PM, Linus Torvalds wrote:
> On Sun, Feb 19, 2012 at 4:07 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>>
>> Use explicit sizes (__u64) instead of implicit sizes (unsigned long)
>> in the definition for sigcontext.h; this will allow this structure to
>> be shared between the x86-64 native ABI and the x32 ABI.
> 
> Btw, since we had this issue just with autofs: what are the x32 ABI
> alignment issues for __u64? Are they like x86-64 ("natural alignment")
> or x86-32 ("4-byte alignment")?
> 
> I assume they are natural alignment, and as pointed out by Davem, we
> do have the versions of u64 that make this explicit: "compat_u64" is
> the 4-byte-aligned one, while "__aligned_u64" is the natively aligned
> one.
> 
> Just plain "__u64" doesn't tell which it is, which is sad and wrong,
> but we're likely stuck with it forever. Unless some shining knight
> comes and says "__u64 is native alignment, and if you want anything
> else, you need to use __compat_u64", and actually fixes the cases
> where x86-32 depends on the 4-byte aligned one.
> 
> Which would be nice, but sounds unlikely. Shining knights tend to be
> rare. But this *could* possibly be automated, so it's not entirely out
> of the question.
> 

We are using __u64 as x86-32 compatible since we are sharing most of the
really complex path (like ioctl) with i386 much more so than x86-64.  So
it is defined in userspace as:

typedef unsigned long long __u64 __attribute__((aligned(4)));

__aligned_u64 obviously is naturally aligned, which matches uint64_t is
userspace.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

