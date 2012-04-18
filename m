Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063Ab2DRSd0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 14:33:26 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:47879 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386Ab2DRSdZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 14:33:25 -0400
MIME-Version: 1.0
In-Reply-To: <4F8F0614.9010604@zytor.com>
References: <1329696488-16970-1-git-send-email-hpa@zytor.com>
	<tip-31796ac4e8f0e88f5c10f1ad6dab8f19bebe44a4@git.kernel.org>
	<CAMe9rOqF6Kh6-NK7oP0Fpzkd4SBAWU+G53hwBbSD4iA2UzyxuA@mail.gmail.com>
	<4F8EFE4D.2040201@zytor.com>
	<CAMe9rOpfPQghra1PQTUwsFOvjgNpzFDEGS5=BbFBjn=HZGL93g@mail.gmail.com>
	<4F8F0385.5090901@zytor.com>
	<CAMe9rOq7LduF4aLPe9qatedxps4WPCgOHTD=E_Lje4_tu6tyZw@mail.gmail.com>
	<4F8F0614.9010604@zytor.com>
Date: Wed, 18 Apr 2012 11:33:24 -0700
Message-ID: <CAMe9rOqBd29LKB==NaKscpedRMR1uL_ZhHqSw1HQj-3_d9PSCw@mail.gmail.com>
Subject: Re: [tip:x86/x32] x32: Fix alignment fail in struct compat_siginfo
From: "H.J. Lu" <hjl.tools@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2012 at 11:21 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 04/18/2012 11:15 AM, H.J. Lu wrote:
>>
>> In x32 glibc, I have
>>
>> # if compile for X32
>> /* si_utime and si_stime must be 4 byte aligned for x32 to match the
>>    kernel.  We align siginfo_t to 8 bytes so that si_utime and si_stime
>>    are actually aligned to 8 bytes since their offsets are multiple of
>>    8 bytes.  */
>> typedef __clock_t __attribute__ ((__aligned__ (4))) __sigchld_clock_t;
>> #  define __SI_ALIGNMENT __attribute__ ((__aligned__ (8)))
>> # else
>> typedef __clock_t __sigchld_clock_t;
>> #  define __SI_ALIGNMENT
>> # endif
>>
>> typedef struct siginfo
>>   {
>> ...
>>       /* SIGCHLD.  */
>>       struct
>>         {
>>           __pid_t si_pid;     /* Which child.  */
>>           __uid_t si_uid;     /* Real user ID of sending process.  */
>>           int si_status;      /* Exit value or signal.  */
>>           __sigchld_clock_t si_utime;
>>           __sigchld_clock_t si_stime;
>>         } _sigchld;
>> ...
>>   } siginfo_t __SI_ALIGNMENT;
>>
>
> So in other words, a separate type just for this.  However, the question

Yes.

> still holds: could we simply change __kernel_clock_t for x32 and be done
> with it?  It would affect the alignment of struct tms, I guess; it
> wouldn't really affect the kernel directly since the kernel gets a
> pointer straight from userspace for times(2), but it would kind of mess
> up a userspace which uses __kernel_clock_t directly.

That is true.

> Urk, okay...
>

This is the best approach I can think of.

-- 
H.J.
