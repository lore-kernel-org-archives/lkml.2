Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759604Ab2IFTrn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 15:47:43 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:62937 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758690Ab2IFTrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 15:47:31 -0400
Message-ID: <5048FDCF.8020602@suse.cz>
Date: Thu, 06 Sep 2012 21:47:27 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: Tomas Hlavacek <tmshlvck@gmail.com>
CC: gregkh@linuxfoundation.org, alan@linux.intel.com,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        marek.vasut@gmail.com
Subject: Re: [PATCH v6] uartclk value from serial_core exposed to sysfs
References: <1344929718-22736-1-git-send-email-tmshlvck@gmail.com> <1346894238-12870-1-git-send-email-tmshlvck@gmail.com> <5048E35F.5020304@suse.cz> <CAEB7QLAWLuXFLWMYX70enP5X0z5EXTNo93hfOm7sH_kQteMAkA@mail.gmail.com> <5048F161.3000805@suse.cz> <CAEB7QLAk6pe9ih+P_621fZE3JpRcFpPA+Wzk57x3FmVaGmoOKg@mail.gmail.com>
In-Reply-To: <CAEB7QLAk6pe9ih+P_621fZE3JpRcFpPA+Wzk57x3FmVaGmoOKg@mail.gmail.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/2012 09:41 PM, Tomas Hlavacek wrote:
>> * why are you passing tty_port to the struct device's private data and
>> not uart_port proper? Is this for some future use?
> 
> I actually used the uart_port structure in older RFC versions of the
> patch. Alan Cox advised to use struct tty_port because of consistency.
> More precisely he said (in an e-mail from Aug 12):
> 
> I'd rather however it pointed
> to the tty_port that each tty device has (or very soon will be required
> to have).

Yes, this is already a requirement in tty-next. And every driver has to
provide us with the tty_port as you might persuaded yourself of that
already ;).

> You can still find the uart_foo structs from that but it means
> we can do the dev_set_drvdata() in a consistent manner for all tty
> devices in the kernel. That in turn means we can make some of the sysfs
> valid the same way.

Ah, OK, makes sense.

>> * cannot be all those attribute structs const?
> 
> It seems that making
> 
> static const struct attribute *tty_dev_attrs[] = ...
> 
> produces warning:
> 
> drivers/tty/serial/serial_core.c:2334:2: warning: initialization from
> incompatible pointer type [enabled by default]
> drivers/tty/serial/serial_core.c:2334:2: warning: (near initialization
> for ‘tty_dev_attr_group.attrs’) [enabled by default]
> 
> But others can. I am going to make them const in following patch.

Ok, it was only a suggestion. I did not know either.

regards,
-- 
js
suse labs
