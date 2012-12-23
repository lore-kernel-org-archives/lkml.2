Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389Ab2LWSAb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2012 13:00:31 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39438 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599Ab2LWSA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2012 13:00:28 -0500
MIME-Version: 1.0
In-Reply-To: <6214ad82-5b7e-47f2-a9c1-98972bdee517@email.android.com>
References: <1355814959-10573-1-git-send-email-yinghai@kernel.org>
	<20121222024225.GG3468@phenom.dumpdata.com>
	<eee81bb9-f11b-4ff8-8a84-72f122766fd8@email.android.com>
	<20121222132419.GB2936@phenom.dumpdata.com>
	<CAE9FiQV5QqONiTdnHzsjVRTbnEfyHEE3s=-=+a49F2a5se7K+A@mail.gmail.com>
	<6214ad82-5b7e-47f2-a9c1-98972bdee517@email.android.com>
Date: Sun, 23 Dec 2012 10:00:26 -0800
X-Google-Sender-Auth: YfbbXbwaxl2xxiJ-jF0SMorz70c
Message-ID: <CAE9FiQV-7_wz1jCZh3qDGt6Wq_JN6b1oAyjj3+goCPFnYZ+q9Q@mail.gmail.com>
Subject: Re: [PATCH v7 00/27] x86, boot, 64bit: Add support for loading
 ramdisk and bzImage above 4G
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 23, 2012 at 6:33 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> Explanation please?
>

you have following change in the patch

        /* Finally jump to run C code and to be on real kernel address
         * Since we are running on identity-mapped space we have to jump
         * to the full 64bit address, this is only possible as indirect
         * jump.  In addition we need to ensure %cs is set so we make this
-        * a far return.
+        * a far jump.
         */
-       movq    initial_code(%rip),%rax
        pushq   $0              # fake return address to stop unwinder
-       pushq   $__KERNEL_CS    # set correct cs
-       pushq   %rax            # target address in negative space
-       lretq
+       /* gas 2.22 is buggy and mis-assembles ljmpq */
+       rex64 ljmp *initial_code(%rip)

 #ifdef CONFIG_HOTPLUG_CPU
 /*

remove that change, AMD systems works again.

Yinghai
