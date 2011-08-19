Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756343Ab1HSQfu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 12:35:50 -0400
Received: from ist.d-labs.de ([213.239.218.44]:34282 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754844Ab1HSQft (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 12:35:49 -0400
Date: Fri, 19 Aug 2011 18:35:21 +0200
From: Florian Mickler <florian@mickler.org>
To: mchehab@infradead.org
Cc: Florian Mickler <florian@mickler.org>, tino.keitel@tikei.de,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        "v3.0.y" <stable@kernel.org>
Subject: Re: [PATCH] [media] vp7045: fix buffer setup
Message-ID: <20110819183521.1b5f7efe@schatten.dmk.lab>
In-Reply-To: <1312970720-25694-1-git-send-email-florian@mickler.org>
References: <20110809200842.GA29662@mac.home>
	<1312970720-25694-1-git-send-email-florian@mickler.org>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Aug 2011 12:05:20 +0200
Florian Mickler <florian@mickler.org> wrote:

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
> References: https://bugzilla.kernel.org/show_bug.cgi?id=40062
> Cc: v3.0.y <stable@kernel.org>
> Tested-by: Tino Keitel <tino.keitel@tikei.de>
> Signed-off-by: Florian Mickler <florian@mickler.org>

...ping...
