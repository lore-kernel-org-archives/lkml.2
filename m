Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932631Ab3AJB0V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 20:26:21 -0500
Received: from mail-bk0-f47.google.com ([209.85.214.47]:55536 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932546Ab3AJB0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 20:26:20 -0500
MIME-Version: 1.0
In-Reply-To: <20130105132447.GD4297@x1.alien8.de>
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
	<1357260531-11115-21-git-send-email-yinghai@kernel.org>
	<20130104210114.GA11611@x1.alien8.de>
	<CAE9FiQV+AF=Ltz7os-f+Ksvt14VXqMvCR4neO07J+_ubpkzVgw@mail.gmail.com>
	<20130105132447.GD4297@x1.alien8.de>
Date: Wed, 9 Jan 2013 17:26:18 -0800
X-Google-Sender-Auth: FpFwYkZGZRkh7PWvIlPmUV8Aegk
Message-ID: <CAE9FiQUZcbysdtmdnbnrciqaYqfbX8EkS_-FX_w2zvEe=w33QQ@mail.gmail.com>
Subject: Re: [PATCH v7u1 20/31] x86, kexec: replace ident_mapping_init and init_level4_page
From: Yinghai Lu <yinghai@kernel.org>
To: Borislav Petkov <bp@alien8.de>, Yinghai Lu <yinghai@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 5, 2013 at 5:24 AM, Borislav Petkov <bp@alien8.de> wrote:
> On Fri, Jan 04, 2013 at 02:04:05PM -0800, Yinghai Lu wrote:
>> On Fri, Jan 4, 2013 at 1:01 PM, Borislav Petkov <bp@alien8.de> wrote:
>> > On Thu, Jan 03, 2013 at 04:48:40PM -0800, Yinghai Lu wrote:
>> >>  static int init_pgtable(struct kimage *image, unsigned long start_pgtable)
>> >>  {
>> >> +     struct x86_mapping_info info = {
>> >> +             .alloc_pgt_page = alloc_pgt_page,
>> >> +             .context        = image,
>> >> +             .pmd_flag       = __PAGE_KERNEL_LARGE_EXEC,
>> >> +     };
>> >
>> > This is leaving ->kernel_mapping uninitialized to contain a random,
>> > previous stack value. I don't think we want that.
>>
>> that should be initialized to false by default.
>
> So make it explicit. You can't possibly rely on what the stack contains
> when you allocate that struct there.

I should say:

that *is* initialized to false by default.

please check

http://stackoverflow.com/questions/10828294/c-and-c-partial-initialization-of-automatic-structure
