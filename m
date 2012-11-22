Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985Ab2KVSff (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:35:35 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:57411 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963Ab2KVSfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:35:31 -0500
MIME-Version: 1.0
In-Reply-To: <CAE9FiQXJO8uxT9Gzjv9e8XeiLzwBX7fwTFzDVy=oPfboG4L=3Q@mail.gmail.com>
References: <1353482170-10160-1-git-send-email-yinghai@kernel.org>
	<1353482170-10160-12-git-send-email-yinghai@kernel.org>
	<50AD0CA1.8000904@zytor.com>
	<CAE9FiQUSjRT-r5ZE3WHVaKkUOhwFWkm9CTCv1Aa63DOsfMQMiQ@mail.gmail.com>
	<50AD291A.10600@zytor.com>
	<CAE9FiQVed0tXhbtmc_Gug0gFZ=s=j=N4B5Vr2_ZTmSj6L-65dw@mail.gmail.com>
	<a1ca794a-09d4-4d36-8c8c-67100cb3696e@email.android.com>
	<CAE9FiQXJO8uxT9Gzjv9e8XeiLzwBX7fwTFzDVy=oPfboG4L=3Q@mail.gmail.com>
Date: Wed, 21 Nov 2012 22:58:48 -0800
X-Google-Sender-Auth: fuLbHpcPNqdOndeY8lJHGfeZDjU
Message-ID: <CAE9FiQWeGz2TkLBrBZcoPrNABx51XK3xk58P+Zam_LRGoJdSiw@mail.gmail.com>
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

On Wed, Nov 21, 2012 at 10:47 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Wed, Nov 21, 2012 at 9:58 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> Yes, lets...
>>
>>
>>> also do you still think need to move ext_ramdisk... ext_cmd_line_ptr
>>> from setup_header to boot_param ?
>>

how about:

diff --git a/arch/x86/include/asm/bootparam.h b/arch/x86/include/asm/bootparam.h
index 2ad874c..81b619e 100644
--- a/arch/x86/include/asm/bootparam.h
+++ b/arch/x86/include/asm/bootparam.h
@@ -100,7 +100,10 @@ struct boot_params {
        __u8  _pad2[4];                                 /* 0x054 */
        __u64  tboot_addr;                              /* 0x058 */
        struct ist_info ist_info;                       /* 0x060 */
-       __u8  _pad3[16];                                /* 0x070 */
+       __u32 ext_ramdisk_image;                        /* 0x070 */
+       __u32 ext_ramdisk_size;                         /* 0x074 */
+       __u32 ext_cmd_line_ptr;                         /* 0x078 */
+       __u8  _pad3[4];                                 /* 0x07C */
        __u8  hd0_info[16];     /* obsolete! */         /* 0x080 */
        __u8  hd1_info[16];     /* obsolete! */         /* 0x090 */
        struct sys_desc_table sys_desc_table;           /* 0x0a0 */
