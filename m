Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835Ab2D1Lqn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 07:46:43 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:61156 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905Ab2D1Lqk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 07:46:40 -0400
From: Steffen =?ISO-8859-1?Q?M=FCller?= <steffen.mueller@radio-frei.de>
To: opensuse-factory@opensuse.org
Cc: Alan Stern <stern@rowland.harvard.edu>, Jiri Slaby <jslaby@suse.cz>,
        stable@kernel.org, Greg KH <greg@kroah.com>,
        USB list <linux-usb@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [opensuse-factory] Re: usb midi keyboard broken [3.3.3 regression] [SOLUTION]
Date: Sat, 28 Apr 2012 13:45:56 +0200
Message-ID: <14061824.J155VMHgKz@thinkpadsm.rf-studio>
User-Agent: KMail/4.8.2 (Linux/3.3.3-21-desktop; KDE/4.8.2; x86_64; ; )
In-Reply-To: <Pine.LNX.4.44L0.1204271122550.1690-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1204271122550.1690-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
X-Provags-ID: V02:K0:qiWGh6SVgr1fAxzJs1fcQApQbJ7XsDaWqCY5ktk1yxk
 +yAM36SNScOr9W/7rQCC2HZwlBKg+3nMW92twcGfmDMT6nbupC
 KycM2CcXm0K4Hp6yWPO4iIS2qwJGUKTZUcbRwVj0OJUYi6U1/Q
 GN+MwuZZylB/XdTebQ8Jd4h2K++iXDjPHlldZKoM8hRRbHCrP/
 IDHOYEtvlUbLqbfeDQIRa265HKwY6bMYSGfGACLQTYF2+3DI9t
 iBXcDXHI9Y+eCg67Ykr1PRpj4DGTVMf6saLGc5hk4vwxJUfCrk
 EmkFszvQtooploubOpU+1Eie7fmsvj1M09qhRb9FvuKb6ZjH9w
 1yadvGAcBzU9vetyN0csW1q3f9InzacKZFO9/kacG5cuOspbaC
 kUOzd6NXnOTJg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oh man! After look and try many usr relevant settings I found the malfactor: 
tlp usb autosuspend settings.

I use tlp (energy-saving tools for thinkpad laptops) and they autosuspend usb 
devices by default. Now I have blacklisted my midi keyboard an all is good. I 
can reproduce the problem this way. Seems so that the midi keyboard doesn't 
wake up if it once sleeping.

For all with similar problems: 
edit /etc/default/tlp and set USB_BLACKLIST="<device id from usbls>" or 
disable usb autosuspend entirely with USB_AUTOSUSPEND=0

thanks and sorry for the bother.
steffen


Am Freitag, 27. April 2012, 11:26:12 schrieb Alan Stern:
> On Fri, 27 Apr 2012, Jiri Slaby wrote:
> > On 04/27/2012 09:37 AM, Steffen M�ller wrote:
> > >> [  224.418062] usb 1-1.3: USB disconnect, device number 6 [
> > >> 227.662396] usb 1-1.3: new full-speed USB device number 7 using
> > >> ehci_hcd [  227.749541] usb 1-1.3: New USB device found,
> > >> idVendor=0763, idProduct=0192 [  227.749550] usb 1-1.3: New USB
> > >> device strings: Mfr=1, Product=2, SerialNumber=0 [  227.749556]
> > >> usb 1-1.3: Product: USB Keystation 88es [  227.749560] usb 1-1.3:
> > >> Manufacturer: M-Audio [  229.750236] ALSA midi.c:214 urb status
> > >> -32 [  229.750700] ALSA midi.c:214 urb status -32 [  229.750911]
> > >> ALSA midi.c:214 urb status -32 [  229.751175] ALSA midi.c:214 urb
> > >> status -32 [  229.751413] ALSA midi.c:214 urb status -32 [
> > >> 229.751659] ALSA midi.c:214 urb status -32 [  229.751910] ALSA
> > >> midi.c:214 urb status -32 [  229.752210] ALSA midi.c:214 urb
> > >> status -32 [  229.752459] ALSA midi.c:214 urb status -32 [
> > >> 229.752662] ALSA midi.c:214 urb status -32
> > 
> > Hmm... I suspect some USB patches added in 3.3.3... Alan, Greg, any ideas?
> > 
> > 3.3.2 is reported to work.
> 
> No ideas.  It would be good to see a usbmon trace, with as many other
> USB devices unplugged as possible.  Even better would be to see also a
> second usbmon trace from a working kernel.
> 
> Alan Stern
