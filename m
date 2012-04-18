Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753003Ab2DRSBe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 14:01:34 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:53095 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774Ab2DRSBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 14:01:33 -0400
MIME-Version: 1.0
In-Reply-To: <4F8EFE4D.2040201@zytor.com>
References: <1329696488-16970-1-git-send-email-hpa@zytor.com>
	<tip-31796ac4e8f0e88f5c10f1ad6dab8f19bebe44a4@git.kernel.org>
	<CAMe9rOqF6Kh6-NK7oP0Fpzkd4SBAWU+G53hwBbSD4iA2UzyxuA@mail.gmail.com>
	<4F8EFE4D.2040201@zytor.com>
Date: Wed, 18 Apr 2012 11:01:32 -0700
Message-ID: <CAMe9rOpfPQghra1PQTUwsFOvjgNpzFDEGS5=BbFBjn=HZGL93g@mail.gmail.com>
Subject: Re: [tip:x86/x32] x32: Fix alignment fail in struct compat_siginfo
From: "H.J. Lu" <hjl.tools@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2012 at 10:47 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 04/18/2012 10:38 AM, H.J. Lu wrote:
>>
>> It doesn't match struct siginfo in include/asm-generic/siginfo.h for
>> x32.
>>
>
> What is missing (from either)?
>

include/asm-generic/siginfo.h has

                /* SIGCHLD */
                struct {
                        __kernel_pid_t _pid;    /* which child */
                        __ARCH_SI_UID_T _uid;   /* sender's uid */
                        int _status;            /* exit code */
                        __kernel_clock_t _utime;
                        __kernel_clock_t _stime;
                } _sigchld;


Although x32 __kernel_clock_t is s64 with 64bit alignment, in
_sigchld, it must be compat_s64 with 32bit alignment.

-- 
H.J.
