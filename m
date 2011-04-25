Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758490Ab1DYLOT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 07:14:19 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42089 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758475Ab1DYLOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 07:14:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=vx05mdYrlap48F4pJM3o/XUA0y6NI0fNDvgaP+wcO8fLREPAbu9IJlOc/IslZ5P1eV
         5h+6anpQ/rhYmSlgFEugDQ4RWrIguZHN/rBoMAEou7d/Su+I5Dhx/A2K7Yo5uezgvu6F
         O4U/XVv4c/n4OwSUszpV5G1m7xKcNdPCY3C9g=
MIME-Version: 1.0
In-Reply-To: <BANLkTinA6GTTjP=MsVcCqmCA1Tgh-6bHjA@mail.gmail.com>
References: <BANLkTi=fFg6+3DcBNwEOex0jASf1WiBRDQ@mail.gmail.com>
	<4DB4E94C.2060505@lwfinger.net>
	<BANLkTinA6GTTjP=MsVcCqmCA1Tgh-6bHjA@mail.gmail.com>
Date: Mon, 25 Apr 2011 19:14:15 +0800
Message-ID: <BANLkTimLVPHdpcGqnZP-LNVT7Jp=XZ+gvw@mail.gmail.com>
Subject: Re: r8712u cannot set essid
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: lkml <linux-kernel@vger.kernel.org>, wlanfae@realtek.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 25, 2011 at 12:32 PM, Jeff Chua <jeff.chua.linux@gmail.com> wrote:

Larry,

Saw this post from you about putting the r8712u into "ap mode" below ...

Larry Finger | 27 Jan 15:39
> Re: unable to put RTL8192SU in master mode
> Master mode with r8712u has not been tested. The driver I started with has a
> configuration parameter that enables "AP mode". I kept that in, but I do not
> know if it works.

Here's what I tried, but not sure if this is the correct way to put
into AP mode ...

# modprobe r8712u network_mode=4

Then, I ran ...

# wpa_supplicant -d -D hostap -i wlan0 -c /etc/wpa42.conf

wpa_driver_hostap_set_wpa: enabled=1
...
wpa_driver_hostap_set_key: alg=none key_idx=0 set_tx=0 seq_len=0 key_len=0
ioctl[PRISM2_IOCTL_HOSTAPD]: Operation not supported
Failed to set encryption.
wpa_driver_hostap_set_key: alg=none key_idx=1 set_tx=0 seq_len=0 key_len=0
ioctl[PRISM2_IOCTL_HOSTAPD]: Operation not supported
Failed to set encryption.
wpa_driver_hostap_set_key: alg=none key_idx=2 set_tx=0 seq_len=0 key_len=0
ioctl[PRISM2_IOCTL_HOSTAPD]: Operation not supported
Failed to set encryption.
wpa_driver_hostap_set_key: alg=none key_idx=3 set_tx=0 seq_len=0 key_len=0
ioctl[PRISM2_IOCTL_HOSTAPD]: Operation not supported
Failed to set encryption.
...
wlan0: AP mode support not included in the build


Is wpa_supplicant saying the r8172u is not in AP mode?

Regarding setting essid I posted earlier, it seems the ssid can be set
when wlan0 is "associated" to an AP. But, not set if not associated.
With IBSS mode, there's no association to begin with, so the SSID
can't be set. Make sense?


Jeff
