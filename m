Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007Ab0HPIPG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 04:15:06 -0400
Received: from eir.is.scarlet.be ([193.74.71.27]:40852 "EHLO eir.is.scarlet.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752607Ab0HPIPE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 04:15:04 -0400
X-Greylist: delayed 432 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Aug 2010 04:15:03 EDT
From: Dries Van Puymbroeck <Dries.VanPuymbroeck@dekimo.com>
To: Xiaofan Chen <xiaofanc@gmail.com>, Michal Nazarewicz <mina86@mina86.com>
CC: Dries Van Puymbroeck <dries.van.puymbroeck@gmail.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Greg KH <greg@kroah.com>,
        =?iso-8859-2?Q?Micha=B3_Nazarewicz?= <m.nazarewicz@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 16 Aug 2010 10:07:43 +0200
Subject: RE: [PATCH] USB: Gadget: g_multi: added INF file for gadget with
 multiple configurations
Thread-Topic: [PATCH] USB: Gadget: g_multi: added INF file for gadget with
 multiple configurations
Thread-Index: Acs7js04Nfc0aY89RhuXiz/MX8m52gBh9m9w
Message-ID: <189BD93C867E884A88BE71B66BE9F30F28DAD81F0D@mailhost.dekimo.com>
References: <1281691874-8154-1-git-send-email-dries.vanpuymbroeck@dekimo.com>
	<AANLkTikk7T6v8zwzEQuZ7yDgf6AcdEfNJr7BG+z1O02n@mail.gmail.com>
	<87sk2i45es.fsf@erwin.mina86.com>
	<AANLkTin_o36qmavka+aJaDOBpNRGc=xxKdPdtWWUcVG8@mail.gmail.com>
	<87r5i1h9lh.fsf@erwin.mina86.com>
 <AANLkTi=5+SEZ-=UCv8Oisgq==pyJpsgJ3tFKc0CdyXLw@mail.gmail.com>
In-Reply-To: <AANLkTi=5+SEZ-=UCv8Oisgq==pyJpsgJ3tFKc0CdyXLw@mail.gmail.com>
Accept-Language: en-US
Content-Language: nl-NL
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-DCC-scarlet.be-Metrics: eir; whitelist
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, sorry for the delay in answering; 


FROM: Xiaofan Chen [mailto:xiaofanc@gmail.com] 
SENT: vrijdag 13 augustus 2010 15:32
TO: Dries Van Puymbroeck
CC: linux-usb@vger.kernel.org; Greg KH; Micha³ Nazarewicz; Micha³ Nazarewicz; Dries Van Puymbroeck; linux-kernel@vger.kernel.org
Onderwerp: Re: [PATCH] USB: Gadget: g_multi: added INF file for gadget with multiple configurations

>I did see something similar for WMCDC.
>http://msdn.microsoft.com/en-us/library/ff538833%28VS.85%29.aspx
>http://msdn.microsoft.com/en-us/library/ff537100%28v=VS.85%29.aspx

This is actually what I based my INF file on. Maybe I should mention that in the comments in the INF?


FROM: Xiaofan Chen [mailto:xiaofanc@gmail.com] 
SENT: zaterdag 14 augustus 2010 3:28
TO: Michal Nazarewicz
CC: Dries Van Puymbroeck; linux-usb@vger.kernel.org; Greg KH; Micha³ Nazarewicz; Dries Van Puymbroeck; linux-kernel@vger.kernel.org
Onderwerp: Re: [PATCH] USB: Gadget: g_multi: added INF file for gadget with multiple configurations

>Obviously you have the device to test, I would be interested to know your
>test results under XP, Vista and Win7.

Yes, I do have an embedded device running the g_multi driver, and have experimented with both 1 configuration (RNDIS) and 2 condfigurations (RNDIS and CDC ECM) on several windows versions (XP, Vista 32 and 64 bit, Windows 7 32 and 64 bit)

When running 1 configuration the device works: windows loads usbccgp.sys and all interfaces are detected (and the linux.inf file can be used). 

This is true for all versions I have tested except for Windows 7 64 bit. It seems here that the RNDIS interface is not detected as a network adapter but as an 'other usb device.' This then makes windows not show a driver install wizard (where one would choose the INF file). It is possible to go into the device manager and configure the RNDIS device manually as a network adapter, after which everything works the same as on other windows versions. Do you have any idea why this only happens on Windows 7 64 bit specifically? (Vista 64 bit and Windows 7 32 bit do not have this behavior, leaving me confused)

When running 2 configurations the device is simply detected as a "multifunction composite device". Usbccgp.sys is not loaded. It is possible to install linux.inf for this device, but then only the first interface (ie: the Ethernet over USB functionality) will be available, any other interfaces such as mass storage devices are not available then. What my INF file does is load usbccgp.sys so that linux.inf can use its multiple interfaces.


-----Oorspronkelijk bericht-----
FROM: Xiaofan Chen [mailto:xiaofanc@gmail.com] 
SENT: zaterdag 14 augustus 2010 10:58
TO: Michal Nazarewicz
CC: Dries Van Puymbroeck; linux-usb@vger.kernel.org; Greg KH; Micha³ Nazarewicz; Dries Van Puymbroeck; linux-kernel@vger.kernel.org
Onderwerp: Re: [PATCH] USB: Gadget: g_multi: added INF file for gadget with multiple configurations

>Thanks. Now it is clear. The patch is correct after all.

Thanks!

>Somehow I forgot the following blog entry again. This blog entry
>seems to be more clear than the MSDN entries.

Yes, it is, thanks for pointing this out to me, I had not found this webpage yet.
