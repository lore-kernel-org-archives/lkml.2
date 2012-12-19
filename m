Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791Ab2LSDyM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 22:54:12 -0500
Received: from mail-bk0-f51.google.com ([209.85.214.51]:45589 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753923Ab2LSDyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 22:54:00 -0500
MIME-Version: 1.0
In-Reply-To: <20121215172805.GA20393@liondog.tnic>
References: <1355436141-8668-1-git-send-email-yinghai@kernel.org>
	<1355436141-8668-5-git-send-email-yinghai@kernel.org>
	<20121215172805.GA20393@liondog.tnic>
Date: Tue, 18 Dec 2012 19:53:59 -0800
X-Google-Sender-Auth: iNVM_Xv65mGrnr13ntXsWJ5HZ7o
Message-ID: <CAE9FiQVPpKR6M2ZxAa4X1n1d5AZ54HfLHkHqhg7OroBYaBDGfA@mail.gmail.com>
Subject: Re: [PATCH v6 04/27] x86, boot: Move lldt/ltr out of 64bit code section
From: Yinghai Lu <yinghai@kernel.org>
To: Borislav Petkov <bp@alien8.de>, Yinghai Lu <yinghai@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Zachary Amsden <zamsden@gmail.com>,
        Matt Fleming <matt.fleming@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 15, 2012 at 9:28 AM, Borislav Petkov <bp@alien8.de> wrote:
> On Thu, Dec 13, 2012 at 02:01:58PM -0800, Yinghai Lu wrote:
>> commit 08da5a2ca
>>
>>     x86_64: Early segment setup for VT
>>
>> add lldt/ltr to clean more segments.
>>
>> Those code are put in code64, and it is using gdt that is only
>> loaded from code32 path.
>>
>> That breaks booting with 64bit bootloader that does not go through
>> code32 path. It get at startup_64 directly,  and it has different
>> gdt.
>>
>> Move those lines into code32 after their gdt is loaded.
>
> Let me rewrite that commit message for ya, you tell me whether I got it
> right:
>
> "08da5a2ca479 ("x86_64: Early segment setup for VT") sets up LDT and TR
> into a valid state in order to speed up boot decompression under VT. The
> code which loads the GDT is executed in the 32-bit startup code while
> the above change in the 64-bit part.
>
> However, this breaks 64-bit bootloaders which jump straight to the
> 64-bit startup entry point and thus skip LDR and TR setup because they
> use a different GDT.
>
> Fix this by moving the LDT and TR setup to the 32-bit section."
>
> Is that correct?
yes

update to:

---
Subject: [PATCH] x86, boot: Move lldt/ltr out of 64bit code section

commit 08da5a2ca

    x86_64: Early segment setup for VT

sets up LDT and TR into a valid state in order to speed up boot
decompression under VT.

Those code are put in code64, and it is using GDT that is only
loaded from code32 path.

That breaks booting with 64bit bootloader that does not go through
code32 path and jump to startup_64 directly, and it has different
GDT.

Move those lines into code32 after their GDT is loaded.
---
