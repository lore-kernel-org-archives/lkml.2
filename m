Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483Ab1KXPAU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 10:00:20 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63423 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193Ab1KXPAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 10:00:18 -0500
MIME-Version: 1.0
In-Reply-To: <20111123041728.GA11864@redhat.com>
References: <20111031143408.GA17152@redhat.com>
	<1321992902.8072.7.camel@wwguy-ubuntu>
	<20111123024545.GA9703@redhat.com>
	<1322015380.11647.82.camel@wwguy-huron>
	<20111123033446.GB9703@redhat.com>
	<1322016965.11647.95.camel@wwguy-huron>
	<20111123041728.GA11864@redhat.com>
Date: Thu, 24 Nov 2011 17:00:16 +0200
Message-ID: <CANUX_P1jUa=Ww_fwyzbHL7kHyvCnaKB+fXKfAt+6fjHm_wGr_A@mail.gmail.com>
Subject: Re: 3.1+ iwlwifi lockup
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Dave Jones <davej@redhat.com>, "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: multipart/mixed; boundary=00504502d1f25937fb04b27c4bf0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00504502d1f25937fb04b27c4bf0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

can you please that one ?
it solves a race in mac80211 (thanks to Johannes) ?

It should solved the annoying WARN_ON about the bad shape of the AGG
state machine.

Thanks

Emmanuel Grumbach
egrumbach@gmail.com



On Wed, Nov 23, 2011 at 06:17, Dave Jones <davej@redhat.com> wrote:
> On Tue, Nov 22, 2011 at 06:56:05PM -0800, Guy, Wey-Yi wrote:
> =A0> Agree, that is why I could not re-produce here after many try. Could=
 you
> =A0> share your configuration, such as
>
> =A0> band/channel
>
> Channel:1
> Frequency:2.412 GHz (Channel 1)
>
> =A0> 32/64 bit system
>
> 64bit. It's a Dell Adamo laptop.
>
> =A0> 20/40 MHz
>
> not sure how to find out what you're looking for.
>
> =A0> traffic type
>
> last triggered it with just ssh.
>
> =A0> open/security
>
> IE: IEEE 802.11i/WPA2 Version 1
> =A0 =A0Group Cipher : CCMP
> =A0 =A0Pairwise Ciphers (1) : CCMP
> =A0 =A0Authentication Suites (1) : PSK
>
> =A0> power management
>
> nothing special. everything is default.
>
> all messages related to iwlwifi in dmesg are below..
>
> =A0 =A0 =A0 =A0Dave
>
> [ =A0 24.423300] Intel(R) Wireless WiFi Link AGN driver for Linux, in-tre=
e:d
> [ =A0 24.425560] Copyright(c) 2003-2011 Intel Corporation
> [ =A0 24.428667] iwlwifi 0000:04:00.0: PCI INT A -> GSI 17 (level, low) -=
> IRQ 17
> [ =A0 24.437959] iwlwifi 0000:04:00.0: setting latency timer to 64
> [ =A0 24.438108] iwlwifi 0000:04:00.0: pci_resource_len =3D 0x00002000
> [ =A0 24.444058] iwlwifi 0000:04:00.0: pci_resource_base =3D ffffc9001157=
4000
> [ =A0 24.445823] iwlwifi 0000:04:00.0: HW Revision ID =3D 0x0
> [ =A0 24.447695] iwlwifi 0000:04:00.0: irq 46 for MSI/MSI-X
> [ =A0 24.447896] iwlwifi 0000:04:00.0: Detected Intel(R) Ultimate N WiFi =
Link 5300 AGN, REV=3D0x24
> [ =A0 24.453070] iwlwifi 0000:04:00.0: L1 Enabled; Disabling L0S
> [ =A0 24.486217] iwlwifi 0000:04:00.0: device EEPROM VER=3D0x120, CALIB=
=3D0x4
> [ =A0 24.489176] iwlwifi 0000:04:00.0: Device SKU: 0Xf0
> [ =A0 24.490778] iwlwifi 0000:04:00.0: Tunable channels: 13 802.11bg, 24 =
802.11a channels
> [ =A0 24.520548] iwlwifi 0000:04:00.0: loaded firmware version 8.83.5.1 b=
uild 33692
> [ =A0 39.229498] iwlwifi 0000:04:00.0: L1 Enabled; Disabling L0S
> [ =A0 39.240818] iwlwifi 0000:04:00.0: Radio type=3D0x0-0x2-0x0
> [ =A0 39.607327] iwlwifi 0000:04:00.0: L1 Enabled; Disabling L0S
> [ =A0 39.613424] iwlwifi 0000:04:00.0: Radio type=3D0x0-0x2-0x0
> [ =A0210.248807] iwlwifi 0000:04:00.0: Tx aggregation enabled on ra =3D b=
8:c7:5d:0c:39:87 tid =3D 6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

--00504502d1f25937fb04b27c4bf0
Content-Type: text/x-patch; charset=US-ASCII; name="sync_tx_stop.patch"
Content-Disposition: attachment; filename="sync_tx_stop.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gvdvzooa0

ZGlmZiAtLWdpdCBhL25ldC9tYWM4MDIxMS9hZ2ctdHguYyBiL25ldC9tYWM4MDIxMS9hZ2ctdHgu
YwppbmRleCAzOWQ3MmNjLi4yZGJlZDc5IDEwMDY0NAotLS0gYS9uZXQvbWFjODAyMTEvYWdnLXR4
LmMKKysrIGIvbmV0L21hYzgwMjExL2FnZy10eC5jCkBAIC0xODgsNiArMTg4LDggQEAgaW50IF9f
X2llZWU4MDIxMV9zdG9wX3R4X2JhX3Nlc3Npb24oc3RydWN0IHN0YV9pbmZvICpzdGEsIHUxNiB0
aWQsCiAJICovCiAJY2xlYXJfYml0KEhUX0FHR19TVEFURV9PUEVSQVRJT05BTCwgJnRpZF90eC0+
c3RhdGUpOwogCisJc3luY2hyb25pemVfbmV0KCk7CisKIAl0aWRfdHgtPnN0b3BfaW5pdGlhdG9y
ID0gaW5pdGlhdG9yOwogCXRpZF90eC0+dHhfc3RvcCA9IHR4OwogCg==
--00504502d1f25937fb04b27c4bf0--
