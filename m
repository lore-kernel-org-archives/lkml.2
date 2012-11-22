Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173Ab2KVS2d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:28:33 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38919 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533Ab2KVS2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:28:30 -0500
MIME-Version: 1.0
In-Reply-To: <a8b15bf0-4e3b-4fde-9190-26890f9abf77@email.android.com>
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
Date: Thu, 22 Nov 2012 10:28:29 -0800
X-Google-Sender-Auth: yFJMNsoMkubQarJUr23rcA-8ASw
Message-ID: <CAE9FiQUoj9k0Tbqp8LC8Wb21_s_x8naiWX4zkX9pJG-oFnAQ9g@mail.gmail.com>
Subject: Re: [PATCH v3 11/12] x86, boot: add fields to support load bzImage
 and ramdisk high
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>,
        Matt Fleming <matt.fleming@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 22, 2012 at 7:59 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> Looks good to me.
>

has problem with old kexec, it only copy header from bzImage include
setup_header as boot_param.

00000000  ea 05 00 c0 07 8c c8 8e  d8 8e c0 8e d0 31 e4 fb  |.............1..|
00000010  fc be 2d 00 ac 20 c0 74  09 b4 0e bb 07 00 cd 10  |..-.. .t........|
00000020  eb f2 31 c0 cd 16 cd 19  ea f0 ff 00 f0 44 69 72  |..1..........Dir|
00000030  65 63 74 20 66 6c 6f 70  70 79 20 62 6f 6f 74 20  |ect floppy boot |
00000040  69 73 20 6e 6f 74 20 73  75 70 70 6f 72 74 65 64  |is not supported|
00000050  2e 20 55 73 65 20 61 20  62 6f 6f 74 20 6c 6f 61  |. Use a boot loa|
00000060  64 65 72 20 70 72 6f 67  72 61 6d 20 69 6e 73 74  |der program inst|
00000070  65 61 64 2e 0d 0a 0a 52  65 6d 6f 76 65 20 64 69  |ead....Remove di|
00000080  73 6b 20 61 6e 64 20 70  72 65 73 73 20 61 6e 79  |sk and press any|
00000090  20 6b 65 79 20 74 6f 20  72 65 62 6f 6f 74 20 2e  | key to reboot .|
000000a0  2e 2e 0d 0a 00 00 00 00  00 00 00 00 00 00 00 00  |................|
000000b0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
000001f0  00 21 01 00 33 15 09 00  00 00 ff ff 00 00 55 aa  |.!..3.........U.|


so will have stuff in 0x70

then i change to 0xC0, when CONFIG_EFI_STUB is enabled, there is value
there too.


00000000  4d 5a ea 07 00 c0 07 8c  c8 8e d8 8e c0 8e d0 31  |MZ.............1|
00000010  e4 fb fc be 40 00 ac 20  c0 74 09 b4 0e bb 07 00  |....@.. .t......|
00000020  cd 10 eb f2 31 c0 cd 16  cd 19 ea f0 ff 00 f0 00  |....1...........|
00000030  00 00 00 00 00 00 00 00  00 00 00 00 b8 00 00 00  |................|
00000040  44 69 72 65 63 74 20 66  6c 6f 70 70 79 20 62 6f  |Direct floppy bo|
00000050  6f 74 20 69 73 20 6e 6f  74 20 73 75 70 70 6f 72  |ot is not suppor|
00000060  74 65 64 2e 20 55 73 65  20 61 20 62 6f 6f 74 20  |ted. Use a boot |
00000070  6c 6f 61 64 65 72 20 70  72 6f 67 72 61 6d 20 69  |loader program i|
00000080  6e 73 74 65 61 64 2e 0d  0a 0a 52 65 6d 6f 76 65  |nstead....Remove|
00000090  20 64 69 73 6b 20 61 6e  64 20 70 72 65 73 73 20  | disk and press |
000000a0  61 6e 79 20 6b 65 79 20  74 6f 20 72 65 62 6f 6f  |any key to reboo|
000000b0  74 20 2e 2e 2e 0d 0a 00  50 45 00 00 64 86 03 00  |t ......PE..d...|
000000c0  00 00 00 00 00 00 00 00  01 00 00 00 a0 00 06 02  |................|
000000d0  0b 02 02 14 20 be 91 00  00 00 00 00 00 00 00 00  |.... ...........|
000000e0  10 46 00 00 00 02 00 00  00 00 00 00 00 00 00 00  |.F..............|
000000f0  20 00 00 00 20 00 00 00  00 00 00 00 00 00 00 00  | ... ...........|
00000100  00 00 00 00 00 00 00 00  20 c0 91 00 00 02 00 00  |........ .......|
00000110  00 00 00 00 0a 00 00 00  00 00 00 00 00 00 00 00  |................|
00000120  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
00000130  00 00 00 00 00 00 00 00  00 00 00 00 06 00 00 00  |................|
00000140  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00000170  2e 73 65 74 75 70 00 00  e0 41 00 00 00 02 00 00  |.setup...A......|
00000180  e0 41 00 00 00 02 00 00  00 00 00 00 00 00 00 00  |.A..............|
00000190  00 00 00 00 20 00 50 60  2e 72 65 6c 6f 63 00 00  |.... .P`.reloc..|
000001a0  20 00 00 00 e0 43 00 00  20 00 00 00 e0 43 00 00  | ....C.. ....C..|
000001b0  00 00 00 00 00 00 00 00  00 00 00 00 40 00 10 42  |............@..B|
000001c0  2e 74 65 78 74 00 00 00  20 7c 91 00 00 44 00 00  |.text... |...D..|
000001d0  20 7c 91 00 00 44 00 00  00 00 00 00 00 00 00 00  | |...D..........|
000001e0  00 00 00 00 20 00 50 60  00 00 00 00 00 00 00 00  |.... .P`........|
000001f0  00 21 01 00 c2 17 09 00  00 00 ff ff 00 00 55 aa  |.!............U.|


looks we only can use [0x30,0x3c), [0x1e8, 0x1f0), but in boot_params, they
are apm_bios_info, and alt_mem_k...

so looks we still have to use setup_header instead.
