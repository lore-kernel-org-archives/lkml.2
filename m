Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674Ab0HVNIV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 09:08:21 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:64589 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604Ab0HVNIT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 09:08:19 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Changli Gao <xiaosuo@gmail.com>
Subject: Re: [PATCH] net: define __packed for the userspace code
Date: Sun, 22 Aug 2010 15:07:41 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc4-next-20100709+; KDE/4.5.0; x86_64; ; )
Cc: "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <1282475544-24708-1-git-send-email-xiaosuo@gmail.com> <AANLkTin1BOgHBc4sTwFAmQhKFNvZ+90herc4Dsh9P8y2@mail.gmail.com>
In-Reply-To: <AANLkTin1BOgHBc4sTwFAmQhKFNvZ+90herc4Dsh9P8y2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <201008221507.42023.arnd@arndb.de>
X-Provags-ID: V02:K0:5Mq1ayPeHex8f9nXBGYGMaPUfzryhLNy2woTSTBzGoB
 +3BWUpDZDEaye6tcou7Fj7Cnx9UQrCqGWlz0sI+3lO0Me/v1ju
 wE8IJhmaobVlH6v06i49Dotj7xFbf+fo+8NURLf+4lNakvzwru
 TK3DvhQkQSUYBkyrm8b6v0WA/UCT4FsplxZJ3eIxB83FbX9UDH
 i7Zdibhal0+T5wRU+jvVw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 22 August 2010 13:23:42 Changli Gao wrote:
> On Sun, Aug 22, 2010 at 7:12 PM, Changli Gao <xiaosuo@gmail.com> wrote:
> > This commit
> >
> >  commit bc10502dba37d3b210efd9f3867212298f13b78e
> >  Author: Eric Dumazet <eric.dumazet@gmail.com>
> >  Date:   Thu Jun 3 03:21:52 2010 -0700
> >
> >    net: use __packed annotation
> >
> > makes use of __packed in the userspace code. So we'd better define __packed
> > for the userspace code too.
> >
> 
> Oh, sorry. This patch can't work as include/linux/compiler.h isn't
> exported to the userspace. But where should we define __packed for the
> userspace code? include/linux/types.h?

I would try to avoid making those structures packed to start with.
>From what I can see, they structures annotated in the above commit
mostly don't even require explicit packing because they are already
packed. Not marking them packed makes the code portable to non-gcc
compilers.

	Arnd
