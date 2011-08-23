Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755783Ab1HWXFv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 19:05:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50968 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754712Ab1HWXFo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 19:05:44 -0400
Message-ID: <4E54320D.30009@zytor.com>
Date: Tue, 23 Aug 2011 16:04:45 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Andrew Lutomirski <luto@mit.edu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@kernel.org>,
        "user-mode-linux-devel@lists.sourceforge.net" 
	<user-mode-linux-devel@lists.sourceforge.net>,
        Richard Weinberger <richard@nod.at>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>
Subject: Re: [uml-devel] SYSCALL, ptrace and syscall restart breakages (Re:
 [RFC] weird crap with vdso on uml/i386)
References: <20110823010146.GY2203@ZenIV.linux.org.uk> <20110823011312.GZ2203@ZenIV.linux.org.uk> <20110823021717.GA2203@ZenIV.linux.org.uk> <20110823061531.GC2203@ZenIV.linux.org.uk> <CA+55aFzUAuPEwcvVvuXooWMT6XpDuOjEHi-Ab+SOhZVjfbVYpA@mail.gmail.com> <CAObL_7F-E2y_cd1MK4ayBx_CqszrewSrBt6V7=ndVuBQrrmTKQ@mail.gmail.com> <20110823162251.GC13138@aftab> <4E53FC6E.1030807@zytor.com> <20110823205616.GA15295@aftab> <4E54163B.6080205@zytor.com> <20110823211047.GC15295@aftab>
In-Reply-To: <20110823211047.GC15295@aftab>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2011 02:10 PM, Borislav Petkov wrote:
> On Tue, Aug 23, 2011 at 05:06:03PM -0400, H. Peter Anvin wrote:
>> On 08/23/2011 01:56 PM, Borislav Petkov wrote:
>>>
>>> But no, I don't think the difference has disappeared - to the contrary,
>>> AFAICT, the intention is for SYSCALL to be the fastest way to do
>>> syscalls on x86 due to diminished number of segment checks etc. INT80
>>> is legacy, slower, etc. I believe Andy measured a similar situation on
>>> Sandy Bridge with SYSCALL having latencies in the tens of nsecs range
>>> and INT80 being much slower. Ingo also measured a similar situation
>>> where the latency gap between the two on Intel is even bigger.
>>>
>>
>> Sandy Bridge doesn't have SYSCALL32 at all.  It has SYSENTER and SYSCALL64.
> 
> Yeah, I was talking about SYSCALL in general.
> 

Right, but there could be an arbitrary chasm between SYSCALL32 and
SYSCALL64.

	-hpa

