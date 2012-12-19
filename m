Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755158Ab2LSDpC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 22:45:02 -0500
Received: from mail-bk0-f47.google.com ([209.85.214.47]:56590 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754071Ab2LSDo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 22:44:56 -0500
MIME-Version: 1.0
In-Reply-To: <20121215170625.GA9875@liondog.tnic>
References: <1355436141-8668-1-git-send-email-yinghai@kernel.org>
	<1355436141-8668-4-git-send-email-yinghai@kernel.org>
	<20121215170625.GA9875@liondog.tnic>
Date: Tue, 18 Dec 2012 19:44:55 -0800
X-Google-Sender-Auth: kFAFCUAQWU-xbg3HjejJar1rQZI
Message-ID: <CAE9FiQUSoSvtFMMQt3eZkrXFCkzXhLu6GfqYMGNb3=uA052Axw@mail.gmail.com>
Subject: Re: [PATCH v6 03/27] x86, boot: move verify_cpu.S and no_longmode
 after 0x200
From: Yinghai Lu <yinghai@kernel.org>
To: Borislav Petkov <bp@alien8.de>, Yinghai Lu <yinghai@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 15, 2012 at 9:06 AM, Borislav Petkov <bp@alien8.de> wrote:
> On Thu, Dec 13, 2012 at 02:01:57PM -0800, Yinghai Lu wrote:
>> We are short of space before 0x200 that is entry for startup_64.
>
> And you're moving this down because of the couple of bytes the next
> patch is adding? If so, then explain that here.

better?

---
Subject: [PATCH] x86, boot: move verify_cpu.S and no_longmode down

We need to move some code with 32bit section in following patch:

   x86, boot: Move lldt/ltr out of 64bit code section

but that will push startup_64 down from 0x200.

According to hpa, we can not change startup_64 to other offset and
that become ABI now.

We could move function verify_cpu and no_longmode down, because
verify_cpu is used via function call and no_longmode will not
return.
---
