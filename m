Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167Ab1CVO1f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 10:27:35 -0400
Received: from ist.d-labs.de ([213.239.218.44]:46867 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755239Ab1CVO1e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 10:27:34 -0400
MIME-Version: 1.0
In-Reply-To: <20110322104426.GA20444@amd.com>
References: <1300732426-18958-1-git-send-email-florian@mickler.org>
	<a08d026a-d4c3-4ee5-b01a-d561f755b1ec@email.android.com>
	<20110321220315.7545a61a@schatten.dmk.lab>
	<20110322104426.GA20444@amd.com>
Date: Tue, 22 Mar 2011 15:27:30 +0100
Message-ID: <AANLkTimJm-Fd0siuuOKgmHWq2L7h0LB=wZ-6E_ZuK=wK@mail.gmail.com>
Subject: Re: [PATCH 0/6] get rid of on-stack dma buffers
From: Florian Mickler <florian@mickler.org>
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
Cc: Andy Walls <awalls@md.metrocast.net>,
        "mchehab@infradead.org" <mchehab@infradead.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "js@linuxtv.org" <js@linuxtv.org>,
        "tskd2@yahoo.co.jp" <tskd2@yahoo.co.jp>,
        "liplianin@me.by" <liplianin@me.by>,
        "g.marco@freenet.de" <g.marco@freenet.de>,
        "aet@rasterburn.org" <aet@rasterburn.org>,
        "pb@linuxtv.org" <pb@linuxtv.org>,
        "mkrufky@linuxtv.org" <mkrufky@linuxtv.org>,
        "nick@nick-andrew.net" <nick@nick-andrew.net>,
        "max@veneto.com" <max@veneto.com>,
        "janne-dvb@grunau.be" <janne-dvb@grunau.be>,
        Oliver Neukum <oliver@neukum.org>, Greg Kroah-Hartman <greg@kroah.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        James Bottomley <James.Bottomley@hansenpartnership.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/3/22 Roedel, Joerg <Joerg.Roedel@amd.com>:
> On Mon, Mar 21, 2011 at 05:03:15PM -0400, Florian Mickler wrote:
>> I guess (not verified), that the dma api takes sufficient precautions
>> to abort the dma transfer if a timeout happens.  So freeing _should_
>> not be an issue. (At least, I would expect big fat warnings everywhere
>> if that were the case)
>
> Freeing is very well an issue. All you can expect from the DMA-API is to
> give you a valid DMA handle for your device. But it can not prevent that
> a device uses this handle after you returned it. You need to make sure
> yourself that any pending DMA is canceled before calling kfree().

sorry, I meant usb_control_msg above when I said 'dma api'... as that
is the function these
drivers use to do the dma.

Regards,
Flo
