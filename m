Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617Ab0JYJa6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 05:30:58 -0400
Received: from dhruva1.ncra.tifr.res.in ([158.144.12.129]:60485 "EHLO
	dhruva1.ncra.tifr.res.in" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754386Ab0JYJa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 05:30:56 -0400
From: "Raju Rameshwar Uprade" <rajsingh@ncra.tifr.res.in>
To: Greg KH <greg@kroah.com>,
        Raju Rameshwar Uprade <rajsingh@ncra.tifr.res.in>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: pl2303 ttyUSB0: pl2303_write - failed submitting write urb, error -22
Date: Mon, 25 Oct 2010 15:00:35 +0530
Message-Id: <20101025092607.M73014@admin-gateway.ncra.tifr.res.in>
In-Reply-To: <20101019124713.GA31828@kroah.com>
References: <20101018102001.M46961@admin-gateway.ncra.tifr.res.in> <20101019033522.GA32577@kroah.com> <20101019050336.M39015@admin-gateway.ncra.tifr.res.in> <20101019124713.GA31828@kroah.com>
X-Mailer: OpenWebMail 2.53 (08:Aug:2008)
X-OriginatingIP: 158.144.12.129
MIME-Version: 1.0
Content-Type: text/plain;
	charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > > What kernel version are you using?
> > > 
> > 
> > I am using kernel version 2.6.25.I cann't use current linux kernel version because it
> > uses the generic write function and for my application I need pl2303_write.
> 
> Then you are really on your own here, sorry.
> 
> good luck,
> 
> greg k-h


Hi Greg.
             
          I am now able to transmit the Address byte with mark parity and data bytes
with space parity properly.

Thanks a lot greg for you help....

Below is the control signal and data going out on USB bus number 7.

f5aafd00 2277683484 S Co:7:002:0 s 21 20 0000 0000 0007 7 = 80250000 000308  // Control
signal for  mark parity

f5aafd00 2277684456 C Co:7:002:0 0 7 >
f5aafd00 2277684497 S Co:7:002:0 s 21 22 0003 0000 0000 0
f5aafd00 2277685456 C Co:7:002:0 0 0
f2b8e900 2277685476 S Bo:7:002:2 -115 1 = 05        // Address byte
f5aafd00 2277685482 S Ci:7:002:0 s a1 21 0000 0000 0007 7 <
f5aafd00 2277686455 C Ci:7:002:0 0 7 = 80250000 000308
f2b8e900 2277686461 C Bo:7:002:2 0 1 >
f5aafd00 2277686518 S Co:7:002:0 s 21 20 0000 0000 0007 7 = 80250000 000408            
       // Control signal for Space parity
f5aafd00 2277687457 C Co:7:002:0 0 7 >
f2b8e900 2277687471 S Bo:7:002:2 -115 8 = 08000000 000000f8  // Data bytes
f5aafd00 2277687474 S Ci:7:002:0 s a1 21 0000 0000 0007 7 <
f5aafd00 2277688455 C Ci:7:002:0 0 7 = 80250000 000408
f2b8e900 2277688461 C Bo:7:002:2 0 8 >
f5aafd00 2277697534 S Co:7:002:0 s 21 22 0000 0000 0000 0
f5aafd00 2277698456 C Co:7:002:0 0 0
f2b8e580 2277700457 C Ii:7:002:1 0:1 10 = a1200000 00000200 4000  // What I am receiving
currently.
f2b8e580 2277700486 S Ii:7:002:1 -115:1 10 <
f2b8e580 2277702455 C Ii:7:002:1 0:1 10 = a1200000 00000200 4000
f2b8e580 2277702478 S Ii:7:002:1 -115:1 10 <
f2b8e580 2277704455 C Ii:7:002:1 0:1 10 = a1200000 00000200 4000
f2b8e580 2277704477 S Ii:7:002:1 -115:1 10 <
f2b8e580 2277706457 C Ii:7:002:1 0:1 10 = a1200000 00000200 4000
f2b8e580 2277706480 S Ii:7:002:1 -115:1 10 <
f2b8e580 2277708455 C Ii:7:002:1 0:1 10 = a1200000 00000200 4000
f2b8e580 2277708476 S Ii:7:002:1 -115:1 10 <
f2b8e580 2277710455 C Ii:7:002:1 0:1 10 = a1200000 00000200 4000
f2b8e580 2277710484 S Ii:7:002:1 -115:1 10 <
f2b8e580 2277712455 C Ii:7:002:1 0:1 10 = a1200000 00000200 4000
f2b8e580 2277712477 S Ii:7:002:1 -115:1 10 <
f2b8e580 2277714454 C Ii:7:002:1 0:1 10 = a1200000 00000200 4000
f2b8e580 2277714471 S Ii:7:002:1 -115:1 10 <
f2b8e580 2277716452 C Ii:7:002:1 0:1 10 = a1200000 00000200 4000
f2b8e580 2277716464 S Ii:7:002:1 -115:1 10 <
f2b8e580 2277718455 C Ii:7:002:1 0:1 10 = a1200000 00000200 0000
f2b8e580 2277718480 S Ii:7:002:1 -115:1 10 <


Thanks & Regards,
 Raj.
