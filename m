Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879Ab1KNCph (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 21:45:37 -0500
Received: from smtp.microsoft.com ([131.107.115.214]:27152 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753501Ab1KNCpf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 21:45:35 -0500
From: KY Srinivasan <kys@microsoft.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "joe@perches.com" <joe@perches.com>
Subject: RE: [PATCH 1/1] Staging: hv: Move the mouse driver out of staging
Thread-Topic: [PATCH 1/1] Staging: hv: Move the mouse driver out of staging
Thread-Index: AQHMlb5tFmjUXJbXLkiQVEJ5ygNb75WeV3qAgAJF/pCAAN+mgIAKW5AAgABP/YD//5n0oA==
Date: Mon, 14 Nov 2011 02:45:34 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481AA6C1ED@TK5EX14MBXC128.redmond.corp.microsoft.com>
References: <1319841316-29136-1-git-send-email-kys@microsoft.com>
 <20111105064739.GA31111@core.coreip.homeip.net>
 <6E21E5352C11B742B20C142EB499E0481AA68580@TK5EX14MBXC128.redmond.corp.microsoft.com>
 <20111107055109.GA21095@core.coreip.homeip.net>
 <alpine.LNX.2.00.1111132100000.15187@pobox.suse.cz>
 <20111114004745.GA3666@core.coreip.homeip.net>
In-Reply-To: <20111114004745.GA3666@core.coreip.homeip.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.23]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Dmitry Torokhov [mailto:dmitry.torokhov@gmail.com]
> Sent: Sunday, November 13, 2011 7:48 PM
> To: Jiri Kosina
> Cc: KY Srinivasan; gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; ohering@suse.com;
> joe@perches.com
> Subject: Re: [PATCH 1/1] Staging: hv: Move the mouse driver out of staging
> 
> On Sun, Nov 13, 2011 at 09:01:28PM +0100, Jiri Kosina wrote:
> > On Sun, 6 Nov 2011, Dmitry Torokhov wrote:
> >
> > > > I am not a hid expert; but all  hid low level drivers appear to do this.
> > > > Initially, I was directly invoking hid_connect() directly and based on your
> > > > Input, I chose to use hid_hw_start() which all other drivers are using.
> > >
> > > Note that the users of hid_hw_start() actually are not low level
> > > drivers, such as usbhid or bluetooth hidp, but higher-level drivers,
> > > such as hid-wacom, hid-a4tech, etc. Since your driver is a low-level
> > > driver (a provider so to speak) it should not call hid_hw_start() on its
> > > own but rather wait for the hid code to do it.
> > >
> > > Still, I am not a HID expert either so I'll defer to Jiri here.
> >
> > Hi,
> >
> > my understanding is that hv driver is actually a bit special in this
> > respect -- it's actually all-in-one both low-level and high-level driver.
> > I take it that there is not ever going to be a different high-level driver
> > using low-level hv transport (is that correct, KY?), so this might indeed
> > be an acceptable layout of the driver.
> >
> 
> I actually do not see anything of a high-level driver in hv-mouse. It is
> a pure transport driver that channels everything through hid-input...

The split architecture (in my opinion) makes sense if there are multiple consumers
of that transport. In this case though, there is not going to be any other drivers
using this transport. As you have noted, there really is not any code in this driver that
would qualify as being the high level driver. 

Regards,

K. Y

