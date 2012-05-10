Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761421Ab2EJSv7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 14:51:59 -0400
Received: from isrv.corpit.ru ([86.62.121.231]:45608 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760473Ab2EJSv4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 14:51:56 -0400
Message-ID: <4FAC0E49.6050004@msgid.tls.msk.ru>
Date: Thu, 10 May 2012 22:51:53 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.3) Gecko/20120329 Icedove/10.0.3
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Jan Kiszka <jan.kiszka@siemens.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anthony Liguori <aliguori@us.ibm.com>, Kevin Wolf <kwolf@redhat.com>
Subject: Re: [PATCH v2] compat: Fix RT signal mask corruption via sigprocmask
References: <4FAAEB37.1080001@siemens.com> <CA+55aFz-z6F=ynvTZp2xrSyq+Ar7huT92_S9e8Wuxepyppq5ZQ@mail.gmail.com> <4FABBCE4.3050503@siemens.com> <CA+55aFyOsPY-RNwedb3NnbKbj=iAc7L6YuSSEZYy5_Sczmqd4A@mail.gmail.com> <CA+55aFyr4_3MN4yZdNMnDr+nKm+VTONiP6SQnAGXoaQ1egr7zQ@mail.gmail.com>
In-Reply-To: <CA+55aFyr4_3MN4yZdNMnDr+nKm+VTONiP6SQnAGXoaQ1egr7zQ@mail.gmail.com>
X-Enigmail-Version: 1.4
OpenPGP: id=804465C5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10.05.2012 19:58, Linus Torvalds wrote:
> On Thu, May 10, 2012 at 8:44 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> I think I'll just edit your patch directly, no need to send me a new version.
> 
> Ok, just FYI, this is the incremental diff I ended up with. I'll
> commit it as this, but I'm sending it out for people to verify before
> I do. Although just from looking at the code generation, it really
> does just change those four instructions that do a mask to a single
> 'movl', so I think it's pretty safe even though I haven't tested it.

I tested the changes (from Jan and Linus's patches) and
the result a) looks sane, and b) actually works and fixes
our long-standing issues.

So you can add my

Tested-By: Michael Tokarev <mjt@tls.msk.ru>

or, if you prefer,

Signed-off-By: Michael Tokarev <mjt@tls.msk.ru>

for the combined patch.

Thank you for the excellent catch Jan!

/mjt
