Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758105Ab1FPRUQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 13:20:16 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43275 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932103Ab1FPRUN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 13:20:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PZ2ALvuArZlD1bQj77l3vO0rq/J+i+Z5NhVQ55iPpymIHiinLNKe98/yeW6Xcslqpq
         sYP43ikuAyvtqLlvkkMGwD9hn5KwVput3NSNGXAfZZKPdBz88YP6oB/dpq8dVKzHQN/y
         GnCQrBbIV6BYpXRv6Icj1bBTjFs6ZYjsYEvWo=
MIME-Version: 1.0
In-Reply-To: <BANLkTikXUd8uorD+juMDvFubr3cz+OZnaQ@mail.gmail.com>
References: <BANLkTikXUd8uorD+juMDvFubr3cz+OZnaQ@mail.gmail.com>
Date: Thu, 16 Jun 2011 19:20:12 +0200
Message-ID: <BANLkTinUxRGkXeOtBSKi51n3Q_rZEp1gUg@mail.gmail.com>
Subject: Re: Faking MMIO ops? Fooling a driver
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Pekka Paalanen <pq@iki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

W dniu 16 czerwca 2011 16:44 użytkownik Rafał Miłecki
<zajec5@gmail.com> napisał:
> I analyze MMIO dumps of closed source driver and found such a place:
> W 2 3855.911536 9 0xb06003fc 0x810 0x0 0
> R 2 3855.911540 9 0xb06003fe 0x0 0x0 0
> W 2 3855.911541 9 0xb06003fe 0x0 0x0 0
>
> After translation:
>  phy_read(0x0810) -> 0x0000
> phy_write(0x0810) <- 0x0000
>
> So it's quite obvious, the driver is reading PHY register, masking it
> and writing masked value. Unfortunately from just looking at such
> place we can not guess the mask driver uses.
>
> I'd like to fake value read from 0xb06003fe to be 0xFFFF.
> Is there some ready method for doing such a trick?
>
> Dump comes from Kernel hacking → Tracers → MMIO and ndiswrapper.

I can see values in MMIO trace struct are filled in
arch/x86/mm/mmio-mod.c in "pre" and "post". However still no idea how
to hack the returned value.

Should I try hacking read[bwl] instead? :|

-- 
Rafał
