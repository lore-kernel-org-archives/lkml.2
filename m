Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110Ab2KVWNM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 17:13:12 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35092 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753934Ab2KVWNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 17:13:10 -0500
MIME-Version: 1.0
In-Reply-To: <50AE92FD.2090103@zytor.com>
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
	<CAE9FiQXKgnZyFNujKhMn94+0JQ6jtAHOihmtMOmk_gJi-4_aYQ@mail.gmail.com>
	<50AE7429.6030308@zytor.com>
	<CAE9FiQVDbR4d3-SgQ0O3hOWqApN241Pxd7fvF7-wwPWbdX75ug@mail.gmail.com>
	<50AE902D.5090705@zytor.com>
	<50AE92FD.2090103@zytor.com>
Date: Thu, 22 Nov 2012 14:13:08 -0800
X-Google-Sender-Auth: njAXYt3M-fnqx8ss6NVs_uJgjVM
Message-ID: <CAE9FiQXS6jc8+N5533HFnqT3_eF5dHzYXkxoUJ8JRVq8VfcSNg@mail.gmail.com>
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

On Thu, Nov 22, 2012 at 1:02 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 11/22/2012 12:50 PM, H. Peter Anvin wrote:
>>
>> The limit is 0x280, not 0x290, or -- better -- you can use the byte at
>> 0x201 to get the size.
>>
>
> Not doing so would be wrong, in fact.

+	if (!real_mode_entry) {
+		unsigned long end;
+		/* clear value before header */
+		memset(real_mode, 0, 0x1f1);
+		/* clear value after setup_header  */
+		end = *((unsigned char *)real_mode + 0x201);
+		end += 0x202;
+		memset((unsigned char *)real_mode + end, 0, kern16_size - end);
+	}
