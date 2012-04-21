Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253Ab2DUAck (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 20:32:40 -0400
Received: from netrider.rowland.org ([192.131.102.5]:53229 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751557Ab2DUAcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 20:32:39 -0400
Date: Fri, 20 Apr 2012 20:32:37 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Greg KH <greg@kroah.com>
cc: Wang YanQing <Udknight@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [RFC]Is usb port number fixed?
In-Reply-To: <20120420153727.GA29331@kroah.com>
Message-ID: <Pine.LNX.4.44L0.1204202028250.19313-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Apr 2012, Greg KH wrote:

> > Make the question precise.
> > I assme there are two usb ports in my notebook at left and right separately.
> > When I plug mouse into 
> > left usb port, I get 2-1.1:1.0
> > right usb port, I get 2-1.2:1.0
> > 
> > I want to know whether it is right that no matter how many times I reboot the machine,
> 
> Not always.
> 
> > the test result above will be the same.And if it will be the same, then why it will be the same.
> 
> You got lucky :)
> 
> USB ports on a hub are all enumerated the same, but the root hubs
> aren't, and sometimes hubs on the same bus are not as well.
> 
> But usually, things do come up in the same way all the time, so
> depending on your use case, you can rely on this, but it is recommended
> that you look for something else a bit more unique, like a serial number
> on a device (if it is present), if you wish to uniquely identify a
> device all the time.

In this particular case, it is guaranteed that the left USB port will 
always be numbered as X-1.1:1.0 and the right port as X-1.2:1.0, where 
the number X may change from one boot to another.  But the -1.1:1.0 and 
-1.2:1.0 parts will always be the same.

This is because X is the bus number, which is allowed to change.  The 
-1.1:1.0 and -1.2:1.0 values are port, configuration, and interface 
numbers.  They will never change, because they come from the hardware.

Alan Stern

