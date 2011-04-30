Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757533Ab1D3XIQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 19:08:16 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56665 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768Ab1D3XIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 19:08:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=uMo9mBPariH6r39wtN/OuYPTO13KtuiRls+dhNXWJ3N10WZlmyN11Om9zZNvKrHF2L
         +ZbmPPCJ8pJXrcw99MF+tl9i7GN8XgtVVn0Xb80vUQIUII4IsSq7YtuErftSG3mDTxHq
         4yR1BWzyUGR6gz5HhI5A2FAQLf39rjiC5Ic+g=
MIME-Version: 1.0
In-Reply-To: <20110430122115.GA3694@spotteswoode.de.eu.org>
References: <20110428150819.GA3713@spotteswoode.de.eu.org>
	<4DB9884F.10409@lwfinger.net>
	<BANLkTin7Nw1ZjK8UHfypHXY5ZuzafXnJbQ@mail.gmail.com>
	<20110428201527.GA3738@spotteswoode.de.eu.org>
	<BANLkTimi4cUzS5-r_ofzLnjbVtNNjwD69Q@mail.gmail.com>
	<20110429211548.GA4351@spotteswoode.de.eu.org>
	<BANLkTi=-4NaMCMEDxj3CVg6iAmS3DGm0Qw@mail.gmail.com>
	<20110429222548.GC4351@spotteswoode.de.eu.org>
	<BANLkTimK-i7aBrFJjGfxQkz-YkLd-ftCnA@mail.gmail.com>
	<20110430014157.GB3719@spotteswoode.de.eu.org>
	<20110430122115.GA3694@spotteswoode.de.eu.org>
Date: Sun, 1 May 2011 07:08:11 +0800
Message-ID: <BANLkTimZ7gFiQyiYpo1SBirBhpkT427o2Q@mail.gmail.com>
Subject: Re: [PATCH] staging: r8712u: Fix driver to support ad-hoc mode
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: clemens fischer <ino-news@spotteswoode.dnsalias.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, wlanfae@realtek.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 30, 2011 at 8:21 PM, clemens fischer
<ino-news@spotteswoode.dnsalias.org> wrote:
>> clemens fischer:
> Whatever I did late in the past night: sleeping ten hours helped a lot!
> I can now confirm that "r8712u" works in Ad-hoc mode using
> "wpa_supplicant(8)", it gets its IP from DHCP, connects everywhere and
> lets me get spam and all that.

Clemens,

Glad to head that!

> I still wish "r8712u" would let me use wireless-tools/iwconfig, but
> I can live with "wpa_supplicant(8)".

You wish just came true. To use plain iwconfig with wpa_supplicant,
here's what you need to do ...
just remember that the "order" is important ... you must set the
encryption key "before" you bring up the interface!!! This applies to
non-realtek devices as well.

# modprobe r8712u
# iwconfig wlan0 key restricted your-encrypted-password-same-as-wpa-psk-string
# ifconfig wlan0 up   <-- this comes after you set up the encryption above!
# iwconfig wlan0 mode ad-hoc essid your-ssid
# ifconfig wlan0 your-ip
# dhcpd wlan0

Larry, thanks again for your help getting me started on this. The
device is working great!

Jeff
