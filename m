Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751771Ab1BVTwn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 14:52:43 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:36708 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717Ab1BVTwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 14:52:41 -0500
X-Authority-Analysis: v=1.1 cv=dquaJDitHqzHCdqWSoZ6IgapSuTzW/4TaRYx9N9k4W8= c=1 sm=0 a=b8VkJ_G4jssA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=pGLkceISAAAA:8 a=JarWaZbUt8hDu0CuQqwA:9 a=eCLDxAW2kLqXyuqNbTGiZtBWYj0A:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=MSl-tDqOz04A:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] rt2x00: Use ops name instead of device name
From: Steven Rostedt <rostedt@goodmis.org>
To: Ivo Van Doorn <ivdoorn@gmail.com>
Cc: Ben Hutchings <bhutchings@solarflare.com>,
        LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>, abogani@texware.it
In-Reply-To: <AANLkTinNUnq7JQDpTzCv24A7T7fMn9iPFisQEBZGkELr@mail.gmail.com>
References: <1298380368.6140.1193.camel@gandalf.stny.rr.com>
	 <1298381695.2211.486.camel@localhost>
	 <1298382263.6140.1196.camel@gandalf.stny.rr.com>
	 <AANLkTinNUnq7JQDpTzCv24A7T7fMn9iPFisQEBZGkELr@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 22 Feb 2011 14:52:38 -0500
Message-ID: <1298404358.7666.5.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-22 at 20:33 +0100, Ivo Van Doorn wrote:
> Hi,
> 
> On Tue, Feb 22, 2011 at 2:44 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > On Tue, 2011-02-22 at 13:34 +0000, Ben Hutchings wrote:
> >
> >> > 19:   73474106          0   IO-APIC-fasteoi   ata_piix, uhci_hcd:usb6, 0000:05:01.0
> >
> >> >     rt2x00dev->irq = pci_dev->irq;
> >> > -   rt2x00dev->name = pci_name(pci_dev);
> >> > +   rt2x00dev->name = ops->name;
> >
> >
> >> But then how can users distinguish the IRQs for multiple devices handled
> >> by the same driver?  (Probably unusual for WLAN devices, but still
> >> possible.)
> >>
> >> I assume you can't use a net device name as there may be multiple net
> >> devices per bus device?
> >
> > Honestly, I do not know this code well enough, but this patch seemed to
> > solve the problem at hand. Hence I sent it out to the experts hoping
> > they either take this patch or come up with a proper solution ;)
> >
> > In any case, just posting the pci address is not a pretty answer.
> 
> I just checked the other wireless drivers, and they all seem to use
> the modulename. So I guess your patch is correct. You can add my:
> 
> Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

Thanks!

Actually, to answer Ben's question. lspci should give you what you want.

On my local box (not the one mentioned above):

$ lspci -vv
[...]
00:0a.0 Bridge: nVidia Corporation CK804 Ethernet Controller (rev a3)
        Subsystem: Tyan Computer Tomcat K8E (S2865)
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx+
        Latency: 0 (250ns min, 5000ns max)

        Interrupt: pin A routed to IRQ 23

        Region 0: Memory at febf9000 (32-bit, non-prefetchable) [size=4K]
        Region 1: I/O ports at b400 [size=8]
        Capabilities: <access denied>
        Kernel driver in use: forcedeth


(spaces added by me)

$ cat /proc/interrupts
[...]
 23:        547     648564   IO-APIC-fasteoi   ohci_hcd:usb2, eth0


-- Steve

