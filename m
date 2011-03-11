Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068Ab1CKM5p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 07:57:45 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:61220 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308Ab1CKM5o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 07:57:44 -0500
MIME-Version: 1.0
In-Reply-To: <201103110858.29140.arnd@arndb.de>
References: <1299822897-7047-1-git-send-email-nobuhiro.iwamatsu.yj@renesas.com>
 <201103110858.29140.arnd@arndb.de>
From: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Date: Fri, 11 Mar 2011 21:57:23 +0900
X-Google-Sender-Auth: -znPf3BlDuWCZLASL_gamf3hIBY
Message-ID: <AANLkTinLjPyZuNnWs-XfdtQQ1wrnKRZ=4LitYwxnZaJ7@mail.gmail.com>
Subject: Re: [PATCH 1/2] tty: serial: Fix build on architecture that does not
 have ioport
To: Arnd Bergmann <arnd@arndb.de>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thanks for your comment!

2011/3/11 Arnd Bergmann <arnd@arndb.de>:
> On Friday 11 March 2011 06:54:56 Nobuhiro Iwamatsu wrote:
>> Some CPU's do not have ioport. Therefore, these do not have inX/outX.
>> Because they define CONFIG_NO_IOPORT, These CPU's use this and do not
>> use inX/outX.
>>
>> Signed-off-by: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
>
> I like this patch, I had played with something similar before
> but never got it to the state where I was happy with submitting
> it. I'd really like to get us to the point where platforms without
> PCI support do don't need to define inb/outb and can still
> use all other drivers.
>
> There are two small improvements that I would like to suggest
> to this patch:
>
> * use #ifdef CONFIG_SERIAL_8250_HUB6 to configure out hub6 support.
>  It's already disabled on most systems, so we can save a bit
>  binary code without making the driver uglier.
>

OK.

> * Introduce a new CONFIG_SERIAL_8250_IOPORT symbol and make
>  the normal io_serial_* code depend on that. It can be a silent
>  Kconfig symbol that automatically gets selected in the appropriate
>  cases. I find this clearer than the double negation in "not no ioport".
>  The code that is used in both HUB6 and regular cases can be under
>  this symbol.
>

Yes, you are right. I will send new patch.

Thanks!

Nobuhiro

-- 
Nobuhiro Iwamatsu
