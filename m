Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031271Ab2CNXo5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 19:44:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51213 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965352Ab2CNXoz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 19:44:55 -0400
Message-ID: <4F612D6C.5000807@zytor.com>
Date: Wed, 14 Mar 2012 16:44:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: "H.J. Lu" <hjl.tools@gmail.com>, mingo@redhat.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/x32] x32: Fix alignment fail in struct compat_siginfo
References: <1329696488-16970-1-git-send-email-hpa@zytor.com> <tip-31796ac4e8f0e88f5c10f1ad6dab8f19bebe44a4@git.kernel.org> <CAMe9rOpGgs9hR31Jxk8ycMNnEoCzUV2_xTeeE+uaEFgz5AEEwQ@mail.gmail.com> <20120314233351.GA17669@banjo.employees.org>
In-Reply-To: <20120314233351.GA17669@banjo.employees.org>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/2012 04:33 PM, Derek Fawcus wrote:
> On Wed, Mar 14, 2012 at 04:17:29PM -0700, H.J. Lu wrote:
>> Just for the record, although the offsets of _utime and _stime are
>> multiple of 8 bytes, struct siginfo is only aligned at 4 bytes.  So
>> the addresses of  _utime and _stime may not be 8byte aligned.
>> But misaligned int64 load/store are OK for x86-64.
> 
> So whereas on i386 and x86_64 we can set eflags.AC (or rflags.AC) to test the
> code for aligment safeness,  we'll not be able to do so with x32?
> 
> (Simply 'cause this could get false positive on syscalls).
> 
> Granted this is not a common use,  but I've done it for checking that code
> will easily port to ppc/mips.
> 

I'm surprised you have been able to do so at all... there is tons of
regular x86 code which is totally broken if AC=1, simply because they
know that if you're on an x86 you can do unaligned references (on MIPS
they would do load right/load left, on ARM use the swizzled data, and so
on.)

But yes, due to the reuse of some of the i386 ABI data structures the
data structures that operate on the kernel ABI will not be AC-safe in
the general case.  Normal user space code will be naturally aligned in
all cases.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

