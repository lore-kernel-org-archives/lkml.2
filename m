Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352Ab1BHNkv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 08:40:51 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:62429 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754184Ab1BHNku convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 08:40:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=YF2Tqgl9VFgSTS4C9CtMB9SOO2p4nlWZk78Nt63LjaLlyNeFR53MOF+MyKAhKYtvNa
         70/ZQl6Fcqjto0HjP06QyT+2qsHWs0vBfn+6u27mpt2m8W9XjnX0ewWoqdddSl6rWhx2
         7NYU+84NeikUIJ6SApzD0NObj7KWOPAdqdAVA=
MIME-Version: 1.0
In-Reply-To: <20110126143045.GP2721@bicker>
References: <1296042555-29145-1-git-send-email-marek.belisko@open-nandra.com>
	<1296042555-29145-4-git-send-email-marek.belisko@open-nandra.com>
	<20110126130718.GN2721@bicker>
	<20110126143045.GP2721@bicker>
Date: Tue, 8 Feb 2011 14:40:49 +0100
Message-ID: <AANLkTi=ygn3Go7kCYe1fAo6OrKQaVVGaV_=xMgxM=u5s@mail.gmail.com>
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

On Wed, Jan 26, 2011 at 3:30 PM, Dan Carpenter <error27@gmail.com> wrote:
> Also when it does:
>        memcpy(ft1000dev->tx_buf, *pUcFile, byte_length);
>
> That should probably be:
>        memcpy(ft1000dev->tx_buf, *pUcFile, word_length * 4);
No this shouldn't because before you have additional check:
if (byte_length && ((byte_length % 64) == 0))
        byte_length += 4;

if (byte_length < 64)
        byte_length = 68;
So in my opinion byte_length should stay.
>
> Otherwise we're probably copying garbage from beyond the end of *pUcFile
> to the ->tx_buf.  ft1000dev->tx_buf is hopefully initialized to zero at
> this point?
Yes usb_init_urb set it to zeroes.
>
> regards,
> dan carpenter
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
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
