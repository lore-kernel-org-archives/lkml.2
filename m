Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466Ab1HSGUE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 02:20:04 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:54959 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849Ab1HSGUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 02:20:00 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Markus Rechberger <mrechberger@gmail.com>
Subject: Re: [PATCH] Increase usbfs bulk buffer size
Date: Fri, 19 Aug 2011 08:23:06 +0200
User-Agent: KMail/1.13.5 (Linux/3.1.0-rc1-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <CA+O4pCKfWLP+ohfUVi811CRbmrb2FyoMwkmxxGJ1TF2kKtGDEA@mail.gmail.com> <201108171914.52257.oliver@neukum.org> <CA+O4pCK3vZjZwM0D7Q0gzsTZRJC1PfzYvoVmq-g2jJQ=uP_6ug@mail.gmail.com>
In-Reply-To: <CA+O4pCK3vZjZwM0D7Q0gzsTZRJC1PfzYvoVmq-g2jJQ=uP_6ug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108190823.06638.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 17. August 2011, 19:44:16 schrieb Markus Rechberger:
> I understand that USBFS is not 100% optimized, although we are already
> using 3-4 times that much buffer with isochronous and it was working
> fine for years so far as long as the system doesn't run out of memory
> .. but even kerneldrivers would have issues with it in such a
> situation.

The problem is not what happens on your test system dedicated to this use.
There it'll work. But you allowed everybody else to make the kernel request
the second largest chunk of memory there is. On a otherwise busy system
with fragmented memory this is not good.

As I said, you want scatter/gather if you need this.
There still would be the problem with the API, but if this is really a problem,
you could define a new ioctl()

	Regards
		Oliver
