Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911Ab2D2Txx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 15:53:53 -0400
Received: from isrv.corpit.ru ([86.62.121.231]:59346 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752663Ab2D2Txv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 15:53:51 -0400
Message-ID: <4F9D9C4C.7000904@msgid.tls.msk.ru>
Date: Sun, 29 Apr 2012 23:53:48 +0400
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
References: <20120427.151433.1007849975903946491.davem@davemloft.net> <20120427.151651.2274764174217164454.davem@davemloft.net> <CA+55aFzPbAprx-iT0TYh24uS7+JnL92mbTg_js6Cd_O0q+Dvmw@mail.gmail.com> <20120427.152404.2292425516870981391.davem@davemloft.net> <CA+55aFzGO+PHmjjVgxnYawbB-wFAqHtkh19vTv1AwQNpc9MsWg@mail.gmail.com> <20120427234215.079a1565@pyramind.ukuu.org.uk> <CA+55aFxq4TunFa8mqJk5MHfvvFSg7Dr54acW7Cnqc5amOPdqrg@mail.gmail.com> <CA+55aFzdEcfXVXXqCumVJo=9+fK+1HvH6L4qY03HfTTvCs1Fwg@mail.gmail.com> <4F9CE18C.2060806@msgid.tls.msk.ru> <CA+55aFyS9VYT50JAXeGrLrtFVWSGr+DMTA1hhrcPYzmjrSV5+A@mail.gmail.com> <4F9CF191.5020607@msgid.tls.msk.ru> <CA+55aFzJjk8vvY7au-aUOJqJaRaFT3zqP0_H9JXS2Y93wkXwEg@mail.gmail.com> <CA+55aFwTUDsefBd9c-wp8jrnp4tOh6jyJkjc_UZut-J6FHSF+w@mail.gmail.com>
In-Reply-To: <CA+55aFwTUDsefBd9c-wp8jrnp4tOh6jyJkjc_UZut-J6FHSF+w@mail.gmail.com>
X-Enigmail-Version: 1.4
OpenPGP: id=804465C5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.04.2012 23:09, Linus Torvalds wrote:
> 
> This keeps Alan's idea of using O_DIRECT, but only makes it matter for
> the writer - because now the "packet" thing is a per-pipe-buffer state
> (we already had per-pipe-buffer flags, so this is not anything new).
> So when you *write* using a O_DIRECT pipe, it will create packetized
> buffers, and the reader just sees that directly.
> 
> So this should "just work", and doesn't need any extra flags in the
> pipe_inode_info. And the user space interface remains the same: you
> can create these packet pipes with "pipe2(fd, O_DIRECT)" if you want
> to, and my test-program gives exactly the same output.

Ok.  I verified this on 3.3 kernel (with the original fix reverted),
and now both autofs5 and systemd works.

I also verified it on 3.0 kernel (3.0.30), the patch also applies
there just fine (with 1..2 lines offsets) and works too -- at least
on 32/64 bits.

So, the result appears to be an excellent solution to a bad problem...

Thank you all for the efforts and support!

You can add my

Tested-off-by: Michael Tokarev <mjt@tls.msk.ru>

(I'd add a Signed-off-by, but it is not my patch ;)

/mjt
