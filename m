Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497Ab0KXSNZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 13:13:25 -0500
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:55430
	"EHLO AM1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752511Ab0KXSNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 13:13:23 -0500
X-SpamScore: -21
X-BigFish: VS-21(zz936eK1432N98dN179dNzz1202hzzz2dh2a8h691h668h67dh685h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:az33egw02.freescale.net;RD:az33egw02.freescale.net;EFVD:NLI
Date: Wed, 24 Nov 2010 12:13:14 -0600
From: Scott Wood <scottwood@freescale.com>
To: <michael@ellerman.id.au>
CC: Timur Tabi <timur@freescale.com>, Greg KH <gregkh@suse.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stuart Yoder <stuart.yoder@freescale.com>,
        <devicetree-discuss@lists.ozlabs.org>
Subject: Re: How do I choose an arbitrary minor number for my tty device?
Message-ID: <20101124121314.503dd860@udp111988uds.am.freescale.net>
In-Reply-To: <1290594227.4446.12.camel@concordia>
References: <4CE44B1B.9040709@freescale.com>
 <20101117215147.GA26792@suse.de>
 <4CE452CD.3050001@freescale.com>
 <20101117221903.GA4066@suse.de>
 <4CE45A4E.70308@freescale.com>
 <20101118022434.GA9833@suse.de>
 <4CE546C5.8060401@freescale.com>
 <20101118153912.GA1443@suse.de>
 <4CE54E40.9040503@freescale.com>
 <20101118112146.3275eb08@udp111988uds.am.freescale.net>
 <4CE5657D.8060105@freescale.com>
 <20101118121356.3491da72@udp111988uds.am.freescale.net>
 <1290594227.4446.12.camel@concordia>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Nov 2010 18:14:27.0297 (UTC) FILETIME=[6E449510:01CB8C03]
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[sorry for the resend, fixed the devtree list address]

On Wed, 24 Nov 2010 21:23:47 +1100
Michael Ellerman <michael@ellerman.id.au> wrote:

> On Thu, 2010-11-18 at 12:13 -0600, Scott Wood wrote:
> > Unfortunately, it's not an exact match, and the fact that reg doesn't
> > translate to a physical address means that AFAICT you'll currently get
> > something like "byte-channel.nnn", where "nnn" is an arbitrary
> > kernel-assigned number.
> 
> Can you not use device_rename() ?

Ah, didn't know about that.  Still, might be nice to add support for
"handle" nodes at the infrastructure level rather than in each driver.

> > It would be nice if platform devices that are created from device tree
> > nodes included a link to the corresponding /proc/device-tree node in
> > their sysfs node.
> 
> It's not a link, but the OF path is in devspec, so you can work it out
> fairly easily.

Hmm, I see a "devspec" in PCI devices, but not in devtree-probed
platform devices.  of_bus_type_init isn't being called from anywhere
but the ibmebus code.  It looks like this was a casualty of merging
of_platform with platform (commit eca3930163ba8884060ce9d9ff5ef0d9b7c7b00f).

-Scott

