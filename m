Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946Ab1KWOE4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 09:04:56 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59195 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755646Ab1KWOEy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 09:04:54 -0500
MIME-Version: 1.0
In-Reply-To: <20111123104449.5e845a0f@lxorguk.ukuu.org.uk>
References: <7187C142-99F1-4A96-9BE6-650B10C9B22D@gmail.com> <20111123104449.5e845a0f@lxorguk.ukuu.org.uk>
From: Xi Wang <xi.wang@gmail.com>
Date: Wed, 23 Nov 2011 09:04:11 -0500
Message-ID: <CAKU6vyY3WjVwTK5Tcp2W93DefjJMreZjhtudNHBALns=6bK9Jw@mail.gmail.com>
Subject: Re: [PATCH 1/2] ax25: integer overflows in ax25_setsockopt()
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, Joerg Reuter <jreuter@yaina.de>,
        Ralf Baechle <ralf@linux-mips.org>, David Miller <davem@davemloft.net>,
        linux-hams@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All these magic numbers come from net/ax25/sysctl_net_ax25.c, where
min/max values of each field are set for sysctl.  Is it okay to use
them?

- xi

On Wed, Nov 23, 2011 at 5:44 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>>       case AX25_T1:
>> -             if (opt < 1) {
>> +             if (opt < 1 || opt > 30) {
>
> Where do these values come from ? If they are from some 'standard' then
> really we should avoid restricting needlessly to it, particularly as
> AX.25 isn't well defined and is used for all sorts of crazy stuff where
> the usual range of settings isn't useful.
>
> Restricting to the point it would overflow makes sense however.
>
> Alan
>
>
