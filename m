Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017Ab0GYW03 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 18:26:29 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59355 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658Ab0GYW02 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 18:26:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=jKRqKhC2rCfcnAkL+Gc22dJfSKsiEUHlPrKRr9Xpwy+GZmc6dH8n45XRg+dQgQRrNw
         mGJ9L2JthtokLO6Cz1VAUJ9EYIPNI8FziVB97zNiRX4JPdoStf3Z11OOeL3EpXpBY/Kb
         dhhAs/3T5vLOHYqCp5WM2tA67RM1/UHkQO/Ew=
MIME-Version: 1.0
In-Reply-To: <1A61D8EA6755AF458F06EA669A4EC818013896@JKLMAIL02.ixonos.local>
References: <1A61D8EA6755AF458F06EA669A4EC81801387C@JKLMAIL02.ixonos.local>
	<1A61D8EA6755AF458F06EA669A4EC818013896@JKLMAIL02.ixonos.local>
Date: Mon, 26 Jul 2010 07:26:27 +0900
Message-ID: <AANLkTim9eEcfszuYz0RnPs4K3U_t4z7XdQjsNZpE+kkf@mail.gmail.com>
Subject: Re: [PATCH] Tight check of pfn_valid on sparsemem - v3
From: Minchan Kim <minchan.kim@gmail.com>
To: =?ISO-8859-1?Q?Penttil=E4_Mika?= <mika.penttila@ixonos.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/7/26 Penttilä Mika <mika.penttila@ixonos.com>:
> I don't think this works because if the memmap pages get reused, the corresponding struct page->private could be used by chance in such a way that it has the value of MEMMAP_HOLE. Of course unlikely but possible. And after all the whole point of freeing part of the memmap is that it could be reused.
>

You're absolutely right.
Previous version, I didn't do such as.
In this version, I wanted to remove dependency of page->private and
mem_section to identify hole memmap for using it in FLATMEM of ARM but
make mistake.
I will resend the patch

Thanks for careful review.

> --Mika
>
>
>
>



-- 
Kind regards,
Minchan Kim
