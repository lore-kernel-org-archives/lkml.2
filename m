Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760732Ab2DMKxV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 06:53:21 -0400
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:46068 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756860Ab2DMKxU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 06:53:20 -0400
From: Bhupesh SHARMA <bhupesh.sharma@st.com>
To: "balbi@ti.com" <balbi@ti.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>
Date: Fri, 13 Apr 2012 18:51:26 +0800
Subject: Enabling multiple gadgets on top of composite driver
Thread-Topic: Enabling multiple gadgets on top of composite driver
Thread-Index: Ac0ZY2AE0v++84kpQBKLUBGPpe+kAw==
Message-ID: <D5ECB3C7A6F99444980976A8C6D896384FA30FA942@EAPEX1MAIL1.st.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-hashedpuzzle: AilY BDVh F4EE HapX K629 LXtg LzSF VScU YE0c drdo eaYz
 fXCI gM+C gURc ij/j
 3Cz7;5;YgBhAGwAYgBpAEAAdABpAC4AYwBvAG0AOwBnAHIAZQBnAGsAaABAAGwAaQBuAHUAeABmAG8AdQBuAGQAYQB0AGkAbwBuAC4AbwByAGcAOwBsAGkAbgB1AHgALQBrAGUAcgBuAGUAbABAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnADsAbABpAG4AdQB4AC0AdQBzAGIAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA7AHMAdABlAHIAbgBAAHIAbwB3AGwAYQBuAGQALgBoAGEAcgB2AGEAcgBkAC4AZQBkAHUA;Sosha1_v1;7;{7BFDDAF7-55B1-4181-9556-FA5B44681664};YgBoAHUAcABlAHMAaAAuAHMAaABhAHIAbQBhAEAAcwB0AC4AYwBvAG0A;Fri,
 13 Apr 2012 10:51:26
 GMT;RQBuAGEAYgBsAGkAbgBnACAAbQB1AGwAdABpAHAAbABlACAAZwBhAGQAZwBlAHQAcwAgAG8AbgAgAHQAbwBwACAAbwBmACAAYwBvAG0AcABvAHMAaQB0AGUAIABkAHIAaQB2AGUAcgA=
x-cr-puzzleid: {7BFDDAF7-55B1-4181-9556-FA5B44681664}
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a query regarding enabling multiple gadgets (like g_webcam, g_zero etc..)
on top of the Composite driver.

My use case is very simple:
	- I want to expose a USB composite device to a standard USB host, where
	  the Composite device supports a webcam gadget + zero gadget + some other gadget..

On the older kernels like 2.6.27, this was easily possible, but the latest
gadget code doesn't seem to support the same:
	- I can see that first a 'choicemenu' is provided which allows selection of only
	  one gadget at a time.

	- The "common" stuff like "composite.c", "epautoconfig.c" have been included in
	  each f_* function driver (for e.g. f_uvc.c, f_sourcesink.c, etc..), so even if
	  I somehow tweak the 'choicemenu' stuff, I get redeclaration errors.

	- If I somehow separate the "common" stuff and compile the same separately and
	  then compile zero gadget, webcam gadget etc.., I see that the 'usb_composite_probe'
	  call of only the 1st gadget passes correctly, but from the 2nd gadget driver
        onwards as 'composite' is already present the following check in 'usb_composite_probe'
	  fails:

		if(!driver || !driver->dev || !bind || composite)
			return -EINVAL;

I am hoping someone else must also have faced an issue like this before..

What is the best way to enable multiple gadgets (like g_webcam, g_zero etc..)
on top of the Composite driver or am I missing something here?

Regards,
Bhupesh
	
 
