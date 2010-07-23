Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757989Ab0GWTWd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 15:22:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55850 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753177Ab0GWTWc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 15:22:32 -0400
MIME-Version: 1.0
In-Reply-To: <1279907297.24768.1678.camel@Joe-Laptop.home>
References: <20100722085202.GV17585@bicker> <201007231744.14922.br1@einfach.org> 
	<20100723095252.GA26313@bicker> <1279907297.24768.1678.camel@Joe-Laptop.home>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 23 Jul 2010 12:21:35 -0700
Message-ID: <AANLkTi==h70Cgj-SzRShVU1eJ1CGkL93-5XV55Ry6-eD@mail.gmail.com>
Subject: Re: [patch -next] ath5k: snprintf() returns largish values
To: Joe Perches <joe@perches.com>
Cc: Dan Carpenter <error27@gmail.com>, Bruno Randolf <br1@einfach.org>,
        "Luis R. Rodriguez" <lrodriguez@atheros.com>,
        Nick Kossifidis <mickflemm@gmail.com>,
        Jiri Slaby <jirislaby@gmail.com>, Bob Copeland <me@bobcopeland.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
        kernel-janitors <kernel-janitors@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 23, 2010 at 10:48 AM, Joe Perches <joe@perches.com> wrote:
>
> There are also many repeated uses of snprintf in kernel sources
> that could similarly be a problem.
>
>        bar += snprintf(foo + bar, ...)
>        bar += snprintf(foo + bar, ...)
> or
>        foo += snprintf(foo, ...)
>        foo += snprintf(foo, ...)

As long as the number of bytes is updated correctly, this won't be a
security problem, although it can cause a (single) warning. The kernel
vsnprintf does

        if (WARN_ON_ONCE((int) size < 0))
                return 0;

so if somebody overflows a buffer with multiple snprintf calls, it
will all be ok as long as the buffer size thing is updated the natural
way (possibly using pointer arithmetic, eg "end - bar").

                Linus
