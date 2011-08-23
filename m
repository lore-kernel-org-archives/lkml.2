Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175Ab1HWQY6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 12:24:58 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:53670 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890Ab1HWQYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 12:24:52 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Bryan Donlan <bdonlan@gmail.com>
Subject: Re: contention on long-held spinlock
Date: Tue, 23 Aug 2011 18:24:48 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Ortwin =?iso-8859-1?q?Gl=FCck?= <odi@odi.ch>, linux-kernel@vger.kernel.org,
        Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-driver@qlogic.com,
        linux-scsi@vger.kernel.org
References: <4E4E2B2A.40100@odi.ch> <CAF_S4t_5qfx1H+nm+fvYd24k4ezF__JDFLvg6gv_so8SeVqKvA@mail.gmail.com>
In-Reply-To: <CAF_S4t_5qfx1H+nm+fvYd24k4ezF__JDFLvg6gv_so8SeVqKvA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108231824.48512.arnd@arndb.de>
X-Provags-ID: V02:K0:Y8TR6PJssY6dqASJzgjQZgYFtgpPyhxTfmHz2ZC79Ys
 EOcceuGK+UmWZw+/MXQgDGeq6HXJR6XDtkSYVHsHhLVmqwNGtY
 vOUWjlu9K7+4xcqM2pwlXIvEQBSKmQZAFgmPP+HVvbQAW8N004
 FgnYxjz6nRI2PhtqGXY5vku1Vh9YcuaSyTBPOy7b05vqAXsY23
 KqT4n7pHRT3/9OLxdYsMw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 19 August 2011, Bryan Donlan wrote:
> That's what mutexes are for. Note, however, that interrupt handlers
> cannot use mutexes as they cannot sleep, nor can they wait for lock
> holders which may themselves sleep.

I agree that there is probably some other bug that needs to be fixed
in the driver, but for testing it may well be worth replacing
the spinlock with a mutex and the request_irq with request_threaded_irq.
A threaded IRQ is slower than a normal one but does allow mutexes.

	Arnd
