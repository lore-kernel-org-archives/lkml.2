Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757991Ab1DHVPg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 17:15:36 -0400
Received: from mail.aknet.ru ([78.158.192.28]:39757 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757878Ab1DHVPf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 17:15:35 -0400
Message-ID: <4D9F7AC5.5000304@aknet.ru>
Date: Sat, 09 Apr 2011 01:14:45 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Bryan Donlan <bdonlan@gmail.com>
CC: Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [path][rfc] add PR_DETACH prctl command
References: <4D6510A3.90905@aknet.ru> <BANLkTinfOKf+aSKy+Rj+2+v42JeGuzzrNg@mail.gmail.com> <4D9F6F6E.6040107@aknet.ru> <BANLkTimbB4rhbdTy07DuneSf=SydGYvbBA@mail.gmail.com>
In-Reply-To: <BANLkTimbB4rhbdTy07DuneSf=SydGYvbBA@mail.gmail.com>
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

09.04.2011 00:52, Bryan Donlan wrote:
> Still, you can workaround this by either:
Yes, sure.

> a) Load the vendor library via dlopen()
Too much to dlsym(), and by the way, what does this give?
I _have to_ init that lib early at bootup, so I don't see how
dlopen will help, could you clarify?

> b) Use a separate launcher executable to handle the fork-and-wait
Yes, that's certainly possible, except that I was trying the
semaphore instead of a signal, as in your example, but its
the same.

> Just kill(atoi(getenv("LAUNCHER_PID")), SIGUSR1) to detach. Much
> easier than doing some very racy things in the kernel, no? It's
> certainly more obvious that this ought to be correct in the face of
> races with its parent :)
But what races do you mean? Yes, the workaround is a
workaround, and it works. And is simpler to implement. :)
But what problems do you see with the PR_DETACH approach,
except for the bugs in my patch? :) I mean, the fact that
daemon() silently loses threads, sounds like a limitation,
after all.
