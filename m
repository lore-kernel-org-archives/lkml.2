Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097Ab1HBL6r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 07:58:47 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:47807 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754050Ab1HBL6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 07:58:40 -0400
Date: Tue, 2 Aug 2011 14:56:37 +0300
From: Dan Carpenter <error27@gmail.com>
To: Florian Mickler <florian@mickler.org>
Cc: linux-kernel@vger.kernel.org, Tino Keitel <tino.keitel@tikei.de>,
        mchehab@infradead.org
Subject: Re: USB related "unable to handle kernel paging request" in 3.0.0-rc7
Message-ID: <20110802115637.GE4516@shale.localdomain>
References: <20110722192722.GA9369@x61.home>
 <20110802085447.GA4522@shale.localdomain>
 <20110802115145.25b6a445@schatten.dmk.lab>
 <20110802124028.3b8dcd5a@schatten.dmk.lab>
 <20110802131039.0972ff30@schatten.dmk.lab>
 <20110802135117.3f13c1bc@schatten.dmk.lab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110802135117.3f13c1bc@schatten.dmk.lab>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 02, 2011 at 01:51:17PM +0200, Florian Mickler wrote:

> ok. I see the problem now. The buffer get's initialzed a little bit too late
> because it already get's used from the dvb_usb_device_init call via the
> frontend attach call:
> 
> dvb_usb_device_init->dvb_usb_init->dvb_usb_adapter_init->dvb_usb_adapter_frontend_init->vp7045_frontend_attach->vp7045_usb_op 
> 
> Hm.. let me think about it. In the meantime, you don't need to test
> this 'fix'.

Yep.  That would do it.  But my fix would still work nicely.

Don't forget to remove the kfree(d->priv) from vp7045_usb_disconnect()
because that would be automatic now.

regards,
dan carpenter

