Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696Ab2D2Hp0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 03:45:26 -0400
Received: from isrv.corpit.ru ([86.62.121.231]:59902 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752492Ab2D2HpZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 03:45:25 -0400
Message-ID: <4F9CF191.5020607@msgid.tls.msk.ru>
Date: Sun, 29 Apr 2012 11:45:21 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.3) Gecko/20120329 Icedove/10.0.3
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Thomas Meyer <thomas@m3y3r.de>,
        David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        autofs@vger.kernel.org, raven@themaw.net, stable@kernel.org
Subject: Re: [PATCH v2] Introduce a version6 of autofs interface, to fix design
 error.
References: <20120427.151433.1007849975903946491.davem@davemloft.net> <20120427.151651.2274764174217164454.davem@davemloft.net> <CA+55aFzPbAprx-iT0TYh24uS7+JnL92mbTg_js6Cd_O0q+Dvmw@mail.gmail.com> <20120427.152404.2292425516870981391.davem@davemloft.net> <CA+55aFzGO+PHmjjVgxnYawbB-wFAqHtkh19vTv1AwQNpc9MsWg@mail.gmail.com> <20120427234215.079a1565@pyramind.ukuu.org.uk> <CA+55aFxq4TunFa8mqJk5MHfvvFSg7Dr54acW7Cnqc5amOPdqrg@mail.gmail.com> <CA+55aFzdEcfXVXXqCumVJo=9+fK+1HvH6L4qY03HfTTvCs1Fwg@mail.gmail.com> <4F9CE18C.2060806@msgid.tls.msk.ru> <CA+55aFyS9VYT50JAXeGrLrtFVWSGr+DMTA1hhrcPYzmjrSV5+A@mail.gmail.com>
In-Reply-To: <CA+55aFyS9VYT50JAXeGrLrtFVWSGr+DMTA1hhrcPYzmjrSV5+A@mail.gmail.com>
X-Enigmail-Version: 1.4
OpenPGP: id=804465C5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Hit "reply" instead of "Reply to all".. I'm sorry for a repost]

On 29.04.2012 11:19, Linus Torvalds wrote:
[]
>> /proc/1/fdinfo/16  -- the autofs pipe fd# -- shows flags=02004000
>> which is O_CLOEXEC|O_NONBLOCK, but this is the other end of the
>> pipe..  shouldn't the READ side of the pipe have O_DIRECT flag now?
>
> Gaah, it should, but it won't.
>
> I bet my original patch worked fine, because the pipe has only one
> inode and pipe structure. But it has *two* 'struct file's associated
> with it, and autofs only ever sees the writing side, and never gets to
> mark the reading side O_DIRECT. So yeah, the reading side won't do the
> proper packetized read.

Can't we go - in kernel - from one struct file to pipe structure to
another file structure and set O_DIRECT there?  Autofs kernel code
checks if the file descriptor is a pipe, so it should be possible...

Thanks,

/mjt
