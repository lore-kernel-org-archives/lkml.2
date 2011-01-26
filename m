Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299Ab1AZNfE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 08:35:04 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:45511 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732Ab1AZNfC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 08:35:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=JP5cFAs4YycqymFsiQMp4cuT/rjSYxw3A0xuNU4NgpIEig0DO2TxeYA+vs70VKD+9y
         aQ2Em752zQnQaOG1FLvyKRDPGXTlvaLS3nGjJN5Am6GOMa3GiwELL7WployzCNn07UYE
         3Al5UYjo7xOobDgGmfhnwcIEspglz7RiIhaZs=
MIME-Version: 1.0
In-Reply-To: <20110126130718.GN2721@bicker>
References: <1296042555-29145-1-git-send-email-marek.belisko@open-nandra.com>
	<1296042555-29145-4-git-send-email-marek.belisko@open-nandra.com>
	<20110126130718.GN2721@bicker>
Date: Wed, 26 Jan 2011 14:34:59 +0100
Message-ID: <AANLkTimN4KopQtVL8YaJ6M20RqEEMF5iADap4Jt=i=xo@mail.gmail.com>
Subject: Re: [PATCH 4/5] staging: ft1000: Fix coding style in write_blk_fifo() function.
From: Belisko Marek <marek.belisko@gmail.com>
To: Dan Carpenter <error27@gmail.com>,
        Marek Belisko <marek.belisko@open-nandra.com>, gregkh@suse.de,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26, 2011 at 2:07 PM, Dan Carpenter <error27@gmail.com> wrote:
> You didn't introduce it but do you know what the code is trying to do
> here?
>
>        byte_length = word_length * 4;
>
>        if (byte_length % 4)
>                aligncnt = 4 - (byte_length % 4);
>        else
>                aligncnt = 0;
>        byte_length += aligncnt;
>
>        if (byte_length && ((byte_length % 64) == 0))
>                byte_length += 4;
>
>        if (byte_length < 64)
>                byte_length = 68;
>
>
> Apparently the stuff has to be aligned to 4 bytes, but it can't be
> aligned at 64 bytes and it can't be less than 68 bytes long.  The
> part that especially confuses me is why it can't be aligned at 64 bytes.
Yes this code seems little bit confusing but basically this routine send data
to device when firmware code is downloaded. Length which should be send is
asked by device itself (word_length) so maybe it should be somehow
aligned in some cases
(don't know details).  Just to get some idea about length I add some
printk(before 4*word_length
and after byte_length is counted before sending to usb):

Jan 26 14:22:24 linux kernel: [29632.843980] write_blk_fifo: word_length:4
Jan 26 14:22:24 linux kernel: [29632.843984] write_blk_fifo: byte_length:68
Jan 26 14:22:24 linux kernel: [29632.859982] write_blk_fifo: word_length:506
Jan 26 14:22:24 linux kernel: [29632.859986] write_blk_fifo: byte_length:2024
Jan 26 14:22:24 linux kernel: [29632.874984] write_blk_fifo: word_length:505
Jan 26 14:22:24 linux kernel: [29632.874988] write_blk_fifo: byte_length:2020
Jan 26 14:22:24 linux kernel: [29632.890046] write_blk_fifo: word_length:4
Jan 26 14:22:24 linux kernel: [29632.890051] write_blk_fifo: byte_length:68


>
> regards,
> dan carpenter
>

thanks,

marek

-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
icq: 290551086
web: http://open-nandra.com
