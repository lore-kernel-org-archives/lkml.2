Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759239Ab2EXUtW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 16:49:22 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:45121 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513Ab2EXUtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 16:49:19 -0400
MIME-Version: 1.0
In-Reply-To: <20120524203647.GA16024@core.coreip.homeip.net>
References: <20120524083216.GD10562@core.coreip.homeip.net>
 <CA+55aFxw0HRpizzJZxhhA2oqPpzg4DPUvH2r7YoYfctXS6K=WQ@mail.gmail.com>
 <20120524180154.GA15036@core.coreip.homeip.net> <CA+55aFx0ww=BtYAj9WEbqMT2R30ZZpjd014cYCpC=b+HRtUf_A@mail.gmail.com>
 <20120524195851.GA15306@core.coreip.homeip.net> <CA+55aFxX+xidcuVXb1h4oFTemtHo+ANECaoOw=vxtKN231N+cA@mail.gmail.com>
 <20120524203647.GA16024@core.coreip.homeip.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 24 May 2012 13:48:57 -0700
X-Google-Sender-Auth: ofds9IzlrT9UdIXtzhfvVOJN1eU
Message-ID: <CA+55aFz9Fp2J=oCkoDAwNTnEJoBeKC9tn+5dqMCKf4C22CAi6Q@mail.gmail.com>
Subject: Re: [git pull] Input updates for 3.5-rc0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 1:36 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
>
> Hmm, I guess we are better now with cleaning and turning devices into
> zombies waiting to be reaped.

No, that wasn't the silly part of your statement.

The silly part is that

  dev_set_name(&dev->dev, "input-%s", dev_name(dev->dev.parent));

works perfectly fine if the parent goes away, for a damn simple
reason: it generates the string *once*, and doesn't care one *whit*
about the parent pointer ever again afterwards.

For exactly the same that your current

  dev_set_name(&dev->dev, "input%d", atomic_inc_return(&input_no) - 1);

doesn't care *at*all* about that "input_no" variable afterwards -
dev_set_name() will have turned it into a string, and "input_no" can
change as much as it wants, and that won't change the name of the
device.

See? So no "refcounting parents" or "zombie devices" or any crap like
that. The name is just a string.

Anyway, I can't be bothered to argue. If you think "input1" is such a
great name, and then that results in nobody actually ever *using* it
because everybody agrees it useless and will use something else,
whatever.

                Linus
