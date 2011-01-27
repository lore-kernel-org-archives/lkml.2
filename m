Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411Ab1A0UrT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 15:47:19 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49740
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753077Ab1A0UrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 15:47:18 -0500
Date: Thu, 27 Jan 2011 12:47:52 -0800 (PST)
Message-Id: <20110127.124752.71123363.davem@davemloft.net>
To: fdinitto@redhat.com
Cc: akpm@linux-foundation.org, fabbione@fabbione.net, rdunlap@xenotime.net,
        jmorris@namei.org, kees.cook@canonical.com, mingo@elte.hu,
        namhyung@gmail.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] console: allow to retain boot console via boot option
 keep_bootcon
From: David Miller <davem@davemloft.net>
In-Reply-To: <4D4182A7.5050503@redhat.com>
References: <20110119161918.1f827080.akpm@linux-foundation.org>
	<4D37D18D.9060402@redhat.com>
	<4D4182A7.5050503@redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Fabio M. Di Nitto" <fdinitto@redhat.com>
Date: Thu, 27 Jan 2011 15:35:19 +0100

> According to kernel/print.k:
> 
>>         /*
>>          * By unregistering the bootconsoles after we enable the real console
>>          * we get the "console xxx enabled" message on all the consoles -
>>          * boot consoles, real consoles, etc - this is to ensure that end
>>          * users know there might be something in the kernel's log buffer that
>>          * went to the bootconsole (that they do not see on the real console)
>>          */
> 
> but my understanding, and please correct if I am wrong, is that when we
> load or initialize modules such as fbcon (I made this patch debugging a
> crash in atyfb), a console is indeed registered and bootconsole disable,
> while in reality the real console is not there yet (in my case fbcon was
> loaded but not atyfb yet).
> At a later stage, once atyfb is loaded, it registers with fbcon and then
> the console output starts again.

It's not exactly "fbcon", it's the "VT" driver.

That loads, and nothing has attached to VT yet to provide the actual
console hookup.

"fbcon" waits until a usable driver registers before it hooks itself
into the "VT" layer.

So this is why we have this large gap of time with no console output.
It's because VT registers before it actually is able to provide
console output services, and frankly that's a bug. :-)

