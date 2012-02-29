Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899Ab2B2Upx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 15:45:53 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:42883 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755429Ab2B2Upv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 15:45:51 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of andrei.emeltchenko.news@gmail.com designates 10.152.130.102 as permitted sender) smtp.mail=andrei.emeltchenko.news@gmail.com; dkim=pass header.i=andrei.emeltchenko.news@gmail.com
MIME-Version: 1.0
In-Reply-To: <1330535217-26785-1-git-send-email-santoshprasadnayak@gmail.com>
References: <1330535217-26785-1-git-send-email-santoshprasadnayak@gmail.com>
Date: Wed, 29 Feb 2012 22:45:49 +0200
Message-ID: <CAMXE1-oXtheVHDuU3w52mXqmuY8AK4kk+tuvJpVRDq2=+qEnsQ@mail.gmail.com>
Subject: Re: [PATCH] Bluetooth: Silence static checker warning.
From: Andrei Emeltchenko <andrei.emeltchenko.news@gmail.com>
To: santosh nayak <santoshprasadnayak@gmail.com>
Cc: marcel@holtmann.org, padovan@profusion.mobi, davem@davemloft.net,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Santosh,

On Wed, Feb 29, 2012 at 7:06 PM, santosh nayak
<santoshprasadnayak@gmail.com> wrote:
> From: Santosh Nayak <santoshprasadnayak@gmail.com>
>
> Silencing Static checker warning.
> 1. Endian warning
> 2. variable dereferenced before check 'sk' .
>
> Signed-off-by: Santosh Nayak <santoshprasadnayak@gmail.com>
> ---
>  net/bluetooth/l2cap_sock.c |    9 ++++++---
>  1 files changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
> index 401d942..d206321 100644
> --- a/net/bluetooth/l2cap_sock.c
> +++ b/net/bluetooth/l2cap_sock.c
> @@ -82,7 +82,7 @@ static int l2cap_sock_bind(struct socket *sock, struct sockaddr *addr, int alen)
>        }
>
>        if (la.l2_cid)
> -               err = l2cap_add_scid(chan, la.l2_cid);
> +               err = l2cap_add_scid(chan, __le16_to_cpu(la.l2_cid));
>        else
>                err = l2cap_add_psm(chan, &la.l2_bdaddr, la.l2_psm);
>
> @@ -123,7 +123,8 @@ static int l2cap_sock_connect(struct socket *sock, struct sockaddr *addr, int al
>        if (la.l2_cid && la.l2_psm)
>                return -EINVAL;
>
> -       err = l2cap_chan_connect(chan, la.l2_psm, la.l2_cid, &la.l2_bdaddr);
> +       err = l2cap_chan_connect(chan, la.l2_psm, __le16_to_cpu(la.l2_cid),
> +                               &la.l2_bdaddr);
>        if (err)
>                goto done;
>
> @@ -795,7 +796,7 @@ static void l2cap_sock_kill(struct sock *sk)
>  static int l2cap_sock_shutdown(struct socket *sock, int how)
>  {
>        struct sock *sk = sock->sk;
> -       struct l2cap_chan *chan = l2cap_pi(sk)->chan;
> +       struct l2cap_chan *chan;
>        int err = 0;
>
>        BT_DBG("sock %p, sk %p", sock, sk);
> @@ -803,6 +804,8 @@ static int l2cap_sock_shutdown(struct socket *sock, int how)
>        if (!sk)
>                return 0;
>
> +       chan = l2cap_pi(sk)->chan;
> +

Didn't I fix this bug already?

http://permalink.gmane.org/gmane.linux.bluez.kernel/21537

Regards,
Andrei
