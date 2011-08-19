Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311Ab1HSKpr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 06:45:47 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:62626 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847Ab1HSKpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 06:45:43 -0400
MIME-Version: 1.0
In-Reply-To: <201108190823.06638.oliver@neukum.org>
References: <CA+O4pCKfWLP+ohfUVi811CRbmrb2FyoMwkmxxGJ1TF2kKtGDEA@mail.gmail.com>
	<201108171914.52257.oliver@neukum.org>
	<CA+O4pCK3vZjZwM0D7Q0gzsTZRJC1PfzYvoVmq-g2jJQ=uP_6ug@mail.gmail.com>
	<201108190823.06638.oliver@neukum.org>
Date: Fri, 19 Aug 2011 12:45:42 +0200
Message-ID: <CA+O4pCKteFZBT0UMetuk4-gsUf4wG3DXnOooW47GWD7o=dgpQQ@mail.gmail.com>
Subject: Re: [PATCH] Increase usbfs bulk buffer size
From: Markus Rechberger <mrechberger@gmail.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 19, 2011 at 8:23 AM, Oliver Neukum <oliver@neukum.org> wrote:
> Am Mittwoch, 17. August 2011, 19:44:16 schrieb Markus Rechberger:
>> I understand that USBFS is not 100% optimized, although we are already
>> using 3-4 times that much buffer with isochronous and it was working
>> fine for years so far as long as the system doesn't run out of memory
>> .. but even kerneldrivers would have issues with it in such a
>> situation.
>
> The problem is not what happens on your test system dedicated to this use.
> There it'll work. But you allowed everybody else to make the kernel request
> the second largest chunk of memory there is. On a otherwise busy system
> with fragmented memory this is not good.
>
> As I said, you want scatter/gather if you need this.
> There still would be the problem with the API, but if this is really a problem,
> you could define a new ioctl()
>

let's say there are a few thousand users of the 190k isochronous implementation.
I don't want to add more complex code to the kernel, if it's not
accepted I'm okay with it,
since I know the performance impact I can recommend it to those who
are interested in it.
Our software works without it anyway, and Bulk is just for special use
in our case.

Best Regards,
Markus
