Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756427Ab2D0Wt4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 18:49:56 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:44643 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148Ab2D0Wtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 18:49:55 -0400
MIME-Version: 1.0
In-Reply-To: <20120427234215.079a1565@pyramind.ukuu.org.uk>
References: <20120427.151433.1007849975903946491.davem@davemloft.net>
 <20120427.151651.2274764174217164454.davem@davemloft.net> <CA+55aFzPbAprx-iT0TYh24uS7+JnL92mbTg_js6Cd_O0q+Dvmw@mail.gmail.com>
 <20120427.152404.2292425516870981391.davem@davemloft.net> <CA+55aFzGO+PHmjjVgxnYawbB-wFAqHtkh19vTv1AwQNpc9MsWg@mail.gmail.com>
 <20120427234215.079a1565@pyramind.ukuu.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 27 Apr 2012 15:49:32 -0700
X-Google-Sender-Auth: YHqd_QShY8ypQS1RKv5tE9NYyG0
Message-ID: <CA+55aFxoGXgVhPyU6ObOnowpCNVYCyaVeFswLx_vJ3c4KBf3yw@mail.gmail.com>
Subject: Re: [PATCH v2] Introduce a version6 of autofs interface, to fix
 design error.
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: David Miller <davem@davemloft.net>, mjt@tls.msk.ru,
        linux-kernel@vger.kernel.org, autofs@vger.kernel.org, raven@themaw.net,
        thomas@m3y3r.de, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 3:42 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> Comments? The patch looks fairly simple. The "packetized pipe" might
>> even be useful for other users and maybe we might want to expose it as
>> an actual pipe fcntl, but right now the only thing that sets that flag
>> is autofs.
>
> The obvious way to set the flag would seem to me to also btake O_DIRECT
> on the pipe as meaning this ?

Hmm. That would work, then if you wanted to create a packet pipe, you'd just use

   if (pipe2(fd, O_DIRECT | O_NONBLOCK)) {
     perror("Kernel doesn't support packetized pipes");
     return -1;
  }

which means that if user space wants to use packetized pipes for other
things, it now has a nice way of testing whether the kernel supports
it (because older kernels would return -EINVAL - for once we actually
verify that only the flags we support are set).

And that maybe we wouldn't even need the extra flag in the "struct
pipe" at all - we could just check it in file->f_flags.

Let my try that.

                   Linus
