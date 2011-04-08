Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757887Ab1DHU1O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 16:27:14 -0400
Received: from mail.aknet.ru ([78.158.192.28]:40468 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757780Ab1DHU1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 16:27:13 -0400
Message-ID: <4D9F6F6E.6040107@aknet.ru>
Date: Sat, 09 Apr 2011 00:26:22 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Bryan Donlan <bdonlan@gmail.com>
CC: Linux kernel <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [path][rfc] add PR_DETACH prctl command
References: <4D6510A3.90905@aknet.ru> <BANLkTinfOKf+aSKy+Rj+2+v42JeGuzzrNg@mail.gmail.com>
In-Reply-To: <BANLkTinfOKf+aSKy+Rj+2+v42JeGuzzrNg@mail.gmail.com>
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

08.04.2011 22:13, Bryan Donlan wrote:
> I can't comment on the patch itself, but, if your application knows it
> might have to daemonize after spinning up threads, why not simply
> fork() immediately on startup, and have the parent simply wait forever
> for either the child to die or for a daemonize signal from the child?
> If done early enough it shouldn't tie up too much memory, and it
> wouldn't require any of these invasive kernel changes. As an added
> bonus, it's portable to all unixen :)
Yes, thats almost always true. Except when you deal with
the vendor-provided poorly-coded drivers and libs, where
you get the drivers initialized only via the lib. And the
initialization process must be finished before the boot-up
can continue, but that's not the whole story: only the
process that initialized that lib, can then work with it.
And of course that lib creates a dozen of threads...
OK, you've got the idea. :)
But anyway. Yes, not everyone have to deal with such a
nightmare, this is very rare. But people being confused
by the fact that daemon() silently loses threads, are not
rare. So I just wonder: even if the workaround is simple,
why searching for the workaround at all? If you need
2 syscalls to detach from parent, and you loose the threads
in a process, then why not to have a single call, that
detaches without loosing threads?
But in any case, I am mostly inclinced to leave that patch
for my project only.
