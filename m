Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757186Ab1KUWMT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 17:12:19 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45199 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753692Ab1KUWMR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 17:12:17 -0500
MIME-Version: 1.0
In-Reply-To: <201111212249.31196.rjw@sisk.pl>
References: <lx6sezwGldO.A.IhF.UBpWOB@chimera> <201111212249.31196.rjw@sisk.pl>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 21 Nov 2011 14:11:54 -0800
X-Google-Sender-Auth: SXL6A0WHzx2Iikp2Gm0y7Eq9SS0
Message-ID: <CA+55aFwAELQieN=qR7Gz_MT5rHPp90H10uTMS+DOJjefk7q3ng@mail.gmail.com>
Subject: Re: 3.2-rc2+: Reported regressions from 3.0 and 3.1
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Andy Lutomirski <luto@amacapital.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        Linux PM List <linux-pm@lists.linux-foundation.org>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 21, 2011 at 1:49 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>
> Subject    : [3.1 REGRESSION] Commit 5cec93c216db77c45f7ce970d46283bcb1933884 breaks the Chromium seccomp sandbox
> Submitter  : Nix <nix@esperi.org.uk>
> Date       : 2011-11-14 0:40
> Message-ID : 8762inleno.fsf@spindle.srvr.nix
> References : http://marc.info/?l=linux-kernel&m=132123396226377&w=2

So this should be fixed by commit 2b666859ec32 ("x86: Default to
vsyscall=native for now"), since we disabled the vsyscall emulation
because it broken UML too.

Of course, the chromium seccomp thing might re-surface with the
patches that enable the emulation (with better emulation), which Andy
is still working on, and that I was planning on merging for 3.3.

Andy, it migth be worth contacting Nix and having him test whether
your fixed emulation works for chromium too.

                      Linus
