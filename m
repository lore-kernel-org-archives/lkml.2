Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab1DSQNv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 12:13:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7997 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752205Ab1DSQNv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 12:13:51 -0400
Date: Tue, 19 Apr 2011 18:13:01 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Stas Sergeev <stsp@aknet.ru>, Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [path][rfc] add PR_DETACH prctl command [3/3]
Message-ID: <20110419161301.GA23914@redhat.com>
References: <4D99D6E6.4070008@aknet.ru> <20110404160351.GA23655@redhat.com> <4D9A24A0.5050105@aknet.ru> <20110405151549.GB17490@redhat.com> <4D9B4265.6080403@aknet.ru> <20110405164557.GA23248@redhat.com> <4DADA22A.1010205@aknet.ru> <20110419155830.7ad33312@lxorguk.ukuu.org.uk> <4DADA581.9060700@aknet.ru> <20110419165429.71cb1508@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110419165429.71cb1508@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19, Alan Cox wrote:
>
> > The use case is to daemonize the process with threads.
> > You first need to detach it from its parent, then use TIOCNOTTY
> > ioctl to detach from the tty (TIOCNOTTY_GRP doesn't seem
> > to exist too, though, but might be easy to implement).
> > There are a few workarounds to that that I am aware of,
> > but what exactly interfaces do you have in mind? I have
> > found nothing that allows to do the same without a workarounds
> > like this:
> > https://lkml.org/lkml/2011/4/8/278
> > The current way of detaching, which is a fork/exit combo,
> > loses all threads, so, when you call daemon() and you had
> > threads, you are a toast.
>
> Yes - you need to detach then create the threads.
>
> The reason I ask is you appear to add overhead to various hot paths

... and complicates this code.

> and
> you add 48 bytes to each task struct if I read the code right. Thats half
> a megabyte on a server running a pile of java gunge !

... to add the non-portable (and _imho_ unneeded) feauture.

IOW, personally I do not like this change in any case. But I am not
going to argue if someone acks this new feauture.




I'll try to check these patches from the correctness pov tomorrow,
but to be honest I hope someone will nack them before I start ;)

Oleg.

