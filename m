Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755738Ab2APRew (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 12:34:52 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:40639 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755610Ab2APReu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 12:34:50 -0500
MIME-Version: 1.0
In-Reply-To: <20120116155004.GA6999@turtle.usersys.redhat.com>
References: <1326295008-29795-1-git-send-email-drjones@redhat.com>
	<4F1444FF.60205@redhat.com>
	<20120116155004.GA6999@turtle.usersys.redhat.com>
Date: Mon, 16 Jan 2012 18:34:44 +0100
X-Google-Sender-Auth: PYFfQ2qHZXqFuXs9bMFfNsV3_Dw
Message-ID: <CAMuHMdV=yhacfyS691kdzXNOTcOEWi-AxPcUDquYci3=J3AhMQ@mail.gmail.com>
Subject: Re: [PATCH] kconfig: untangle EXPERT and EMBEDDED
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew Jones <drjones@redhat.com>
Cc: Jerome Marchand <jmarchan@redhat.com>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, rientjes@google.com, mingo@elte.hu,
        david.woodhouse@intel.com, gregkh@suse.de, davem@davemloft.net,
        axboe@kernel.dk, arnd@arndb.de, holt@sgi.com,
        linux-arch@vger.kernel.org, linux@arm.linux.org.uk,
        hskinnemoen@gmail.com, egtvedt@samfundet.no, msalter@redhat.com,
        a-jacquiot@ti.com, starvik@axis.com, jesper.nilsson@axis.com,
        dhowells@redhat.com, takata@linux-m32r.org,
        yasutake.koichi@jp.panasonic.com, jonas@southpole.se, kyle@mcmartin.ca,
        deller@gmx.de, jejb@parisc-linux.org, chris@zankel.net, greg@kroah.com,
        davej@redhat.com, airlied@linux.ie, jkosina@suse.cz,
        mchehab@infradead.org, johannes@sipsolutions.net,
        linville@tuxdriver.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 16, 2012 at 16:50, Andrew Jones <drjones@redhat.com> wrote:
> On Mon, Jan 16, 2012 at 04:40:47PM +0100, Jerome Marchand wrote:
>> > @@ -1259,8 +1259,7 @@ config SLUB
>> >        a slab allocator.
>> >
>> >  config SLOB
>> > -   depends on EXPERT
>> > -   bool "SLOB (Simple Allocator)"
>> > +   bool "SLOB (Simple Allocator)" if EXPERT
>> >     help
>> >        SLOB replaces the stock allocator with a drastically simpler
>> >        allocator. SLOB is generally more space efficient but
>>
>> Am I missing something or this particular chunk does not actually change
>> anything?
>
> No, you're correct. There's no actual change, so the hunk could be dubbed
> as an unnecessary cleanup. I made the change in order to give it the same
> general format as the rest of the expert options in that file.

There _is_ a difference:
  - "depends on EXPERT" means the option cannot be enabled by the user.
    "select SLOB" will still override that, but kconf will print a warning.
  - "bool ... if EXPERT" means the question will only be asked if EXPERT.
    Other Kconfig logic can still "select SLOB" if it wants to.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
