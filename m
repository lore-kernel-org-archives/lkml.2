Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932163Ab2BVTsX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 14:48:23 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:64252 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755479Ab2BVTsT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 14:48:19 -0500
MIME-Version: 1.0
In-Reply-To: <4F448C13.1040407@zytor.com>
References: <1329845435-2313-1-git-send-email-wad@chromium.org>
	<1329845435-2313-5-git-send-email-wad@chromium.org>
	<4F448C13.1040407@zytor.com>
Date: Wed, 22 Feb 2012 13:48:17 -0600
Message-ID: <CABqD9ha1mMMe09abu7JA+104GfwYwhH4o1Tp-SxGJTmO849D5Q@mail.gmail.com>
Subject: Re: [PATCH v10 05/11] seccomp: add system call filtering using BPF
From: Will Drewry <wad@chromium.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com,
        netdev@vger.kernel.org, x86@kernel.org, arnd@arndb.de,
        davem@davemloft.net, mingo@redhat.com, oleg@redhat.com,
        peterz@infradead.org, rdunlap@xenotime.net, mcgrathr@chromium.org,
        tglx@linutronix.de, luto@mit.edu, eparis@redhat.com,
        serge.hallyn@canonical.com, djm@mindrot.org, scarybeasts@gmail.com,
        indan@nul.nu, pmoore@redhat.com, akpm@linux-foundation.org,
        corbet@lwn.net, eric.dumazet@gmail.com, markus@chromium.org,
        keescook@chromium.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 22, 2012 at 12:32 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 02/21/2012 09:30 AM, Will Drewry wrote:
>> +
>> +/**
>> + * struct seccomp_data - the format the BPF program executes over.
>> + * @args: up to 6 system call arguments.  When the calling convention is
>> + *        32-bit, the arguments will still be at each args[X] offset.
>> + * @instruction_pointer: at the time of the system call.
>> + * @arch: indicates system call convention as an AUDIT_ARCH_* value
>> + *        as defined in <linux/audit.h>.
>> + * @nr: the system call number
>> + */
>> +struct seccomp_data {
>> +     __u64 args[6];
>> +     __u64 instruction_pointer;
>> +     __u32 arch;
>> +     int nr;
>> +};
>>
>
> This got flipped around for some reason... that is a problem if we ever
> need to extend this to more than 6 arguments (I thought we had at least
> one architecture which supported 7 arguments already, but I could just
> be delusional.)

Makes sense - I'll put it back in the proper order.

thanks!
