Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933912Ab1ETH4E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 03:56:04 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:44656 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932157Ab1ETH4D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 03:56:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=THOlIxdx7pNBJjeJOrK1J35Hzp/HF7UMS+HUa8VmGsByh0dzV34RZmROKK1mGU00bo
         b6ZEca44z7je0ljNzUiaNzk73RWYVPbwGbb2Ccs+bilMZ3O4BE7NY3KsFZIVVa1rLkIC
         rk7YcBLdjhz9q8rcVpvhPBYFoniaVzgvfJiTY=
MIME-Version: 1.0
In-Reply-To: <201105200937.15322.toralf.foerster@gmx.de>
References: <201105191526.31904.toralf.foerster@gmx.de>
	<201105192218.18261.toralf.foerster@gmx.de>
	<20110519204342.GA10792@home.goodmis.org>
	<201105200937.15322.toralf.foerster@gmx.de>
Date: Fri, 20 May 2011 09:56:02 +0200
Message-ID: <BANLkTik0oz6ppJvRpufaaiBL1pqcAxNHuA@mail.gmail.com>
Subject: Re: kernel 2.6.39 (user mode linux) crashes (2.6.38 works fine)
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: =?ISO-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        user-mode-linux-devel@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/20 Toralf Förster <toralf.foerster@gmx.de>:
> ...
> Kernel panic - not syncing: Kernel mode fault at addr 0x0, ip 0x80a9f6b

Looks like a NULL-pointer bug.
What code is at address 80a9f6b?
Use "objdump -d -S | less" to find it.
Please note, kernel binary and log message have to match!

> The file /var/log/messages of the UML says :
>
> 2011-05-20T09:33:03.455+02:00 n22_uml kernel: ------------[ cut here ]------------
> 2011-05-20T09:33:03.455+02:00 n22_uml kernel: WARNING: at kernel/futex.c:789 wake_futex+0x28/0x60()

Is this really 2.6.39?
Line 789 contains no WARN*().
http://lxr.linux.no/#linux+v2.6.39/kernel/futex.c#L789

-- 
Thanks,
//richard
