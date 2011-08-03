Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327Ab1HCTCK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 15:02:10 -0400
Received: from eazy.amigager.de ([213.239.192.238]:59521 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872Ab1HCTCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 15:02:03 -0400
Date: Wed, 3 Aug 2011 21:02:04 +0200
From: Tino Keitel <tino.keitel@tikei.de>
To: Florian Mickler <florian@mickler.org>
Cc: mchehab@infradead.org, linux-kernel@vger.kernel.org, error27@gmail.com
Subject: Re: [PATCH] [media] vp7045: fix buffer setup
Message-ID: <20110803190204.GA18377@mac.home>
Mail-Followup-To: Florian Mickler <florian@mickler.org>,
	mchehab@infradead.org, linux-kernel@vger.kernel.org,
	error27@gmail.com
References: <20110722192722.GA9369@x61.home>
 <1312288145-22292-1-git-send-email-florian@mickler.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312288145-22292-1-git-send-email-florian@mickler.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 02, 2011 at 14:29:05 +0200, Florian Mickler wrote:
> dvb_usb_device_init calls the frontend_attach method of this driver which
> uses vp7045_usb_ob. In order to have a buffer ready in vp7045_usb_op, it has to
> be allocated before that happens.
> 
> Luckily we can use the whole private data as the buffer as it gets separately
> allocated on the heap via kzalloc in dvb_usb_device_init and is thus apt for
> use via usb_control_msg.
> 
> This fixes a
> 	BUG: unable to handle kernel paging request at 0000000000001e78
> 
> reported by Tino Keitel and diagnosed by Dan Carpenter.
> 
> Reported-by: Tino Keitel <tino.keitel@tikei.de>
> Reported-by: Dan Carpenter <error27@gmail.com>
> Signed-off-by: Florian Mickler <florian@mickler.org>
> ---
> 
> Tino, can you test this?

Hi,

thanks for the patch. It works fine on top of 3.0. No more Oops at
boot, and the DVB-T receiver is working.

Regards,
Tino
