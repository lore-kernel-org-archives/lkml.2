Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080Ab1CVNML (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 09:12:11 -0400
Received: from cantor.suse.de ([195.135.220.2]:38177 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756020Ab1CVNMJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 09:12:09 -0400
From: Oliver Neukum <oneukum@suse.de>
To: Florian Mickler <florian@mickler.org>
Subject: Re: [PATCH 0/6] get rid of on-stack dma buffers
Date: Tue, 22 Mar 2011 14:12:46 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc8-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: "Roedel, Joerg" <Joerg.Roedel@amd.com>,
        "Greg Kroah-Hartman" <greg@kroah.com>,
        "janne-dvb@grunau.be" <janne-dvb@grunau.be>,
        "g.marco@freenet.de" <g.marco@freenet.de>,
        "tskd2@yahoo.co.jp" <tskd2@yahoo.co.jp>,
        "liplianin@me.by" <liplianin@me.by>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pb@linuxtv.org" <pb@linuxtv.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "max@veneto.com" <max@veneto.com>,
        "mchehab@infradead.org" <mchehab@infradead.org>,
        "aet@rasterburn.org" <aet@rasterburn.org>,
        "mkrufky@linuxtv.org" <mkrufky@linuxtv.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        "js@linuxtv.org" <js@linuxtv.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Andy Walls <awalls@md.metrocast.net>,
        "nick@nick-andrew.net" <nick@nick-andrew.net>
References: <1300732426-18958-1-git-send-email-florian@mickler.org> <20110322104426.GA20444@amd.com> <AANLkTimXobrwc-XHgoVN1dD5NCTde64dykbyvtJMo229@mail.gmail.com>
In-Reply-To: <AANLkTimXobrwc-XHgoVN1dD5NCTde64dykbyvtJMo229@mail.gmail.com>
Organization: SUSE
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Message-Id: <201103221412.46507.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 22. März 2011, 14:08:17 schrieb Florian Mickler:
> Am 22.03.2011 12:10 schrieb "Roedel, Joerg" <Joerg.Roedel@amd.com>:
> >
> > On Mon, Mar 21, 2011 at 05:03:15PM -0400, Florian Mickler wrote:
> > > I guess (not verified), that the dma api takes sufficient precautions
> > > to abort the dma transfer if a timeout happens.  So freeing _should_
> > > not be an issue. (At least, I would expect big fat warnings everywhere
> > > if that were the case)
> >
> > Freeing is very well an issue. All you can expect from the DMA-API is to
> > give you a valid DMA handle for your device. But it can not prevent that
> > a device uses this handle after you returned it. You need to make sure
> > yourself that any pending DMA is canceled before calling kfree().
> 
> Does usb_control_msg do this? It waits for completion but takes also a
> timeout parameter. I will recheck this once I'm home.

It uses usb_start_wait_urb() which upon a timeout kills the URB. The
buffer is unused after usb_control_msg() returns.

	HTH
		Oliver
