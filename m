Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757659Ab1EaTH2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 15:07:28 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:52960 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754480Ab1EaTH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 15:07:27 -0400
Date: Tue, 31 May 2011 15:07:24 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Brokhman Tatyana <tlinder@codeaurora.org>
cc: greg@kroah.com, <linux-usb@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>, <balbi@ti.com>,
        <ablay@codeaurora.org>, open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v14 9/9] usb: Adding SuperSpeed support to dummy_hcd
In-Reply-To: <d79240883d4be37a08d6720830423a6a.squirrel@www.codeaurora.org>
Message-ID: <Pine.LNX.4.44L0.1105311453350.1830-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 May 2011, Brokhman Tatyana wrote:

> Hi Alan,
> 
> > If is_super_speed is false, shouldn't you avoid registering the
> > SuperSpeed hub?  Or would that add too many complications?
> 
> It woun't add too many complications but I would prefere not to do that.
> My goal was to simulate as much as posible "real" USB connection so the
> is_super_speed flag simulates the USB port you connect to, HS/SS.

The terms "HS port" and "SS port" don't really mean anything.  A
physical port connected to a USB-3 controller will run at either HS or
SS depending on the cable and device plugged into it.

>  When
> working with a real host if you connect a HS device to a SS port it
> connects to a HS root hub but the SS root hub is functional and
> registered.

The correct way to express this is: If you connect a HS device to a
USB-3 controller then it connects to the HS root hub, but the SS root
hub is functional and present.

That's true, but it misses the point of my question.  Does the
"is_super_speed" module parameter refer to dummy-hcd's emulated _host_
controller or to the emulated _device_ controller?  (Or does it perhaps 
refer to both?)

If it refers to the emulated host controller then there should be no SS
root hub.  But if it refers only to the emulated device controller then
there should be.

Let's put it another way.  If the "is_super_speed" module parameter is 
set to False then we know that the emulated connection will never run 
at SS.  Therefore there's no point in registering a SS root hub.

Alan Stern

