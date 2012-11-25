Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749Ab2KYAEg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2012 19:04:36 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48096 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676Ab2KYAEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2012 19:04:35 -0500
MIME-Version: 1.0
In-Reply-To: <87vccud0i5.fsf@xmission.com>
References: <1353482170-10160-1-git-send-email-yinghai@kernel.org>
	<1353482170-10160-12-git-send-email-yinghai@kernel.org>
	<50AD0CA1.8000904@zytor.com>
	<CAE9FiQUSjRT-r5ZE3WHVaKkUOhwFWkm9CTCv1Aa63DOsfMQMiQ@mail.gmail.com>
	<50AD291A.10600@zytor.com>
	<CAE9FiQVed0tXhbtmc_Gug0gFZ=s=j=N4B5Vr2_ZTmSj6L-65dw@mail.gmail.com>
	<a1ca794a-09d4-4d36-8c8c-67100cb3696e@email.android.com>
	<CAE9FiQXJO8uxT9Gzjv9e8XeiLzwBX7fwTFzDVy=oPfboG4L=3Q@mail.gmail.com>
	<CAE9FiQWeGz2TkLBrBZcoPrNABx51XK3xk58P+Zam_LRGoJdSiw@mail.gmail.com>
	<a8b15bf0-4e3b-4fde-9190-26890f9abf77@email.android.com>
	<CAE9FiQUoj9k0Tbqp8LC8Wb21_s_x8naiWX4zkX9pJG-oFnAQ9g@mail.gmail.com>
	<50AE70E7.6060204@zytor.com>
	<87haofi3d3.fsf@xmission.com>
	<50B104BC.90208@zytor.com>
	<50B124E9.400@zytor.com>
	<87vccud0i5.fsf@xmission.com>
Date: Sat, 24 Nov 2012 16:04:33 -0800
X-Google-Sender-Auth: IZ4VYCS2uWlhMR8ZENsFkVzfSr4
Message-ID: <CAE9FiQUnPs-edobmpwTkyuFOrYziLjBBBxHgmND37+a64H-oHw@mail.gmail.com>
Subject: Re: [PATCH v3 11/12] x86, boot: add fields to support load bzImage
 and ramdisk high
From: Yinghai Lu <yinghai@kernel.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Rob Landley <rob@landley.net>, Matt Fleming <matt.fleming@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 24, 2012 at 3:50 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
>
> I believe all added variables between the last version of the boot
> protocol /sbin/kexec knows about and the current time were added in the
> initialized data section.  Certainly we can check and that will tell us
> how likely changes in arch/x86/boot/ have been regressions in the 32bit
> entry point support.
>
> As for solving this there is a simple solution.  Add a second jump
> right after the first jump.   The variables after the second jump can
> all be zero initialized.

could use .org to force start_of_setup start from 0x1000

but how about area before setup_header ? how it is full of EFI_STUB suff there.

Yinghai
