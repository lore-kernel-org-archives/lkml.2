Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751028Ab2KYFuF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2012 00:50:05 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:49730 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782Ab2KYFuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2012 00:50:04 -0500
MIME-Version: 1.0
In-Reply-To: <CAE9FiQUUsQ3hn-xTeXsN+qA5YSSNbftoRbxHpdX0HWYmVHqfEA@mail.gmail.com>
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
	<50B16080.7040809@zytor.com>
	<CAE9FiQUUsQ3hn-xTeXsN+qA5YSSNbftoRbxHpdX0HWYmVHqfEA@mail.gmail.com>
Date: Sat, 24 Nov 2012 21:50:01 -0800
X-Google-Sender-Auth: V8S1rGVd3raWQGF00_8WlkaN2lE
Message-ID: <CAE9FiQXvFXrvmATUfv682Ob7Jo7-fvs_1edxVhiNSS_Wmx4qcA@mail.gmail.com>
Subject: Re: [PATCH v3 11/12] x86, boot: add fields to support load bzImage
 and ramdisk high
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>,
        Matt Fleming <matt.fleming@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 24, 2012 at 4:11 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Sat, Nov 24, 2012 at 4:04 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>>
>> It sounds like we are leaning toward some form of the sentinel hack, which
>> means we need an enumerated list of things that should *not* be zeroed if
>> the sentinel is present.
>>
>> The option of declaring the list frozen makes me a bit nervous, because it
>> isn't clear that we don't already have fields that will be misinterpreted by
>> the kernel if filled in from the file.
>
> USE_EXT_BOOT_PARAMS bit in xloadflags should work.

new kexec will clean around bit around setup head, and set that bit,
if it is not with real_mode entry.

32bit and 64bit entry:
old kernel has no idea of this bit, and still use old ramdisk_image,
cmd_line_ptr in setup header.
new kernel will check that bit before it use ext_ramdisk_image, and
ext_cmd_line_ptr.

old kexec and new kernel is safe too, because that bit is not set, new
kernel will not use ex_...

later all new kernel need to check USE_EXT_BOOT_PARAMS bit for all new
added field in boot_params.
