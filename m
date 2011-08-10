Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752950Ab1HJCRd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 22:17:33 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:58915 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751361Ab1HJCRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 22:17:32 -0400
X-Sasl-enc: ZJjExMB1PRoQCR1tYfA4WEcNryXZs8IrOrTaRAtvLPH0 1312942651
Date: Tue, 9 Aug 2011 19:16:30 -0700
From: Greg KH <greg@kroah.com>
To: "Murali K. Vemuri" <vemuri.muralikrishna@gmail.com>
Cc: Ryan Mallon <rmallon@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: kernel panic with simple driver
Message-ID: <20110810021630.GA23748@kroah.com>
References: <CAME+iufMQT-pWzxgc79NyZq-hW-6QU9FAJd1SV_UR+zR2erPOQ@mail.gmail.com>
 <4E41D3FB.9080802@gmail.com>
 <CAME+iuf=mNy=s16y6LFZ7MpFWFg26UxjTF64o6smtC3=WgERkw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAME+iuf=mNy=s16y6LFZ7MpFWFg26UxjTF64o6smtC3=WgERkw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 10, 2011 at 10:33:28AM +0900, Murali K. Vemuri wrote:
> There is no concurrent access to the timer. The design is that:
> 1.Driver provides an IOCTL for start / stop
> 2. when the driver receives START IOCTL, it toggles some GPIOs to ON / OFF.
> 3. the GPIOs will be ON for 500 MSec and OFF for 500 MSec.
> 4. Two successive START IOCTLs will not be honored.
> 5. There is only one application that uses these IOCTLs
> 6. When I receive a STOP IOCTL, I am doing :
> if (timer_pending (&my_timer))
> del_timer(&my_timer);

What kind of driver is this?  For what type of hardware?

Can't you control the gpios from userspace with out any need to write a
kernel driver?

thanks,

greg k-h
