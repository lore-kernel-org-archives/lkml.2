Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760996Ab1EAQkX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 12:40:23 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42106 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755204Ab1EAQkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 12:40:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-pgp-id:x-archive
         :user-agent;
        b=pE1nPc86MhReiNXho8pA5jaA/PP13S++dHu3Xi+ICPta7jRfSzKUsl0CPgpwGq8DYi
         s+R31StuxEjZUtvgxRq8Yuvww5WcxrdhZY+axsAShj08aSVrt9dDxUuuBaeFD9UsNLIG
         SiGsxTGkC3lWO5NITcztxAnQSZYXCdyPKcnlo=
Date: Sun, 1 May 2011 18:40:14 +0200
From: clemens fischer <ino-news@spotteswoode.dnsalias.org>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, wlanfae@realtek.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: r8712u: Fix driver to support ad-hoc mode
Message-ID: <20110501164013.GA4188@spotteswoode.de.eu.org>
References: <BANLkTin7Nw1ZjK8UHfypHXY5ZuzafXnJbQ@mail.gmail.com>
 <20110428201527.GA3738@spotteswoode.de.eu.org>
 <BANLkTimi4cUzS5-r_ofzLnjbVtNNjwD69Q@mail.gmail.com>
 <20110429211548.GA4351@spotteswoode.de.eu.org>
 <BANLkTi=-4NaMCMEDxj3CVg6iAmS3DGm0Qw@mail.gmail.com>
 <20110429222548.GC4351@spotteswoode.de.eu.org>
 <BANLkTimK-i7aBrFJjGfxQkz-YkLd-ftCnA@mail.gmail.com>
 <20110430014157.GB3719@spotteswoode.de.eu.org>
 <20110430122115.GA3694@spotteswoode.de.eu.org>
 <BANLkTimZ7gFiQyiYpo1SBirBhpkT427o2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTimZ7gFiQyiYpo1SBirBhpkT427o2Q@mail.gmail.com>
X-PGP-ID: 0x214190AF
X-Archive: encrypt=none
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Jeff Chua:

> On Sat, Apr 30, 2011 at 8:21 PM, clemens fischer
>
> > I still wish "r8712u" would let me use wireless-tools/iwconfig, but
> > I can live with "wpa_supplicant(8)".
>
> You wish just came true. To use plain iwconfig with wpa_supplicant,
> here's what you need to do ...
> just remember that the "order" is important ... you must set the
> encryption key "before" you bring up the interface!!! This applies to
> non-realtek devices as well.
>
> # modprobe r8712u
> # iwconfig wlan0 key restricted your-encrypted-password-same-as-wpa-psk-string
> # ifconfig wlan0 up   <-- this comes after you set up the encryption above!
> # iwconfig wlan0 mode ad-hoc essid your-ssid
> # ifconfig wlan0 your-ip
> # dhcpd wlan0

Yet not all parameters can be set with "iwconfig(8)":

  iwconfig wlan0 essid mana mode Ad-Hoc channel 5 power 5s all key restricted s:xyz12
  udevd-work[3589]: '/root/bin/wlan-dev.sh' (stderr) 'Error for wireless
    request "Set Power Management" (8B2C) :'
  udevd-work[3589]: '/root/bin/wlan-dev.sh' (stderr) ' SET failed on
    device wlan0 ; Operation not permitted.'

Iwconfig(8) lets me set the power saving mode and which type of packets
wake the device up.  wpa_supplicant(8) has nothing like this, it manages
channels and WPE keys and does this well, but not power settings.

This was my reason for prefering iwconfig(8) in the first place after
realizing that this little USB WLAN stick cannot be used for WPE, only
for Ad-hoc with WPA.


regards, clemens
