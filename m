Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325Ab3ADWEJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 17:04:09 -0500
Received: from mail-bk0-f45.google.com ([209.85.214.45]:40076 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754682Ab3ADWEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 17:04:08 -0500
MIME-Version: 1.0
In-Reply-To: <20130104210114.GA11611@x1.alien8.de>
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
	<1357260531-11115-21-git-send-email-yinghai@kernel.org>
	<20130104210114.GA11611@x1.alien8.de>
Date: Fri, 4 Jan 2013 14:04:05 -0800
X-Google-Sender-Auth: I_YO960kPOmSDrq1XUFSkfSNT_8
Message-ID: <CAE9FiQV+AF=Ltz7os-f+Ksvt14VXqMvCR4neO07J+_ubpkzVgw@mail.gmail.com>
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

On Fri, Jan 4, 2013 at 1:01 PM, Borislav Petkov <bp@alien8.de> wrote:
> On Thu, Jan 03, 2013 at 04:48:40PM -0800, Yinghai Lu wrote:
>>  static int init_pgtable(struct kimage *image, unsigned long start_pgtable)
>>  {
>> +     struct x86_mapping_info info = {
>> +             .alloc_pgt_page = alloc_pgt_page,
>> +             .context        = image,
>> +             .pmd_flag       = __PAGE_KERNEL_LARGE_EXEC,
>> +     };
>
> This is leaving ->kernel_mapping uninitialized to contain a random,
> previous stack value. I don't think we want that.

that should be initialized to false by default.
