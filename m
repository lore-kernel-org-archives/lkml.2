Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756888Ab1CSRUO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Mar 2011 13:20:14 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:49416 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755383Ab1CSRUL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Mar 2011 13:20:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PhI6gDEQy+yDZ9tA+WHv3CEy3cbjqd/DJ8QfUV79g2y4tuFKSZgKxZJZnQ30kfSCXK
         CnaU9kbVgQxXTMwyHLIeQwmh9iS5cA4LbuXHioe5lopQqZjsDK4Cz2DBJVnRWj3bIjY6
         L/y2n6Dinyf5IEqwY0+oJvdHg2itiiU4snB0U=
MIME-Version: 1.0
In-Reply-To: <1300549151.2831.32.camel@edumazet-laptop>
References: <4D84A46B.1000407@example.com>
	<AANLkTimFGeHYEOxx=h883rRJL463g1CBUDS0wGM-52Nj@mail.gmail.com>
	<1300547930.2831.27.camel@edumazet-laptop>
	<201103191631.07952.oliver@neukum.org>
	<1300548821.2831.28.camel@edumazet-laptop>
	<1300549151.2831.32.camel@edumazet-laptop>
Date: Sat, 19 Mar 2011 19:20:09 +0200
Message-ID: <AANLkTike8Ggtwjrx64MR4QiPtn1vMF+CVWFJbDrNaVrR@mail.gmail.com>
Subject: Re: [PATCH] r8169: fix a bug in rtl8169_init_phy()
From: Anca Emanuel <anca.emanuel@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Oliver Neukum <oliver@neukum.org>, piotr@hosowicz.com,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        Francois Romieu <romieu@fr.zoreil.com>,
        David Miller <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 19, 2011 at 5:39 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Le samedi 19 mars 2011 à 16:33 +0100, Eric Dumazet a écrit :
>> Le samedi 19 mars 2011 à 16:31 +0100, Oliver Neukum a écrit :
>> > Am Samstag, 19. März 2011, 16:18:50 schrieb Eric Dumazet:
>> >
>> > > Problem comes from commit 54405cde762408b00a445466a40da4f7f33a8479
>> > > (r8169: support control of advertising.)
>> > >
>> > > Reverting it brings back NIC for me
>> >
>> > Odd. It worked for me. Are you testing on a gigabit switch? Could you send
>> > me dmesg? Does it work if you use ethtool to advertise a lower speed?
>> >
>> >     Regards
>> >             Oliver
>>
>> I found the bug, I am sending a patch in two minutes.
>>
>
> Here it is
>
> [PATCH] r8169: fix a bug in rtl8169_init_phy()
>
> commit 54405cde7624 (r8169: support control of advertising.)
> introduced a bug in rtl8169_init_phy()
>
> Reported-by: Piotr Hosowicz <piotr@hosowicz.com>
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> Cc: Oliver Neukum <oliver@neukum.org>
> Cc: Francois Romieu <romieu@fr.zoreil.com>
> ---
>  drivers/net/r8169.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/r8169.c b/drivers/net/r8169.c
> index 5e40351..493b0de 100644
> --- a/drivers/net/r8169.c
> +++ b/drivers/net/r8169.c
> @@ -2685,9 +2685,9 @@ static void rtl8169_init_phy(struct net_device *dev, struct rtl8169_private *tp)
>        rtl8169_set_speed(dev, AUTONEG_ENABLE, SPEED_1000, DUPLEX_FULL,
>                ADVERTISED_10baseT_Half | ADVERTISED_10baseT_Full |
>                ADVERTISED_100baseT_Half | ADVERTISED_100baseT_Full |
> -               tp->mii.supports_gmii ?
> +               (tp->mii.supports_gmii ?
>                        ADVERTISED_1000baseT_Half |
> -                       ADVERTISED_1000baseT_Full : 0);
> +                       ADVERTISED_1000baseT_Full : 0));
>
>        if (RTL_R8(PHYstatus) & TBI_Enable)
>                netif_info(tp, link, dev, "TBI auto-negotiating\n");
>
>
>

Thanks Eric, It Woks now !

My r8169 was not working see:
https://lkml.org/lkml/2011/3/19/19

Tested-by: Anca Emanuel <anca.emanuel@gmail.com>
