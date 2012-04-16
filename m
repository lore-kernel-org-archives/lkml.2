Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752292Ab2DPIQy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 04:16:54 -0400
Received: from eu1sys200aog118.obsmtp.com ([207.126.144.145]:49592 "EHLO
	eu1sys200aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752009Ab2DPIQv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 04:16:51 -0400
From: Bhupesh SHARMA <bhupesh.sharma@st.com>
To: "balbi@ti.com" <balbi@ti.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>
Date: Mon, 16 Apr 2012 16:15:00 +0800
Subject: RE: Enabling multiple gadgets on top of composite driver
Thread-Topic: Enabling multiple gadgets on top of composite driver
Thread-Index: Ac0ZZG0vL4ObRSZiST+HKRggpTcGswCRGSFw
Message-ID: <D5ECB3C7A6F99444980976A8C6D896384FA41864D4@EAPEX1MAIL1.st.com>
References: <D5ECB3C7A6F99444980976A8C6D896384FA30FA942@EAPEX1MAIL1.st.com>
 <20120413105921.GM7154@arwen.pp.htv.fi>
In-Reply-To: <20120413105921.GM7154@arwen.pp.htv.fi>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-hashedpuzzle: Cw8F KV5w L7Uq NSQ3 NyB4 US6S VLE5 aK3g dr6T erBe fHd8
 iuGl khCB l31K mDSn
 v8uS;5;YgBhAGwAYgBpAEAAdABpAC4AYwBvAG0AOwBnAHIAZQBnAGsAaABAAGwAaQBuAHUAeABmAG8AdQBuAGQAYQB0AGkAbwBuAC4AbwByAGcAOwBsAGkAbgB1AHgALQBrAGUAcgBuAGUAbABAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnADsAbABpAG4AdQB4AC0AdQBzAGIAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA7AHMAdABlAHIAbgBAAHIAbwB3AGwAYQBuAGQALgBoAGEAcgB2AGEAcgBkAC4AZQBkAHUA;Sosha1_v1;7;{907B2D7F-5496-4891-B35C-EB37147FBA32};YgBoAHUAcABlAHMAaAAuAHMAaABhAHIAbQBhAEAAcwB0AC4AYwBvAG0A;Mon,
 16 Apr 2012 08:15:00
 GMT;UgBFADoAIABFAG4AYQBiAGwAaQBuAGcAIABtAHUAbAB0AGkAcABsAGUAIABnAGEAZABnAGUAdABzACAAbwBuACAAdABvAHAAIABvAGYAIABjAG8AbQBwAG8AcwBpAHQAZQAgAGQAcgBpAHYAZQByAA==
x-cr-puzzleid: {907B2D7F-5496-4891-B35C-EB37147FBA32}
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

> -----Original Message-----
> From: Felipe Balbi [mailto:balbi@ti.com]
> Sent: Friday, April 13, 2012 4:29 PM
> To: Bhupesh SHARMA
> Cc: balbi@ti.com; gregkh@linuxfoundation.org; linux-
> usb@vger.kernel.org; linux-kernel@vger.kernel.org;
> stern@rowland.harvard.edu
> Subject: Re: Enabling multiple gadgets on top of composite driver
> 
> On Fri, Apr 13, 2012 at 06:51:26PM +0800, Bhupesh SHARMA wrote:
> > Hi,
> >
> > I have a query regarding enabling multiple gadgets (like g_webcam,
> > g_zero etc..) on top of the Composite driver.
> >
> > My use case is very simple:
> > 	- I want to expose a USB composite device to a standard USB host,
> where
> > 	  the Composite device supports a webcam gadget + zero gadget +
> some other gadget..
> 
> look at how nokia.c does it.

Ok.
 
> > On the older kernels like 2.6.27, this was easily possible, but the
> > latest gadget code doesn't seem to support the same:
> > 	- I can see that first a 'choicemenu' is provided which allows
> selection of only
> > 	  one gadget at a time.
> 
> Answer M instead of Y to "USB Gadget Drivers"
> 
> > 	- The "common" stuff like "composite.c", "epautoconfig.c" have
> been included in
> > 	  each f_* function driver (for e.g. f_uvc.c, f_sourcesink.c,
> etc..), so even if
> > 	  I somehow tweak the 'choicemenu' stuff, I get redeclaration
> errors.
> 
> yeah, that still needs to be cleaned up. The story behind that is very
> long.
> 
> > What is the best way to enable multiple gadgets (like g_webcam,
> g_zero
> > etc..) on top of the Composite driver or am I missing something here?
> 
> Either you want multiple gadgets or you want a composite gadget, what
> is it ? If you want a composite gadget, you need to write a small C
> file which combines multiple functions together (see nokia.c), if you
> want multiple gadget drivers, just make them all modules. I always
> compile all gadget drivers as modules and can use any one of them at
> any time.
> 

Thanks for your help.
I need to support multiple functions over a composite gadget. I will now
have a quick look at the 'nokia.c' driver.

Regards,
Bhupesh
