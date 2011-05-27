Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070Ab1E0PGM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 11:06:12 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:58416 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720Ab1E0PGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 11:06:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=DJe2q7GDwPouFgQXRtlTeJFNPP9RH8iHJnp671oGeBl+U9iH6l4NgEAR7WP5KON7NZ
         F8ES3gjVWwJlGE+vkzkrZeaATQZ6fQGh6C2203Qc8lBA37ee9uMlIwOL/eFzz0q3VWGJ
         IctkL7SP4s19gZhAo8/xhSkHUobhBtf1GMdfE=
MIME-Version: 1.0
In-Reply-To: <BANLkTindgVfP530GDGvonp7iXE=hW833gg@mail.gmail.com>
References: <alpine.LFD.2.02.1105262049180.3078@ionos> <4DDEC589.3010201@mit.edu>
 <20110527061208.GB9260@elte.hu> <BANLkTinOQ_C_-Bix4FTQxHqP3aavmTRrzg@mail.gmail.com>
 <BANLkTi=UEJqGxAs5p2tA=KzddNOrXCfXfQ@mail.gmail.com> <BANLkTik7H=HyjzzCf4pYK-K7rx23DGHh8g@mail.gmail.com>
 <BANLkTindgVfP530GDGvonp7iXE=hW833gg@mail.gmail.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Fri, 27 May 2011 11:05:51 -0400
X-Google-Sender-Auth: 47H8PgyV6OPnIKbxw3eVPcQrgA0
Message-ID: <BANLkTimdne9WVDfooOGcVDtAaG=G4T7uTA@mail.gmail.com>
Subject: Re: [GIT pull] x86 vdso updates
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 27, 2011 at 10:59 AM, richard -rw- weinberger
<richard.weinberger@gmail.com> wrote:
> On Fri, May 27, 2011 at 2:10 PM, Andrew Lutomirski <luto@mit.edu> wrote:
>> On Fri, May 27, 2011 at 7:59 AM, richard -rw- weinberger
>> If this is considered enough of a regression, then I guess we can
>> leave vsyscall64 around for awhile, but it will require extra work in
>> the soon-to-be syscall emulation hack to make sure that UML can still
>> trap the syscall.
>
> As long the time within UML is synchronous with the host everything is
> fine, right?

I think so.  I haven't used UML in a long time.

> So, as _last_ choice we could disable the ability to change the time within UML.
>
> IMHO it's not a big deal when getcpu() returns a wrong CPU layout on UML.
>
>> The real solution is to fix glibc to use the vDSO which should avoid
>> this problem entirely.
>
> Is this "bug" known? And the biggest question, will Ulrich fix it some day?

I added the bit about UML to
http://sourceware.org/bugzilla/show_bug.cgi?id=12813.  I don't know
what Ulrich will do.

--Andy
