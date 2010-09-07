Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276Ab0IGHAj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 03:00:39 -0400
Received: from cantor.suse.de ([195.135.220.2]:38389 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751494Ab0IGHAd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 03:00:33 -0400
Date: Mon, 6 Sep 2010 23:59:37 -0700
From: Greg KH <gregkh@suse.de>
To: Raju Rameshwar Uprade <rajsingh@ncra.tifr.res.in>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Regarding USB-serial device driver
Message-ID: <20100907065937.GA22307@suse.de>
References: <20100907061327.M12473@admin-gateway.ncra.tifr.res.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100907061327.M12473@admin-gateway.ncra.tifr.res.in>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 07, 2010 at 11:44:50AM +0530, Raju Rameshwar Uprade wrote:
> 
> Hi Greg,
>                I have a UART device  driver which is used to control some  MCM ( Monitor
> & control module ) devices with  address like 2,3,5,10,14 & 0 thru serial port using
> RS-485 interface card.
> 
> Now I want to control these devices thru usb-serial adaptor card.When I plug the
> usb-to-serial device.It's shows me the terminal ttyUSB0.
> 
> I tried sending data thru it , but in between some junk data is also going out ....
> 
> output of usbmon :
> 
>  ee26be80 3612838323 S Co:7:002:0 s 40 01 0008 0000 0000 0
> ee26be80 3612839660 C Co:7:002:0 0 0
> ee26be80 3612839716 S Co:7:002:0 s 40 01 0009 0000 0000 0
> ee26be80 3612840660 C Co:7:002:0 0 0
> ee26be80 3612840700 S Ci:7:002:0 s a1 21 0000 0000 0007 7 <
> ee26be80 3612841661 C Ci:7:002:0 0 7 = 80250000 000008
> ee26be80 3612841710 S Co:7:002:0 s 21 20 0000 0000 0007 7 = 80250000 000008
> ee26be80 3612842659 C Co:7:002:0 0 7 >
> ee26be80 3612842672 S Co:7:002:0 s 21 22 0003 0000 0000 0
> ee26be80 3612843657 C Co:7:002:0 0 0
> ee2b3800 3612843712 S Ci:7:002:0 s a1 21 0000 0000 0007 7 <
> ee2b3800 3612844658 C Ci:7:002:0 0 7 = 80250000 000008
> ee2b3800 3612844668 S Co:7:002:0 s 40 01 0000 0000 0000 0
> ee2b3800 3612845660 C Co:7:002:0 0 0
> ee0eaf80 3612845669 S Bi:7:002:3 -115 256 <
> ee0ead00 3612845674 S Ii:7:002:1 -115:1 10 <
> ee2b3800 3612845679 S Co:7:002:0 s 21 22 0003 0000 0000 0
> ee2b3800 3612846657 C Co:7:002:0 0 0
> ee0ea680 3618022849 S Bo:7:002:2 -115 100 = 00080000 00000000 f8000000 00000000 00000000
> 00000000 00000000 00000000
> ee0ea680 3618024532 C Bo:7:002:2 0 100 >
> 
> 
> Ideally data which should go out is : 0080000000f8.( device address is 0 and check sum
> is f8 ).

Wierd.  If you enable debugging in the driver:
	modprobe pl2303 debug=1
do you also see the kernel log showing extra data going out to the host?

What is your userspace program doing?  Are you sure you are only writing
6 bytes?  The bulk out should only be writing the actual data in the
buffer, not any more than that.

Do you have an example userspace code that we can use to test with?

thanks,

greg k-h
