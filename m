Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751494Ab2KXHA5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2012 02:00:57 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:63874 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889Ab2KXHA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2012 02:00:56 -0500
MIME-Version: 1.0
In-Reply-To: <874nkh3mip.fsf@xmission.com>
References: <1353482170-10160-1-git-send-email-yinghai@kernel.org>
	<1353482170-10160-2-git-send-email-yinghai@kernel.org>
	<50AD0E22.3020807@zytor.com>
	<CAE9FiQVreVFJ5tASirYkzTUvYw1XombdArqN3N1HnAP9wLijhQ@mail.gmail.com>
	<50AD307C.6060008@zytor.com>
	<CAE9FiQUaajsWe3854xxUOyPEZ7Dbt3GE0VWs8KvQbtqVrOXQdw@mail.gmail.com>
	<87d2z6jigs.fsf@xmission.com>
	<3178cb29-0e9e-44d2-b21f-45c53f38980a@email.android.com>
	<874nkh3mip.fsf@xmission.com>
Date: Fri, 23 Nov 2012 23:00:54 -0800
X-Google-Sender-Auth: GDp4-Rzx0GK_V7bGWzhQ6YW9gNk
Message-ID: <CAE9FiQWEjAd5HrreT+nLjuPX1to06Tf+UDfsKL3Wr+Qy4gF+CA@mail.gmail.com>
Subject: Re: [PATCH v3 01/12] x86, boot: move verify_cpu.S after 0x200
From: Yinghai Lu <yinghai@kernel.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Matt Fleming <matt.fleming@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 22, 2012 at 3:27 AM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> "H. Peter Anvin" <hpa@zytor.com> writes:
>
>> Quite certain something depends on it.
>
> It would not surprise me at all that there is a dependency, if we have
> not had a better way to report the 64bit entry point.  I just wanted to
> make the context clear as that was confused in the discussion.
>
> Note that having a 32bit entry point at offset 0 is as much of an ABI.
>
> I am surprised that there are legitimate reasons to bulk up the 32bit
> entry point code before the 0x200.  Everything that we are doing at that
> point is architectural.

arch/x86/boot/header.S has bzImage 16 bit entry, and it is 0x200

arch/x86/boot/compressed/head_64.S has bzImage 32bit entry and 64bit entry.
loader need to find out the setup_code size at first aka kern16_size.
then from kern16_size will be 32bit code/64 bit code, will be aligned
to kernel_align
then from there 0: will be 32bit entry, 0x200 will be 64bit entry.

Actually kexec does not support bzImage booting directly from 64bit
before this patch set.

So are there any 64 bit boot loader that load bzImage and boot
directly from that second 0x200
64 bit entry ?

If there is no such bootloader there, we may change that position, and
add one field in setup_header
for it.

Thanks

Yinghai
