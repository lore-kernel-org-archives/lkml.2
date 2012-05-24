Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757630Ab2EXP7g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 11:59:36 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:58996 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757281Ab2EXP7f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 11:59:35 -0400
Date: Thu, 24 May 2012 17:02:28 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kay Sievers <kay@vrfy.org>
Subject: Re: [RFC PATCH] USB: remove CONFIG_USB_DEVICEFS
Message-ID: <20120524170228.2f61c2e2@pyramind.ukuu.org.uk>
In-Reply-To: <CAAJw_Zug=xFjzaguqfq+-HYBjmwDPJ+5Ntj=otMY4MJk2UWxDQ@mail.gmail.com>
References: <20120426001529.GA14006@kroah.com>
	<Pine.LNX.4.44L0.1204261103120.1530-100000@iolanthe.rowland.org>
	<20120426151242.GA14774@kroah.com>
	<CAAJw_Zug=xFjzaguqfq+-HYBjmwDPJ+5Ntj=otMY4MJk2UWxDQ@mail.gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 May 2012 23:55:16 +0800
Jeff Chua <jeff.chua.linux@gmail.com> wrote:

> On Thu, Apr 26, 2012 at 11:12 PM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > On Thu, Apr 26, 2012 at 11:06:45AM -0400, Alan Stern wrote:
> >> On Wed, 25 Apr 2012, Greg Kroah-Hartman wrote:
> >>
> >> > This option has been deprecated for many years now, and no userspace
> >> > tools use it anymore, so it should be safe to finally remove it.
> >> >
> >> > Reported-by: Kay Sievers <kay@vrfy.org>
> >> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >> >
> >> > Anyone object to me queuing this up for the 3.5 kernel release?
> >>
> >> I'm not sure about this.  There are a few systems still floating around
> >> that don't use udev; on those systems /proc/bus/usb is the only way for
> >> user programs to control USB devices.  Admittedly, I have no idea
> >> whether any such systems will be using 3.5 or later kernels...
> >
> > They don't have to use udev, they can use devtmpfs (which is what the
> > majority of embedded systems use today), or they can just use static
> > device nodes to get access to these devices, the char node is still
> > present, we aren't getting rid of them at all.
> 
> Looks like vmware is breaking. Can't find any usb devices. I'm not using udev.

Perhaps a WARN_ON_ONCE would be safer for a bit ?
