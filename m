Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742Ab0CXSqM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 14:46:12 -0400
Received: from web94915.mail.in2.yahoo.com ([203.104.17.192]:29634 "HELO
	web94915.mail.in2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750772Ab0CXSqJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 14:46:09 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.in;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=PMQqA5b+jMupQ/6GlOeqMdGpSvDXHEQ1WrsKGIg3kdpUdWrex900MT0NLuowliEbVuMJ7ejaiVk5b7h3D3GpVt6Ne4FKRBQx6VG3KOCD8rrJCA/p3zbUl/it38aKdW9RG7kPlnqPAx+qkH6xdAI2wuVdfyg2aZXaqD2I4vZQZ/A=;
Message-ID: <538832.38767.qm@web94915.mail.in2.yahoo.com>
X-YMail-OSG: jzIe2lgVM1lyyOra5toJoKBf5kwpD_0eLSpHo0vSlHgPiej
 SP2WqfDO7iBO5WUE3EIlNx8sXfUlgnAiqiix3fFur9io.UKGZrW_CGImIDj0
 G08FLGgt34fi0haEtDc5uExDIk6qs9kgZBf1Fz.hBH0wxjZhFI3VF.fswpx3
 6Ub9rimNEWmimOa3bhSE9mVb7vL4NwvWg9.b7rlw7IVHJWIlG0zCSOBt23i4
 bLOcu5h_KdVQeccSQP94ZMXRE_wwTbSBQONqK2dkwafcAmjGn2IX3unnyFzA
 Qq1GcE.1N4MZ3R3WWT6hr6tF7C6oLDpEjAkuz
X-Mailer: YahooMailClassic/10.0.8 YahooMailWebService/0.8.100.260964
Date: Thu, 25 Mar 2010 00:16:03 +0530 (IST)
From: Pavan Savoy <pavan_savoy@yahoo.co.in>
Subject: Re: [PATCH 4/6] drivers:misc: sources for Init manager module
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Marcel Holtmann <marcel@holtmann.org>, Greg KH <gregkh@suse.de>,
       PavanSavoy <pavan_savoy@ti.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20100324173953.7fde7c84@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Wed, 24/3/10, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> From: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Subject: Re: [PATCH 4/6] drivers:misc: sources for Init manager module
> To: "Pavan Savoy" <pavan_savoy@yahoo.co.in>
> Cc: "Marcel Holtmann" <marcel@holtmann.org>, "Greg KH" <gregkh@suse.de>, "PavanSavoy" <pavan_savoy@ti.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
> Date: Wednesday, 24 March, 2010, 11:09 PM
> > Which puts me back to square 1,
> the requirement is TTY device should be open, only when
> either BT, FM or GPS would want to use it.
> > [with your patch one of the steps of installing ldisc
> would be reduced upon opening].
> 
> Perhaps but its up to you how you write your low level
> driver and how the
> ldisc indicates it wishes to be active (eg speed B0 is used
> to indicate
> 'no carrier' in many cases)
> 
> > Actually why do I even need a TTY device in this case
> - right ?
> > ldisc driver can do the tty->ops->write and
> tty_read and put it up on different interfaces like
> eth0/hci0 or /dev/radio0 etc..
> 
> You don't need a tty if you are simply demuxing some kind
> of stream of
> bytes to/from the hardware and you gain nothing from the
> tty layer and
> user space interfaces such as control signal and speed
> setting.
> 

I still want to maintain this as a ldisc driver and the TTY layer is still required to be able to use this with different sort of serial drivers.

example:
We do a have a system here where both 8250/omap-serial co-exist creating their own device nodes (ttyS for 8250, ttyO for omap-serial) and I would want to be able to on boot suggest which serial driver to use, so I can open/install ldisc on ttyS or on ttyO.


> That may be even cleaner in your case as you can then then
> provide
> suitable links between your demux and the drivers attached
> to it
> indicating when they should be on or off.

And as Marcel suggested, can't really put in the PM/UART-clk shut off code in ldisc driver because few of these driver provide interfaces and few don't.

So is there no way this can be accepted with the sysfs entry way of communication ?


      The INTERNET now has a personality. YOURS! See your Yahoo! Homepage. http://in.yahoo.com/
