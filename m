Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754964Ab2HKWX7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2012 18:23:59 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:34241 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752359Ab2HKWX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2012 18:23:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 14/15] sh: MTU2: Basic runtime PM support
Date: Sun, 12 Aug 2012 00:29:52 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Linux-sh list" <linux-sh@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <lethal@linux-sh.org>,
        Thomas Gleixner <tglx@linutronix.de>
References: <201207291612.43138.rjw@sisk.pl> <201208060149.37972.rjw@sisk.pl> <CAMuHMdUFeS6HNFuKVDLrFEo0f5=jrufa4QoD+aeZJHJD1Q1xCQ@mail.gmail.com>
In-Reply-To: <CAMuHMdUFeS6HNFuKVDLrFEo0f5=jrufa4QoD+aeZJHJD1Q1xCQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201208120029.52938.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, August 11, 2012, Geert Uytterhoeven wrote:
> On Mon, Aug 6, 2012 at 1:49 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > @@ -341,8 +346,19 @@ static int __devinit sh_mtu2_probe(struc
> >         if (ret) {
> >                 kfree(p);
> >                 platform_set_drvdata(pdev, NULL);
> > +               pm_runtime_idle(&pdev->dev);
> > +               return ret;
> >         }
> > -       return ret;
> > +       if (is_early_platform_device(pdev))
> > +               return 0;
> > +
> > + out:
> > +       if (cfg->clockevent_rating)
> 
> drivers/clocksource/sh_mtu2.c:356:6: error: 'cfg' undeclared (first
> use in this function)
> http://kisskb.ellerman.id.au/kisskb/buildresult/6883515/
> 
> Presumably there's a
> 
>         struct sh_timer_config *cfg = p->pdev->dev.platform_data;
> 
> missing at the top of sh_mtu2_probe()

Precisely.

It should be fixed now, thanks for the report!

Rafael
