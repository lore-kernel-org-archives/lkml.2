Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757969Ab1DHV0l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 17:26:41 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46304 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735Ab1DHV0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 17:26:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=QouvNVcm/KjWAm49Wln7IdlnfQZah2EYOSmaQjGC9EY/pIZF3AzDTxEfeQ/7Eq3KYc
         wXoRst8ddZGGcfVxWRqHYqH3dJBHUI5F+5itsbh3LuEuKjlJzS29AO4/NRKumFMSoRZO
         0ViBwijrseNIZVpERRtGrjlWQBdDIyn+fHmO4=
MIME-Version: 1.0
In-Reply-To: <4D9F7AC5.5000304@aknet.ru>
References: <4D6510A3.90905@aknet.ru> <BANLkTinfOKf+aSKy+Rj+2+v42JeGuzzrNg@mail.gmail.com>
 <4D9F6F6E.6040107@aknet.ru> <BANLkTimbB4rhbdTy07DuneSf=SydGYvbBA@mail.gmail.com>
 <4D9F7AC5.5000304@aknet.ru>
From: Bryan Donlan <bdonlan@gmail.com>
Date: Fri, 8 Apr 2011 17:25:56 -0400
Message-ID: <BANLkTi=C46U0Qv7HDPNs3=wMPkWq0G9zCw@mail.gmail.com>
Subject: Re: [path][rfc] add PR_DETACH prctl command
To: Stas Sergeev <stsp@aknet.ru>
Cc: Linux kernel <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset=KOI8-R
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/8 Stas Sergeev <stsp@aknet.ru>:
> 09.04.2011 00:52, Bryan Donlan wrote:
>>
>> Still, you can workaround this by either:
>
> Yes, sure.
>
>> a) Load the vendor library via dlopen()
>
> Too much to dlsym(), and by the way, what does this give?
> I _have to_ init that lib early at bootup, so I don't see how
> dlopen will help, could you clarify?

Using dlopen will allow you to perform the fork() prior to running the
library's initialization code.

>> Just kill(atoi(getenv("LAUNCHER_PID")), SIGUSR1) to detach. Much
>> easier than doing some very racy things in the kernel, no? It's
>> certainly more obvious that this ought to be correct in the face of
>> races with its parent :)
>
> But what races do you mean? Yes, the workaround is a
> workaround, and it works. And is simpler to implement. :)
> But what problems do you see with the PR_DETACH approach,
> except for the bugs in my patch? :) I mean, the fact that
> daemon() silently loses threads, sounds like a limitation,
> after all.

As I said, I can't comment on the patch - I'm not familiar with that
part of the kernel, so I don't know what kind of races may be lurking.
But based on Oleg's comments, it seems clear to me that implementing
your PR_DETACH is quite a complex thing to be doing. It is true that
being able to daemonize() without losing threads would be a nice thing
to have; I just have my doubts that it's worth the potential bugs that
such a change might introduce, when it's only needed in a somewhat
rare case, and when perfectly good workarounds exist in userspace.
