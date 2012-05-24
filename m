Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934128Ab2EXV4z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 17:56:55 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:35267 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932105Ab2EXV4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 17:56:53 -0400
MIME-Version: 1.0
In-Reply-To: <20120524213813.GA17452@core.coreip.homeip.net>
References: <20120524083216.GD10562@core.coreip.homeip.net>
 <CA+55aFxw0HRpizzJZxhhA2oqPpzg4DPUvH2r7YoYfctXS6K=WQ@mail.gmail.com>
 <20120524180154.GA15036@core.coreip.homeip.net> <CA+55aFx0ww=BtYAj9WEbqMT2R30ZZpjd014cYCpC=b+HRtUf_A@mail.gmail.com>
 <20120524195851.GA15306@core.coreip.homeip.net> <CA+55aFxX+xidcuVXb1h4oFTemtHo+ANECaoOw=vxtKN231N+cA@mail.gmail.com>
 <20120524203647.GA16024@core.coreip.homeip.net> <CA+55aFz9Fp2J=oCkoDAwNTnEJoBeKC9tn+5dqMCKf4C22CAi6Q@mail.gmail.com>
 <20120524205952.GA16621@core.coreip.homeip.net> <CA+55aFybQDXjGaEK0k=60gS88bxwE8vC7XvOffaQAf3de9cCfg@mail.gmail.com>
 <20120524213813.GA17452@core.coreip.homeip.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 24 May 2012 14:56:31 -0700
X-Google-Sender-Auth: cx2-YLrKnmTQT0cfRff9eeA_eK8
Message-ID: <CA+55aFyvn-maXzA5G31+ZsNqC7+QT6SkhpUCTCw+DEF1T3Uhsw@mail.gmail.com>
Subject: Re: [git pull] Input updates for 3.5-rc0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 2:38 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
>
> Maybe dev_XXX() should report full sysfs path do the dveice? Still does
> not help with the fact that "driver" shown for class devices is not so
> interesting as it will always be the class name.

Well, the dev_printk logic could certainly have simple rules to avoid
duplicate information. And perhaps pick the most relevant parts using
some heuristics.

Right now it just prints out "%s %s" for dev_driver_string(dev) and
dev_name(dev) respectively. That really isn't all that wonderfully
beautiful, and results in things like

  hid-generic 0003:046D:C526.0006: xyz

for my Logitech USB Receiver. That's kind of ugly, and really doesn't
clarify anything at all, I think.

The "driver + dev_name()" works fine for things like PCI devices, but
even then it's partly because the PCI layer has made sure to make the
device name pretty - and the device name contains the (redundant) data
of which bus number it is on, even though that's strictly a matter of
the parent thing (but the device name has been prettified and contains
redundant information exactly so that it would print out nicely).

                    Linus
