Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757728Ab0KOPB6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 10:01:58 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:44822 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756770Ab0KOPB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 10:01:56 -0500
Date: Mon, 15 Nov 2010 10:01:54 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Pete Zaitcev <zaitcev@redhat.com>
cc: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>,
        Greg Kroah-Hartman <gregkh@suse.de>, <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH, RFC] usbmon: correct computing of the ISO packets with
 mmap
In-Reply-To: <20101114204237.7cd9e1de@lembas.zaitcev.lan>
Message-ID: <Pine.LNX.4.44L0.1011150958230.1606-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Nov 2010, Pete Zaitcev wrote:

> > > +	while (ndesc-- != 0) {
> > > +		if (fp->status == 0 && fp->actual_length != 0) {
> > 
> > I'd leave out the fp->status == 0 test.  It's not relevant; a buffer 
> > can contain valid data even if the final status isn't 0.
> 
> That's a good point, however is actual_length filled in such case?
> I thought it was either one or the other.

No, it's possible to have both.  This is less likely with isochronous 
than with the other transfer types, but it can happen.  For example, 
consider a high-bandwidth high-speed transfer where 3072 bytes are 
received in three packets during a single microframe.  You might 
receive two of the three packets, giving actual_length = 2048, and then 
not receive the third, giving status = -EPROTO.

Alan Stern

