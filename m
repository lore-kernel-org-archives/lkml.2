Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531Ab1E0L7z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 07:59:55 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:53327 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332Ab1E0L7x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 07:59:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=o3J77sPU5CSGG0OU+EAYF/exMwJhacD4yly6mReg9bFaCRx58XELqzGQmS48OR9evi
         mphH2SmOmay5mie3qjWCWtBPMSOAHhxpduZAhOrBksDyejknnpe+uORLJ48c5LcM/R8o
         zR6UvyRd6s+SMtFBhdV+6AQX5ZxxcQgpeygyU=
MIME-Version: 1.0
In-Reply-To: <BANLkTinOQ_C_-Bix4FTQxHqP3aavmTRrzg@mail.gmail.com>
References: <alpine.LFD.2.02.1105262049180.3078@ionos>
	<4DDEC589.3010201@mit.edu>
	<20110527061208.GB9260@elte.hu>
	<BANLkTinOQ_C_-Bix4FTQxHqP3aavmTRrzg@mail.gmail.com>
Date: Fri, 27 May 2011 13:59:14 +0200
Message-ID: <BANLkTi=UEJqGxAs5p2tA=KzddNOrXCfXfQ@mail.gmail.com>
Subject: Re: [GIT pull] x86 vdso updates
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Andrew Lutomirski <luto@mit.edu>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 27, 2011 at 1:36 PM, Andrew Lutomirski <luto@mit.edu> wrote:
> On Fri, May 27, 2011 at 2:12 AM, Ingo Molnar <mingo@elte.hu> wrote:
>>
>> * Andy Lutomirski <luto@mit.edu> wrote:
>>
>>> On 05/26/2011 02:50 PM, Thomas Gleixner wrote:
>>> >       x86-64: Add time to vDSO
>>>
>>> And here's the glibc bug:
>>>
>>> http://sourceware.org/bugzilla/show_bug.cgi?id=12813
>>>
>>> Let the deprecation of the vsyscall page begin :)
>>
>> Yeah :-)
>>
>> On a related note, now that these bits are upstream, what are your
>> rough plans for doing the int81 vsyscall emulation patch?
>>
>> The int81 patch would actually be (much!) more important to the
>> average Linux user than getting rid of the vsyscall from static
>> binaries: the vsyscall is the last predictable executable address in
>> PIE daemons with a dangerous SYSENTER instruction in it ...
>>
>> I'd actually consider accelerating it into v2.6.40.
>
> Working on it slowly.  In principle I'm writing my thesis right now on
> things that have very little to do with software :)
>
> My rough plans for the near-term stuff are:
>
> 1. Move vvars out of the vsyscall page.  Otherwise we have at least
> one predictable syscall instruction every 1<<16 seconds because the
> time is executable.  It's prettier that way, too.
>
> 2. Remove the vsyscall64 sysctl.  That will reduce the number of
> vsyscalls that require the kernel's help to one.  (This is a bit
> unfortunate for UML users, but I'm not sure what to do about that.
> UML vgetcpu is already terminally broken.)

Can you please be a bit more precise on that?
When there is anything I can do, let me know...

-- 
Thanks,
//richard
