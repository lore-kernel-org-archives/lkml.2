Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031493Ab2I1W0o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 18:26:44 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:48519 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932191Ab2I1W0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 18:26:42 -0400
X-Sasl-enc: O56uiHIDO+5ryiTK1hJrkQGacE/NGgNjnBK3ZezaPHa1 1348871201
Date: Fri, 28 Sep 2012 15:26:40 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Cc: Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
        Vinicius Costa Gomes <vinicius.gomes@openbossa.org>
Subject: Re: [ 056/127] Bluetooth: Fix not removing power_off delayed work
Message-ID: <20120928222640.GA2309@kroah.com>
References: <20120928203045.835238916@linuxfoundation.org>
 <20120928203052.382739768@linuxfoundation.org>
 <1348870383.6858.5.camel@deadeye.wl.decadent.org.uk>
 <20120928221927.GC15454@joana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120928221927.GC15454@joana>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 07:19:27PM -0300, Gustavo Padovan wrote:
> * Ben Hutchings <ben@decadent.org.uk> [2012-09-29 00:13:03 +0200]:
> 
> > On Fri, 2012-09-28 at 13:33 -0700, Greg Kroah-Hartman wrote:
> > > 3.0-stable review patch.  If anyone has any objections, please let me know.
> > > 
> > > ------------------
> > > 
> > > From: Vinicius Costa Gomes <vinicius.gomes@openbossa.org>
> > > 
> > > commit 78c04c0bf52360dc2f7185e99c8e9aa05d73ae5a upstream.
> > > 
> > > For example, when a usb reset is received (I could reproduce it
> > > running something very similar to this[1] in a loop) it could be
> > > that the device is unregistered while the power_off delayed work
> > > is still scheduled to run.
> > [...]
> > > --- a/net/bluetooth/hci_core.c
> > > +++ b/net/bluetooth/hci_core.c
> > > @@ -588,6 +588,8 @@ static int hci_dev_do_close(struct hci_d
> > >  {
> > >  	BT_DBG("%s %p", hdev->name, hdev);
> > >  
> > > +	cancel_delayed_work(&hdev->power_off);
> > [...]
> > 
> > This is not right for 3.0 as the type of hdev->power_off is struct
> > work_struct, not struct delayed_work.
> > 
> > When I looked at this for 3.2 it appeared that this fix might not be
> > required at all.
> 
> Yes, at that time we had a timer to run the work, at some point we changed it
> with a delayed_work but I don't remember exactly which version was it, 3.3 I
> think.

Thanks for letting me know, I'll go delete this from the 3.0 queue.

greg k-h
