Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664Ab1BGPA7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 10:00:59 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53343 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753864Ab1BGPA5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 10:00:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=rTdM4EYgOIKRM4b8B2fA9lk+dW3Wz4y6hYfR8CaPcqhf1yLmv8tY6I2aHiJJg8oNJJ
         1xy9FIUuGLHEJlKzoH7qLC0vKgwc3Qz+KM08fqhfkc9CeSziIiPB7xma+GdCXlY6XLBA
         CDBi0wobbQ8SKVcuYN9jZNUvOfTruMfYqBoC0=
MIME-Version: 1.0
In-Reply-To: <20110207145031.GL10564@opensource.wolfsonmicro.com>
References: <1297081335-13631-1-git-send-email-broonie@opensource.wolfsonmicro.com>
	<20110208011324.d5371c4c.sfr@canb.auug.org.au>
	<20110207141829.GK10564@opensource.wolfsonmicro.com>
	<20110208014432.2c9288e4.sfr@canb.auug.org.au>
	<20110207145031.GL10564@opensource.wolfsonmicro.com>
Date: Mon, 7 Feb 2011 16:00:55 +0100
X-Google-Sender-Auth: gz5mydwHl3GBCqXRhRFseZAStoI
Message-ID: <AANLkTikw7j5Q7CGZK=Xbcgubt9LYBGiXf01wQ4nbg8NR@mail.gmail.com>
Subject: Re: [PATCH] PM: Hide CONFIG_PM from users
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Len Brown <len.brown@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-embedded@vger.kernel.org,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 7, 2011 at 15:50, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Tue, Feb 08, 2011 at 01:44:32AM +1100, Stephen Rothwell wrote:
>> On Mon, 7 Feb 2011 14:18:29 +0000 Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:
>
>> > Do you mean that these systems require CONFIG_PM be turned off, or just
>> > that people tend not to turn it on?  If the latter would you expect any
>> > ill effects from doing so?
>
>> I don't know the answer to either question without testing.  All I am
>> saying is that currently the default for CONFIG_PM is "off" and you are
>> changing it to be "on" and there may not have been any testing done of
>> that in some situations.   We don't know where it was explicitly
>> turned off any more since we shrank our defconfig files (which was done
>> automatically) ... since it is off by default, it doesn't need to be
>> mentioned in a defconfig unless it needs to be turned on.
>
> My suspicion would be that it'll have been turned off by someone hitting
> return through a config upgrade rather than through deliberate effort.
> On the other hand if it is essential for some machines to have it
> disabled they probably want to have somethnig in Kconfig.

$ git grep "CONFIG_PM is not set"
7cf3d73b4360e91b14326632ab1aeda4cb26308d^ -- arch/ | wc -l
256
$

7cf3d73b4360e91b14326632ab1aeda4cb26308d is the commit that introduced
savedefconfig, so that's a safe revision with untrimmed defconfigs.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
