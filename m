Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534Ab0KMNK2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 08:10:28 -0500
Received: from smtp3-g21.free.fr ([212.27.42.3]:35707 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753457Ab0KMNK0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 08:10:26 -0500
Message-ID: <105301cb8333$87a9bd10$f9b5a8c0@pii350>
From: "Gilles Espinasse" <g.esp@free.fr>
To: "Ingo Molnar" <mingo@elte.hu>, "Willy Tarreau" <w@1wt.eu>
Cc: "Marcus Meissner" <meissner@suse.de>, <security@kernel.org>,
        <mort@sgi.com>, "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
        <fweisbec@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        <linux-kernel@vger.kernel.org>, <jason.wessel@windriver.com>,
        <tj@kernel.org>, <Andrew@zimbra8-e1.priv.proxad.net>,
        <"Morton <"@zimbra8-e1.priv.proxad.net>
References: <20101104114648.GA23381@elte.hu> <20101104122906.GH25118@suse.de> <20101104135802.GA31416@elte.hu> <20101104141104.GA31753@elte.hu> <20101104143322.GL25118@suse.de> <20101104190804.GA16099@elte.hu> <20101104212920.GA31256@1wt.eu> <20101104215157.GA25128@ <20101107090805.GA27983@elte.hu>
Subject: Re: [Security] [PATCH] kernel: make /proc/kallsyms mode 400 to reduce ease of attacking
Date: Sat, 13 Nov 2010 14:06:00 +0100
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.2001
x-mimeole: Produced By Microsoft MimeOLE V6.00.2800.2001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- Original Message ----- 
From: "Ingo Molnar" <mingo@elte.hu>
To: "Willy Tarreau" <w@1wt.eu>
Cc: "Marcus Meissner" <meissner@suse.de>; <security@kernel.org>;
<mort@sgi.com>; "Peter Zijlstra" <a.p.zijlstra@chello.nl>;
<fweisbec@gmail.com>; "H. Peter Anvin" <hpa@zytor.com>;
<linux-kernel@vger.kernel.org>; <jason.wessel@windriver.com>;
<tj@kernel.org>; <Andrew@zimbra8-e1.priv.proxad.net>; <"Morton
<"@zimbra8-e1.priv.proxad.net>
Sent: Sunday, November 07, 2010 10:08 AM
Subject: Re: [Security] [PATCH] kernel: make /proc/kallsyms mode 400 to
reduce ease of attacking


>
> * Ingo Molnar <mingo@elte.hu> wrote:
>
> > If your claim that 'kernel version is needed at many places' is true
then why am i
> > seeing this on a pretty general distro box bootup:
> >
> >  [root@aldebaran ~]# uname -a
> >  Linux aldebaran 2.6.99-tip-01574-g6ba54c9-dirty #1 SMP Sun Nov 7
10:24:38 CET 2010 x86_64 x86_64 x86_64 GNU/Linux
> >
> > ?
> >
> > Yes, some user-space might be unhappy if we set the version _back_ to
say 2.4.0,
> > but we could (as the patch below) fuzz up the version information from
> > unprivileged attackers easily.
>
> Btw., with an 'exploit honeypot' and 'version fuzzing' the uname output
would look
> like this to an unprivileged user:
>
>   $ uname -a
>   Linux aldebaran 2.6.99 x86_64 x86_64 x86_64 GNU/Linux
>
> [ we wouldnt want to include the date or the SHA1 of the kernel,
obviously. ]
>
> And it would look like this to root:
>
>   # uname -a
>   Linux aldebaran 2.6.37-tip-01574-g6ba54c9-dirty #1 SMP Sun Nov 7
10:24:38 CET 2010 x86_64 x86_64 x86_64 GNU/Linux
>
> Ingo

A bit late comment
gesp@a7n8x-e:~$ strings /lib/modules/*/kernel/drivers/scsi/in2000.ko | grep
2010
Sep 16 2010
gesp@a7n8x-e:~$ strings /lib/modules/*/kernel/drivers/char/nozomi.ko | grep
2010
Nozomi driver 2.1d (build date: Sep 16 2010 19:01:27)
gesp@a7n8x-e:~$ uname -a
Linux a7n8x-e 2.6.26-2-686 #1 SMP Thu Sep 16 19:35:51 UTC 2010 i686
GNU/Linux

Should it not be considered before to remove __DATE__ and __TIME__ from
module code?
That would have too the good effect that everyone that compile same code
with same compiler get exactly same file.

Gilles

