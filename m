Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715Ab1AOTCp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 14:02:45 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59263 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589Ab1AOTCn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 14:02:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=NjpXwJl/qfj/fOnHKz2N21eZOmn3NAHMPAJCg+rlXbGAmUr+9ZxTtjI7s41GRdQRQg
         Se+Z6mx853w6wx8P0nlFjB7ADo4TPbeLjYc5XAZWNRn3CwXEBbeG4/2ZF7TbsoJFbn4y
         L4Qkx/+Tk475ciiHiZV9eKTQCPrBm7wWXG4Tk=
MIME-Version: 1.0
In-Reply-To: <20110115172320.GU9506@random.random>
References: <4d308cf5394566ccc@agluck-desktop.sc.intel.com>
	<1295076096.4875.60.camel@pasglop>
	<20110115155925.GT9506@random.random>
	<1295110048.5973.36.camel@mulgrave.site>
	<20110115172320.GU9506@random.random>
Date: Sat, 15 Jan 2011 20:02:41 +0100
X-Google-Sender-Auth: SV5TFV9newFAjdFV_fpy_rfGHU4
Message-ID: <AANLkTinMP2oeaWxiXXW-5psRyxeuBfkGth9cU7EgNvGO@mail.gmail.com>
Subject: Re: ia64 broken by transparent huge pages - other arches too?
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 15, 2011 at 18:23, Andrea Arcangeli <aarcange@redhat.com> wrote:
>> The problem is very often not in the actual code, but in the side
>> effects the code causes.  This is what linux-next integration helps
>> mitigate. So, please use it next time.  Just testing on x86 in your own
>> configuration isn't sufficient to pick up the problems.
>
> I fully agree with you about build time regression, there linux-next
> might have helped more. I'm talking about runtime regressions. If it
> build it'll work because nothing relevant has changed for not-x86
> archs.
>
> By all means next times I'll try to get through linux-next too if this
> is preferred, but the brainer part has been heavily tested and that's
> the important thing as far as I can see.
>
> I'm also not sure if having it in linux-next instead of -mm, would
> have been better in terms of handling of the patchstream. I think
> having it managed in -mm reviewed by all other -mm developers using
> raw patches floating in the linux-mm and mm-commit lists, was ideal
> and potentially more valuable for an increased amount of review, than
> what a blind pull from linux-next could provide. For the brainer part,
> maximizing the reviewing was certainly more valuable than checking if
> it builds and boots on some arch not affected in any functional way.

These are not mutually exclusive options: we want to (a) have everything
reviewed and discussed _and_ (b) have everything build (and optionally run)
tested in linux-next. If perfection was the goal, we don't settle for anything
less.

Furthermore, even stupid and trivial to fix build issues may mask other
more severe issues, and delay the fixing of those.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
