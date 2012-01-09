Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933385Ab2AIUOr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 15:14:47 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:51140 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933292Ab2AIUOp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 15:14:45 -0500
MIME-Version: 1.0
In-Reply-To: <1326056146.13595.315.camel@deadeye>
References: <1326055714.13595.309.camel@deadeye>
	<1326056146.13595.315.camel@deadeye>
Date: Mon, 9 Jan 2012 21:14:44 +0100
X-Google-Sender-Auth: AyqK8hVjpnKiqYD6Vm8ks-FeAY4
Message-ID: <CAMuHMdWM128G+TK+Y=FQ_Hhw7XTrYyDERCDN1MrknXDmbOofcA@mail.gmail.com>
Subject: Re: [PATCH 2/2] cpu: Register a generic CPU device on architectures
 that currently do not
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Linux-Arch <linux-arch@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 8, 2012 at 21:55, Ben Hutchings <ben@decadent.org.uk> wrote:
> frv, h8300, microblaze, openrisc, score and xtensa currently do not

m68k is also handled in your patch.
um is still missing.

> register a CPU device.  Add the config option GENERIC_CPU_DEVICES which
> causes a generic CPU device to be registered for each present CPU, and
> make all these architectures select it.
>
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>

Thanks!
On m68k, it works on its own or combined with "[PATCH 1/2] topology:
Check for missing CPU devices."

It adds

/sys/devices/system/cpu/cpu0
|-- subsystem -> ../../../../bus/cpu
|-- topology
|   |-- core_id
|   |-- core_siblings
|   |-- core_siblings_list
|   |-- physical_package_id
|   |-- thread_siblings
|   `-- thread_siblings_list
`-- uevent

and

/sys/bus/cpu/devices/cpu0 -> ../../../devices/system/cpu/cpu0

Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
