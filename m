Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598Ab0LGTNt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 14:13:49 -0500
Received: from mail-gw0-f42.google.com ([74.125.83.42]:34046 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752881Ab0LGTNs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 14:13:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:cc:content-type:content-transfer-encoding;
        b=ets30riN+2l0RnsLp79+hMKp/qbWeUnDn9CA3P2PWV4gtVsmVYYhcpZiXNtvL4QHzh
         f8RNU0+Pyf8RKKHWIN5rDoAU6PVOs3f2AoEO0bl+qu7swD3rPd1lfkLMDPKvmGNuuj/f
         X3SYowqx5DCt3QPnHDS8DLmLCk2/pQyFW2Rvw=
MIME-Version: 1.0
Date: Tue, 7 Dec 2010 20:07:09 +0100
X-Google-Sender-Auth: uibBnQy0al1yd6q4L0JqeJCEP74
Message-ID: <AANLkTikVM=zakYF7uhX1mYHy9QUVL6dmEPNsmV7=oyuh@mail.gmail.com>
Subject: visibility changes (was: Re: [GIT] kbuild and kconfig fixes for 2.6.37-rc5)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Michal Marek <mmarek@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        brueckner@linux.vnet.ibm.com, lacombar@gmail.com, mchehab@redhat.com,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 4, 2010 at 14:57, Michal Marek <mmarek@suse.cz> wrote:
> please pull these kbuild/kconfig fixes for the next -rc. The largest
> part are fixes for the annoying kconfig warnings, contributed by Arnaud
> Lacombe and Mauro Carvalho Chehab. The solution adds a new 'visible if'
> keyword to the Kconfig language, so it's not exactly something that one
> would expect in the rc phase, but the kconfig change is not huge (the
> large diff is due to generated files) and it is deployed only in those
> five Kconfig files that had the warnings and were hard to fix by other
> means.  The second part is a forgotten patch by Hendrik Brueckner to
> usr/initramfs, that fixes build for Blackfin and h8300.

> Arnaud Lacombe (5):
>      kconfig: add an option to determine a menu's visibility

Hmm, this changeset also went in through the v4l tree?

BTW, I got confused:
  - make allmodconfig causes e.g.:
        CONFIG_VIDEO_HELPER_CHIPS_AUTO=y
        CONFIG_VIDEO_TVAUDIO=m
    => good
  - make oldconfig for my config with almost everything selected,
except for stuff I know that breaks:
        CONFIG_VIDEO_HELPER_CHIPS_AUTO=y
        # CONFIG_VIDEO_TVAUDIO is not set
    and no way to manually set CONFIG_VIDEO_TVAUDIO=y?
    => bad!

Is this intentional?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
