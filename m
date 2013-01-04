Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419Ab3ADWTV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 17:19:21 -0500
Received: from mail-bk0-f47.google.com ([209.85.214.47]:46819 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755205Ab3ADWTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 17:19:19 -0500
MIME-Version: 1.0
In-Reply-To: <20130104211913.GC24228@x1.alien8.de>
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
	<1357260531-11115-5-git-send-email-yinghai@kernel.org>
	<20130104211913.GC24228@x1.alien8.de>
Date: Fri, 4 Jan 2013 14:19:17 -0800
X-Google-Sender-Auth: e441KyYyhFbxo57ndBp0ZomAo-4
Message-ID: <CAE9FiQUHS3RY3OBtLhjzLjz7CBfx6jbQ6VN2T9W5KbLuCxwGww@mail.gmail.com>
Subject: Re: [PATCH v7u1 04/31] x86, 64bit, mm: add generic kernel/ident
 mapping helper
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

On Fri, Jan 4, 2013 at 1:19 PM, Borislav Petkov <bp@alien8.de> wrote:
> On Thu, Jan 03, 2013 at 04:48:24PM -0800, Yinghai Lu wrote:
>> +int kernel_mapping_init(pgd_t *pgd_page, unsigned long addr, unsigned long end)
>> +{
>> +     struct x86_mapping_info info = {
>> +             .alloc_pgt_page = alloc_pgt_page,
>> +             .pmd_flag       = __PAGE_KERNEL_LARGE,
>> +             .kernel_mapping = true,
>> +     };
>> +
>> +     return kernel_ident_mapping_init(&info, pgd_page, addr, end);
>
> This patch looks good so far except this:
> kernel_ident_mapping_init says it initializes ident mapping but
> this is wrong and the type of mapping is actually controlled by
> info.kernel_mapping.

it is not wrong, and it could do two things.
kernel_mapping
ident_mapping


>
> So this function which gets &info, etc should be called
> kernel_mapping_init, AFAICT. And wrt the one wrapping
> kernel_ident_mapping_init, I can't seem to find where it is called.
> What's up?

this kernel_mapping_init is for -v8 ..., should be dropped if -v7 is
used at last.
