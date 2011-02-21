Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287Ab1BUGlb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 01:41:31 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43781 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027Ab1BUGl3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 01:41:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=N47VGLGcQUo1BoGeD3eFZ/d/YSDYoWNs9kYD1vBATwXWHqQbHna1z85YrT/l6BYcYx
         IyWElJ4FF+D/Nx0KN755CH6OybyxR0VrxM6OiTQZZcg+vcqjBEfrDzTN5uuQPk57G3vT
         6UKMxidRW5dd5LYoS2oCiJZH9Tppdi+YIEeN0=
MIME-Version: 1.0
In-Reply-To: <20110221043601.GB22204@spacedout.fries.net>
References: <20110211035309.GA22204@spacedout.fries.net>
	<20110214145649.GE2597@joana>
	<AANLkTi==Sh2yc2JjjY5t-NKxQexKPgPwNyWo4SMju92k@mail.gmail.com>
	<20110221043601.GB22204@spacedout.fries.net>
Date: Mon, 21 Feb 2011 14:41:29 +0800
Message-ID: <AANLkTi=b5UCdyc3ZtUFCx23uYygM7eRyGu-y_wdJ5JXi@mail.gmail.com>
Subject: Re: [PATCH] work around for l2cap NULL dereference in l2cap_conn_start
From: Liang Bao <tim.bao@gmail.com>
To: David Fries <david@fries.net>
Cc: Andrei Warkentin <andreiw@motorola.com>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, David, Andrew et al.

2011/2/21 David Fries <david@fries.net>:
> bt_sk(sk)->parent can be NULL in l2cap_conn_start in state BT_CONNECT2
> at least when a headset device pairs and the play button was pressed
> right before pairing.
>
> Signed-off-by: David Fries <david@fries.net>
> ---
> I removed the printk, can this be merged to the bluetooth next tree?
>
> On Mon, Feb 14, 2011 at 03:40:46PM -0600, Andrei Warkentin wrote:
>> FWIW still need it in 2.6.36.
>
> Andrei, I'm curious, what's your hardware hardware and bluetooth
> device that's trigginer the crash?
I  once submitted an issue observed with Android+Motorola S305 stereo
headset. It's still open in launchpad:
https://bugs.launchpad.net/ubuntu/+source/bluez/+bug/513642. Hope this
helps. Thanks.
>
>> On Mon, Feb 14, 2011 at 8:56 AM, Gustavo F. Padovan
>> <padovan@profusion.mobi> wrote:
>> > Hi David,
>> >
>> > * David Fries <david@fries.net> [2011-02-10 21:53:09 -0600]:
>> >
>> >> Here's a patch to avoid a very repeatable crash in the N900.  If I
>> >> take a Motorola S305 bluetooth headset that was previously paried with
>> >> the N900, turn it on, and press the play button before the headphones
>> >> automatically pair with the cell phone, the N900 will crash (and
>> >> reboot) in pairing.  If I wait until after they have paired there
>> >> isn't any problem.  The patch is against the kernel-power
>> >> 2.6.28-maemo46 by Thomas Tanner, the stock Nokia PR1.2 oops looked
>> >> the same, I just haven't gone back to that kernel.
>> >
>> > This is a very old kernel. You need to check this issue against
>> > bluetooth-next-2.6.
>
>  net/bluetooth/l2cap.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/net/bluetooth/l2cap.c b/net/bluetooth/l2cap.c
> index ed83c1f..a7aa4d9 100644
> --- a/net/bluetooth/l2cap.c
> +++ b/net/bluetooth/l2cap.c
> @@ -408,7 +408,8 @@ static void l2cap_conn_start(struct l2cap_conn *conn)
>                                        struct sock *parent = bt_sk(sk)->parent;
>                                        rsp.result = cpu_to_le16(L2CAP_CR_PEND);
>                                        rsp.status = cpu_to_le16(L2CAP_CS_AUTHOR_PEND);
> -                                       parent->sk_data_ready(parent, 0);
> +                                       if(parent)
> +                                               parent->sk_data_ready(parent,0);
>
>                                } else {
>                                        sk->sk_state = BT_CONFIG;
> --
> 1.7.2.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bluetooth" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
