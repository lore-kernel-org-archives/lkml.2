Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757654Ab0IHGcb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 02:32:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59511 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751320Ab0IHGc2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 02:32:28 -0400
Date: Tue, 7 Sep 2010 23:17:19 -0700
From: Greg KH <gregkh@suse.de>
To: Raju Rameshwar Uprade <rajsingh@ncra.tifr.res.in>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Regarding USB-serial device driver
Message-ID: <20100908061719.GA23233@suse.de>
References: <20100907061327.M12473@admin-gateway.ncra.tifr.res.in> <20100907065937.GA22307@suse.de> <20100907114913.M69542@admin-gateway.ncra.tifr.res.in> <20100908034006.M11954@admin-gateway.ncra.tifr.res.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100908034006.M11954@admin-gateway.ncra.tifr.res.in>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 08, 2010 at 09:11:19AM +0530, Raju Rameshwar Uprade wrote:
> Greg, 
>       I am really sorry, that superfluous data was due to user space program.I have
> modified that.Now I am able to send correct data to the device. 5e and 40 is also going
> out.I don't know from where it is coming.
> But I am not getting the response.
> 
> output of usbmon :
> 
> ee9e1680 4108443204 C Co:7:003:0 0 0
> f6e80c00 4108443237 S Bo:7:003:2 -115 9 = 05080000 00000000 f8 // correct data bytes 

Good.

> f6e80c00 4108444202 C Bo:7:003:2 0 9 >
> ee9e1680 4108448251 S Co:7:003:0 s 21 22 0000 0000 0000 0
> ee9e1680 4108449202 C Co:7:003:0 0 0
> f6e80700 4108450204 C Bi:7:003:3 0 1 = 00
> ee9e1680 4108450546 S Co:7:003:0 s 21 22 0003 0000 0000 0
> f6e80900 4108451204 C Ii:7:003:1 0:1 10 = a1200000 00000200 0400
> f6e80900 4108451223 S Ii:7:003:1 -115:1 10 <
> ee9e1680 4108451227 C Co:7:003:0 0 0
> f6e80c00 4108451252 S Bo:7:003:2 -115 1 = 5e // don't know from where it is going out 

Something wrote it to the driver, did you try it with "debug=1" on the
modprobe line to see what the driver thinks is happening?

> f6e80c00 4108452201 C Bo:7:003:2 0 1 >
> f6e80900 4108453203 C Ii:7:003:1 0:1 10 = a1200000 00000200 0000

This was some status bytes coming back, are you sure you got the line
settings correct?

Your example .c file showed no line settings being set, so you have no
idea what baud rate you are sending at, or what the flow control is, or
anything else like that.  Please be sure to set that up properly to
verify that you really are getting the data out to the device properly.

thanks,

greg k-h
