Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751247Ab2GCIX7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 04:23:59 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:38344 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710Ab2GCIXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 04:23:55 -0400
MIME-Version: 1.0
In-Reply-To: <201206301920.21158.arnd.bergmann@linaro.org>
References: <20120629174826.546cc991459b12833f2aaebd@canb.auug.org.au>
	<20120630181006.GC23990@avionic-0098.adnet.avionic-design.de>
	<201206301920.21158.arnd.bergmann@linaro.org>
Date: Tue, 3 Jul 2012 10:23:54 +0200
X-Google-Sender-Auth: r0f9J6WvihzNJx4EW0F5n1z1ues
Message-ID: <CAMuHMdVBs=i5i02_AxZ7CHBukmrj-ik-EjDTG58hZaLkxkc+dQ@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the final tree (pwm tree related)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Arnd Bergmann <arnd.bergmann@linaro.org>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 30, 2012 at 9:20 PM, Arnd Bergmann <arnd.bergmann@linaro.org> wrote:
> On Saturday 30 June 2012, Thierry Reding wrote:
>> I hadn't thought about the allyesconfig case yet. Adding a "depends on
>> !HAVE_PWM" to the PWM symbol should work and is the easiest fix to this
>> kind of problem while other PWM legacy API implementations are ported to
>> the PWM subsystem.
>>
>> Sascha, Arnd (Cc'ed): what do you think?
>>
>> I don't know if I'll get enough time to test this over the weekend but I
>> should get to it when I'm back in the office on Monday.
>>
> You cannot depend on a symbol in the same place that provides it -- that
> would be a recursive dependency (or a paradox).
>
> I think that all the drivers that are not converted to the common PWM
> layer yet should depend on not enabling the common code. Once they
> are all moved over, that dependency will go away.

Hence you cannot have a single kernel image that contains both legacy and new
drivers. I don't know whether there's any such combination that makes sense,
though.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
