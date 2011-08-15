Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090Ab1HOTAf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 15:00:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51910 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751242Ab1HOTAd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 15:00:33 -0400
Message-ID: <4E496CAC.3030103@zytor.com>
Date: Mon, 15 Aug 2011 11:59:56 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Solar Designer <solar@openwall.com>
CC: Andi Kleen <andi@firstfloor.org>, Vasiliy Kulikov <segoon@openwall.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        James Morris <jmorris@namei.org>, kernel-hardening@lists.openwall.com,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, Will Drewry <wad@chromium.org>
Subject: Re: [RFC] x86: restrict pid namespaces to 32 or 64 bit syscalls
References: <20110812150304.GC16880@albatros> <4E45884B.8030303@zytor.com> <20110813062246.GC3851@albatros> <36fcaf94-2e99-47cb-a835-aefb79856429@email.android.com> <m2ei0olnua.fsf@firstfloor.org> <632d03b0-6725-431e-b100-13f5046b03e9@email.android.com> <20110814092028.GB14293@openwall.com> <01ba0cce-d28e-473e-be3a-7d3c8f185681@email.android.com> <20110815185114.GA20115@openwall.com>
In-Reply-To: <20110815185114.GA20115@openwall.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2011 11:51 AM, Solar Designer wrote:
> I agree with you that i386 vs x86-64 vs x32 is one axis and syscall
> number is another axis.

They are not.  ABI is ONE SUBSET OF SYSCALL NUMBERS.

> Per-syscall restrictions are also useful, but primarily at a different
> level - I'd expect them to be used in specific programs, such as Chrome
> and vsftpd.  Those programs may also want to limit themselves to a
> certain type of syscalls (that is, on the i386 vs x86-64 vs x32 axis),
> thereby making use of both features at once.  Or they might even have to
> do that, depending on how we implement the syscall restrictions.
> 
> Per your suggestion, if I understand correctly, any task that wants to
> restrict itself on the i386 vs x86-64 vs x32 axis will have TIF_SECCOMP
> set and will incur calls into __secure_computing().  This is unnecessary
> overhead for the case when we have a restriction over this axis only,
> without per-syscall restrictions.  Vasiliy's patch avoids such overhead.

There is really no bloody difference between i386 vs x86-64 and, say,
sys_oldstat versus sys_stat, or anything else along those lines.
Putting in a bunch of ad hoc facilities because of semi-plausible
performance wins rather than building a sane filtering facility which
can be optimized as a single path is ridiculous.

	-hpa
