Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932441Ab0CXRmg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 13:42:36 -0400
Received: from web94910.mail.in2.yahoo.com ([203.104.17.172]:45920 "HELO
	web94910.mail.in2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932336Ab0CXRmf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 13:42:35 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.in;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=X/AX81Qp9ZT46CQgMlKY+kd5WqMnJAmR7Es/qBYLIV9Sy3noKqHnSjDvQdnxgOBf38YZgMKp9khwNxnTRDfWbwX/CMCnRmyX1ezQZmsfYGz+/pecdMPuvNoCM+OpOtc1yr5Fv4mQ/lVs7y5bssxMRO8Zf699ppCjN6k8F10NPms=;
Message-ID: <854009.90562.qm@web94910.mail.in2.yahoo.com>
X-YMail-OSG: OIH65OYVM1nG6XCiwQv8mV4YD26HD2fUymm.L3tU0ZG.ANU
 YDnHyqx1u4.nYDeUBPEQjJ.lSzA8PDiCWlE7lSSM2Vn8YvWEKF6P80VzXkVK
 n81Obj4cdYJMyEQck5osggl_PhrLuKP5FUTQ8qF2Oe7zHBNatPWPUEm7.Rp8
 NrhvrE78jElhudH_L2q2dySL4b6EUjzECVeXdr97yxqbm3LvHctSJ3m_4wwq
 D_rsjz.EtffPTvdYtMFgeaMV97Y0QFq.Xj5WofOet_j8w6gXeC9LWh8zTheH
 1WEVXxvO8G3mJFfJesKsYGD4-
X-Mailer: YahooMailClassic/10.0.8 YahooMailWebService/0.8.100.260964
Date: Wed, 24 Mar 2010 23:12:32 +0530 (IST)
From: Pavan Savoy <pavan_savoy@yahoo.co.in>
Subject: Re: [PATCH 4/6] drivers:misc: sources for Init manager module
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Greg KH <gregkh@suse.de>, PavanSavoy <pavan_savoy@ti.com>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1269450950.11714.126.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Wed, 24/3/10, Marcel Holtmann <marcel@holtmann.org> wrote:

> From: Marcel Holtmann <marcel@holtmann.org>
> Subject: Re: [PATCH 4/6] drivers:misc: sources for Init manager module
> To: "Pavan Savoy" <pavan_savoy@yahoo.co.in>
> Cc: "Greg KH" <gregkh@suse.de>, "PavanSavoy" <pavan_savoy@ti.com>, "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
> Date: Wednesday, 24 March, 2010, 10:45 PM
> Hi Pavan,
> 
> > > > > > I wanted to somehow put this in
> staging
> > > because then
> > > > > it would probably have a thorough
> architectural
> > > review
> > > > > process.
> > > > > > Some details about this driver - 
> > > > > > 
> > > > > > 1. This driver will be used by
> > > Bluetooth-BlueZ/FM-V4L2
> > > > > and GPS (probably character device
> driver) using
> > > the
> > > > > EXPORTED symbols
> (-register/_unregister).
> > > > > > 
> > > > > > 2. Much like the hciattach daemon
> which
> > > maintains
> > > > > N_HCI bluetooth line discipline, this
> driver will
> > > also have
> > > > > a User-Space  N_TI_WL Init manager
> (UIM)
> > > maintaining
> > > > > the Line discipline.
> > > > > 
> > > > > can you explain why you think this is
> needed and
> > > we can not
> > > > > interface
> > > > > this directly. If it is a serial port,
> what
> > > protocol does
> > > > > it talk?
> > > > 
> > > > Illustration: The BT driver on top of this
> ST driver,
> > > would create a hci0 interface, when someone does
> an DEVUP on
> > > that interface, the BT driver would then do a
> st-register -
> > > which in-turn would ask the hciattach-like daemon
> to install
> > > the line discipline for it via the sysfs entry.
> > > > The same concept goes for FM-V4L2 and GPS
> character
> > > driver.
> > > > 
> > > > The core of the problem is we cannot
> > > ask/install/ldisc_put for a line discipline from
> kernel
> > > space.
> > > 
> > > so let us get the facts straight here. The device
> in
> > > question is using a
> > > serial port to connect to the host and then
> multiplexing
> > > BT, FM and GPS
> > > over it. My question again, what protocol does it
> talk.
> > 
> > Ok, On TTY/4-wire UART, BT talks standard HCI, and
> HCI-LL for power management as in hci_ll.c/hciattach_ti.c
> which is already upstream.
> > 
> > And in a very similar way, FM talks over what is known
> as "channel 8" and GPS over "channel 9", Although these are
> not standard.
> > 
> > So, basically data going/coming to/out of chip is 
> > 1,2,3,4 - HCI 
> > 30,31,32,33 for HCI-LL
> > 8 - FM
> > 9 - GPS.
> > 
> > So consider this an extension of hci_ll/hci_ldisc but
> only more features to accomodate the FM and GPS.
> 
> So why are we not making the hci_ll into a generic driver
> that can
> register besides Bluetooth also FM and GPS.
> 
> Then we can attach that driver to the TTY via line
> discipline on boot
> and let the LL part handle the power management.
> 

Well hci_ll is tied up with hci_ldisc, we might not even want BT/FM on system, may be just GPS (like we have for 1 version of chip).
In that case GPS directly uses the ST line discipline.

Also few other things like firmware download, a chance for the ldisc driver to be platform device, to take in chip enable GPIOs, is sort of appropriate for a new driver isn't it ?


> Registration of Bluetooth device, FM and GPS nodes are done
> via RFKILL
> that the LL driver exports.
> 
> > > Also why not just install the line discipline and
> then
> > > control the
> > > subdevices via RFKILL?
> > 
> > The chip side PM would be fine, and is being done so,
> st_kim.c creates the rfkill entries, and controls them
> locally, also allows applications to control them.
> > But ldisc can't be install upon boot, because UART
> clks would be used up for no reason at all.
> > (say on a mobile phone, how many times in a day - do
> we actually use BT/FM or GPS - so UART needs to be most
> often idle, and ldisc should be installed only upon
> requirement)
> 
> I think the driver should make sure it doesn't use the UART
> clocks if in
> deep sleep. This has nothing to do with installing the line
> discipline
> on boot via a userspace tool.
> 
> You do the power management for the hci_ll driver already
> today. So why
> can't we do the same in this driver?
> 

Correct, However that piece of Android code, as far as I have seen it depends on bunch of interfaces provided by the UART driver.
This ldisc on other hand doesn't can work on 8250 driver or with complicated ones like the omap-serial which provides such interfaces to shut off UART clks as and when required.

> Another way to view this is that the LL driver has to
> create a virtual
> bus for Bluetooth, FM and GPS devices. However RFKILL might
> be a bit
> more suitable and simpler.
> 

Currently rfkill provided is just sort of an extension, but really it just depends on what protocol (bt, fm, GPS) is being ST_registered, the relevant chip_enable gpio is picked up from platform_device entry in arch/XX/board-YY.c and enabled.

> Regards
> 
> Marcel
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


      The INTERNET now has a personality. YOURS! See your Yahoo! Homepage. http://in.yahoo.com/
