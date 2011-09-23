Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751280Ab1IWRnN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 13:43:13 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:39426 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135Ab1IWRnM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 13:43:12 -0400
MIME-Version: 1.0
In-Reply-To: <1316788285-17433-9-git-send-email-philipp.reisner@linbit.com>
References: <1316788285-17433-1-git-send-email-philipp.reisner@linbit.com> <1316788285-17433-9-git-send-email-philipp.reisner@linbit.com>
From: Kyle Moffett <kyle@moffetthome.net>
Date: Fri, 23 Sep 2011 13:42:52 -0400
Message-ID: <CAGZ=bqJMKZ=MK+GXSXWCPVCecXHQv_15AT9Dxq2wxfcA_gNdMA@mail.gmail.com>
Subject: Re: [PATCH 08/10] drbd: Introduce protocol version 100 headers
To: Philipp Reisner <philipp.reisner@linbit.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        drbd-dev@lists.linbit.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Fri, Sep 23, 2011 at 10:31, Philipp Reisner
<philipp.reisner@linbit.com> wrote:
> From: Andreas Gruenbacher <agruen@linbit.com>
>
> Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
> Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
> ---
>  drivers/block/drbd/drbd_int.h      |    8 ++++++++
>  drivers/block/drbd/drbd_main.c     |   31 +++++++++++++++++++++++++------
>  drivers/block/drbd/drbd_receiver.c |   14 ++++++++++++--
>  include/linux/drbd.h               |    1 +
>  4 files changed, 46 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
> index 9868518..7d679c5 100644
> --- a/drivers/block/drbd/drbd_int.h
> +++ b/drivers/block/drbd/drbd_int.h
> @@ -307,6 +307,14 @@ struct p_header95 {
>        u32       vol_n_len;    /* big endian: high byte = volume; remaining 24 bit = length */
>  } __packed;
>
> +struct p_header100 {
> +       u32       magic;
> +       u16       volume;
> +       u16       command;
> +       u32       length;
> +       u32       pad;
> +} __packed;
> +

This commit also needs additional log message text,
specifically something that indicates what is new and
different between the protocol 95 and protocol 100
headers.  (IE: Why was the change made?)

Cheers,
Kyle Moffett
