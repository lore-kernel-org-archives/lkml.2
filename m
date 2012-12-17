Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023Ab2LQJEs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 04:04:48 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:37756 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682Ab2LQJEq convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:13:1>);
	Mon, 17 Dec 2012 04:04:46 -0500
Message-Id: <50CEEE3302000078000B0AC0@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.1 
Date: Mon, 17 Dec 2012 09:04:35 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Matt Fleming" <matt.fleming@intel.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Markus Trippelsdorf" <markus@trippelsdorf.de>
Cc: "Arnd Bergmann" <arnd@arndb.de>, "Ingo Molnar" <mingo@elte.hu>,
        "Michael Kerrisk" <mtk.manpages@gmail.com>,
        "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "Dave Jones" <davej@redhat.com>, "David Howells" <dhowells@redhat.com>,
        "Grant Likely" <grant.likely@secretlab.ca>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] x86/uapi for 3.8
References: <201212122211.qBCMBRxl027895@terminus.zytor.com>
 <23916.1355356085@warthog.procyon.org.uk>
 <CA+55aFwBh3SY-K_dqdjpqyiBE+_PzbjMc=Qnt-QU9LNaK325TA@mail.gmail.com>
 <21507.1355528749@warthog.procyon.org.uk>
 <CA+55aFw34Nwi_aNjN-jm4SHkvT5659_aNVVmvARTCg5=9K0cZg@mail.gmail.com>
 <CA+55aFytC4xktWHAfQ96cdbt5nu+qbYytUGky8wWAkxZE=J0kw@mail.gmail.com>
 <CA+55aFyd5O_GyB_+BgHVYNLW-DV8xMQ9LOgPU34AtCqVvzfDaQ@mail.gmail.com>
 <20121215163323.GA229@x4>
 <CA+55aFz3iLPT3wzbU_Nhh4ft1eNQcd4WdQXsgXnKBs6vG9a_Uw@mail.gmail.com>
In-Reply-To: <CA+55aFz3iLPT3wzbU_Nhh4ft1eNQcd4WdQXsgXnKBs6vG9a_Uw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 15.12.12 at 19:35, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> On Sat, Dec 15, 2012 at 8:33 AM, Markus Trippelsdorf
> <markus@trippelsdorf.de> wrote:
>> On 2012.12.14 at 17:47 -0800, Linus Torvalds wrote:
>>>
>>> Ho humm. Anybody else see anything strange?
>>
>> Yes. I'm seeing a BUG early during boot on my machine (RIP=NULL):
>>
>>  BUG: unable to handle kernel NULL pointer dereference at           (null)
>>
>> This is caused by commit 53b87cf088e2 ("x86, mm: Include the
>> entire kernel memory map in trampoline_pgd")
> 
> Hmm. That reverts cleanly, and the result boots fine for me. And the
> commit looks like exactly the kind of thing that could result in
> problems with exactly the right memory layout, so it could explain why
> the bisect failed and some kernels randomly worked for me and others
> didn't.
> 
> So this at least looks like a very possible candidate.
> 
> Does anybody have an explanation for the problem?

How about this being caused by using the same lower level
page table entries that swapper_pg_dir uses, namely including
the _PAGE_GLOBAL bits? efi_call_virt_{pre,epi}log() only write
CR3 (see 185034e72d591f9465e5e18f937ed642e7ea0070), but
would need to also flip CR4.PGE afaict.

Jan

