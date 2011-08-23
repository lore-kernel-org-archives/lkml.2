Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492Ab1HWQ62 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 12:58:28 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47683 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751259Ab1HWQ6X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 12:58:23 -0400
Message-ID: <4E53DC2A.3020004@nod.at>
Date: Tue, 23 Aug 2011 18:58:18 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Borislav Petkov <bp@amd64.org>, Andrew Lutomirski <luto@mit.edu>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        "user-mode-linux-devel@lists.sourceforge.net" 
	<user-mode-linux-devel@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>
Subject: Re: [uml-devel] SYSCALL, ptrace and syscall restart breakages (Re:
 [RFC] weird crap with vdso on uml/i386)
References: <4E52EF2A.8060608@zytor.com> <CA+55aFx9zRTD72jaztLvyB68ejHcqM3Z3=b+6W64opfYu3ANjA@mail.gmail.com> <20110823010146.GY2203@ZenIV.linux.org.uk> <20110823011312.GZ2203@ZenIV.linux.org.uk> <20110823021717.GA2203@ZenIV.linux.org.uk> <20110823061531.GC2203@ZenIV.linux.org.uk> <CA+55aFzUAuPEwcvVvuXooWMT6XpDuOjEHi-Ab+SOhZVjfbVYpA@mail.gmail.com> <CAObL_7F-E2y_cd1MK4ayBx_CqszrewSrBt6V7=ndVuBQrrmTKQ@mail.gmail.com> <20110823162251.GC13138@aftab> <CA+55aFxJF88EJ=WhPq08j4+REBgpvVHVwbg5BR05DD+exRyp8A@mail.gmail.com> <20110823165320.GG2203@ZenIV.linux.org.uk>
In-Reply-To: <20110823165320.GG2203@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 23.08.2011 18:53, schrieb Al Viro:
> On Tue, Aug 23, 2011 at 09:29:29AM -0700, Linus Torvalds wrote:
>
>> Oh yes.
>>
>> System call performance is *important*. And x86 is *important*.
>>
>> UML? In comparison, not that important.
>>
>> So quite frankly, if this is purely an UML issue (and unless we're
>> missing something else, that's what it looks like, despite all the
>> confusion we've had so far), then if we have a choice between "remove
>> syscall instruction" and "remove UML", then ...
>
> Agreed.  Note, BTW, that UML has perfectly usable workaround for 99% of
> that - don't tell the binaries it has *any* vdso in such cases.  And
> "remove UML" turns into "remove support under UML for 32bit binaries
> that go out of their way to do SYSCALL directly, which wouldn't work
> on native 32bit", which is really a no-brainer.

What about this hack/solution?
While booting UML can check whether the host's vDSO contains
a SYSCALL instruction.
If so, UML will not make the host's vDSO available to it's
processes...

Thanks,
//richard
