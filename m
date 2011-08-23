Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745Ab1HWU4f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 16:56:35 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:35364 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534Ab1HWU43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 16:56:29 -0400
Date: Tue, 23 Aug 2011 22:56:16 +0200
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@amd64.org>, Andrew Lutomirski <luto@mit.edu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@kernel.org>,
        "user-mode-linux-devel@lists.sourceforge.net" 
	<user-mode-linux-devel@lists.sourceforge.net>,
        Richard Weinberger <richard@nod.at>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>
Subject: Re: [uml-devel] SYSCALL, ptrace and syscall restart breakages (Re:
 [RFC] weird crap with vdso on uml/i386)
Message-ID: <20110823205616.GA15295@aftab>
References: <4E52EF2A.8060608@zytor.com>
 <CA+55aFx9zRTD72jaztLvyB68ejHcqM3Z3=b+6W64opfYu3ANjA@mail.gmail.com>
 <20110823010146.GY2203@ZenIV.linux.org.uk>
 <20110823011312.GZ2203@ZenIV.linux.org.uk>
 <20110823021717.GA2203@ZenIV.linux.org.uk>
 <20110823061531.GC2203@ZenIV.linux.org.uk>
 <CA+55aFzUAuPEwcvVvuXooWMT6XpDuOjEHi-Ab+SOhZVjfbVYpA@mail.gmail.com>
 <CAObL_7F-E2y_cd1MK4ayBx_CqszrewSrBt6V7=ndVuBQrrmTKQ@mail.gmail.com>
 <20110823162251.GC13138@aftab>
 <4E53FC6E.1030807@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E53FC6E.1030807@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 23, 2011 at 03:15:58PM -0400, H. Peter Anvin wrote:
> Right, but if you had said the difference had disappeared on current AMD
> silicon it would be much less of an issue.  That's why I wanted to find
> that bit out from you.

Yeah, I dug this out in the APM, btw.

But no, I don't think the difference has disappeared - to the contrary,
AFAICT, the intention is for SYSCALL to be the fastest way to do
syscalls on x86 due to diminished number of segment checks etc. INT80
is legacy, slower, etc. I believe Andy measured a similar situation on
Sandy Bridge with SYSCALL having latencies in the tens of nsecs range
and INT80 being much slower. Ingo also measured a similar situation
where the latency gap between the two on Intel is even bigger.

So, the only problem left now is what we're going
to do with cases similar to what Al conjured up:
http://marc.info/?l=linux-kernel&m=131412271112461&w=2

I don't know, maybe the most cowardly approach is to issue a warning and
shrug with the shoulders, or do some asm magic... Also, do we care at
all, how relevant is a case like that?

Hmmm.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
