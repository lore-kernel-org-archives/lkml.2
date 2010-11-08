Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087Ab0KHHYb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 02:24:31 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45018 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424Ab0KHHY3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 02:24:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:reply-to:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=W29WTeRnhN6o+QRhi3bbYaj7qFYyQC5ioWTmlyLqt0I95UBpNEwgUzeIdOOgFzRz2V
         CJQ9/Fo4JNeTRcz6JSFtCuCcl1ibZHvrhZN1aea5y8dv1KARFcFLA9HKTfnexdZX9+XY
         M54P8jfsBBeQU619FtWz5Gacze0cmS7RXw80c=
From: Florian Fainelli <florian@openwrt.org>
Reply-To: Florian Fainelli <florian@openwrt.org>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH] arch: mips: use newly introduced hex_to_bin()
Date: Mon, 8 Nov 2010 08:26:23 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36-trunk-amd64; KDE/4.4.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
        linux-mips@linux-mips.org
References: <1284212009-25708-1-git-send-email-andy.shevchenko@gmail.com> <AANLkTimRVNYMh923+5qS5mifDKgJRwCxeWGMXWYaJXr9@mail.gmail.com>
In-Reply-To: <AANLkTimRVNYMh923+5qS5mifDKgJRwCxeWGMXWYaJXr9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201011080826.25676.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Monday 11 October 2010 18:34:16, Andy Shevchenko a écrit :
> Any comments here?

Acked-by: Florian Fainelli <florian@openwrt.org>

> 
> On Sat, Sep 11, 2010 at 4:33 PM, Andy Shevchenko
> 
> <andy.shevchenko@gmail.com> wrote:
> > Remove custom implementation of hex_to_bin().
> > 
> > Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
> > Cc: Ralf Baechle <ralf@linux-mips.org>
> > Cc: linux-mips@linux-mips.org
> > ---
> >  arch/mips/rb532/devices.c |   24 +++++++++---------------
> >  1 files changed, 9 insertions(+), 15 deletions(-)
> > 
> > diff --git a/arch/mips/rb532/devices.c b/arch/mips/rb532/devices.c
> > index 041fc1a..a969eb8 100644
> > --- a/arch/mips/rb532/devices.c
> > +++ b/arch/mips/rb532/devices.c
> > @@ -251,28 +251,22 @@ static struct platform_device *rb532_devs[] = {
> > 
> >  static void __init parse_mac_addr(char *macstr)
> >  {
> > -       int i, j;
> > -       unsigned char result, value;
> > +       int i, h, l;
> > 
> >        for (i = 0; i < 6; i++) {
> > -               result = 0;
> > -
> >                if (i != 5 && *(macstr + 2) != ':')
> >                        return;
> > 
> > -               for (j = 0; j < 2; j++) {
> > -                       if (isxdigit(*macstr)
> > -                           && (value =
> > -                               isdigit(*macstr) ? *macstr -
> > -                               '0' : toupper(*macstr) - 'A' + 10) < 16)
> > { -                               result = result * 16 + value;
> > -                               macstr++;
> > -                       } else
> > -                               return;
> > -               }
> > +               h = hex_to_bin(*macstr++);
> > +               if (h == -1)
> > +                       return;
> > +
> > +               l = hex_to_bin(*macstr++);
> > +               if (l == -1)
> > +                       return;
> > 
> >                macstr++;
> > -               korina_dev0_data.mac[i] = result;
> > +               korina_dev0_data.mac[i] = (h << 4) + l;
> >        }
> >  }
> > 
> > --
> > 1.7.2.2
