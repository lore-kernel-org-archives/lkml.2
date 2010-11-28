Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958Ab0K1Sjl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 13:39:41 -0500
Received: from bof-2.saar.de ([192.109.53.146]:52682 "EHLO oknodo.bof.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753859Ab0K1Sji (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 13:39:38 -0500
X-Greylist: delayed 2032 seconds by postgrey-1.27 at vger.kernel.org; Sun, 28 Nov 2010 13:39:38 EST
Subject: Re: back light conflict i915 vs dell-laptop
From: Patrick Schaaf <bof@bof.de>
To: Dan Carpenter <error27@gmail.com>
Cc: chris@chris-wilson.co.uk, mjg@redhat.com, rpurdie@rpsys.net,
        kernelorg@bof.de, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20101125093301.GT1522@bicker>
References: <20101125093301.GT1522@bicker>
Content-Type: multipart/mixed; boundary="=-JvNTVBnMz1fwlhXmIrRp"
Date: Sun, 28 Nov 2010 19:05:27 +0100
Message-ID: <1290967527.4456.8.camel@lat1>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
X-Spam_score: -4.4
X-Spam_score_int: -43
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-JvNTVBnMz1fwlhXmIrRp
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Thu, 2010-11-25 at 12:33 +0300, Dan Carpenter wrote:
> Patrick Schaaf has reported that the i915 driver is setting his
> backlight very dim when he starts GDM.
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=23472
> 
> It should be the dell-laptop platform driver controlling his backlight.
> 
> Gnome tries to restore the backlight settings through the dell_laptop
> interface in sysfs but it fails.  (Because the platform hardware refuses
> to set the settings to what it thinks they already are).

As far as my instrumentation showed, gnome did try no such thing - there
were no setting calls through the backlight interface when I switch
between the GDM screen and text console.

I have now run with drm.debug=0x07 and noticed get/set backlight PWM
messages from intel_panel_get/set_backlight which became lower and lower
in value for each successive switching between GDM login screen and text
console, until reaching a low point and overflowing to 255255.

I append the extract of these kernel messages, as well as putting them
in the bugzilla entry linked above.

Hope this helps clarify the problems I'm seeing.

best regards
  Patrick



--=-JvNTVBnMz1fwlhXmIrRp
Content-Disposition: attachment; filename="intel_panel_..._backlight"
Content-Type: text/plain; name="intel_panel_..._backlight"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Nov 28 18:43:17 lat1 kernel: [   61.454973] [drm:intel_panel_get_backlight], get backlight PWM = 127500
Nov 28 18:43:17 lat1 kernel: [   61.672115] [drm:intel_panel_set_backlight], set backlight PWM = 127500
Nov 28 18:43:25 lat1 kernel: [   69.659366] [drm:intel_panel_get_backlight], get backlight PWM = 63627
Nov 28 18:43:25 lat1 kernel: [   69.876223] [drm:intel_panel_set_backlight], set backlight PWM = 63627
Nov 28 18:45:02 lat1 kernel: [  166.642624] [drm:intel_panel_get_backlight], get backlight PWM = 126735
Nov 28 18:45:02 lat1 kernel: [  166.861225] [drm:intel_panel_set_backlight], set backlight PWM = 126735
Nov 28 18:45:06 lat1 kernel: [  169.869343] [drm:intel_panel_get_backlight], get backlight PWM = 63246
Nov 28 18:45:06 lat1 kernel: [  170.086225] [drm:intel_panel_set_backlight], set backlight PWM = 63246
Nov 28 18:50:24 lat1 kernel: [  488.561922] [drm:intel_panel_get_backlight], get backlight PWM = 31563
Nov 28 18:50:24 lat1 kernel: [  488.780228] [drm:intel_panel_set_backlight], set backlight PWM = 31563
Nov 28 18:50:29 lat1 kernel: [  492.905273] [drm:intel_panel_get_backlight], get backlight PWM = 15776
Nov 28 18:50:29 lat1 kernel: [  493.122220] [drm:intel_panel_set_backlight], set backlight PWM = 15776
Nov 28 18:50:45 lat1 kernel: [  509.449869] [drm:intel_panel_get_backlight], get backlight PWM = 7888
Nov 28 18:50:45 lat1 kernel: [  509.667228] [drm:intel_panel_set_backlight], set backlight PWM = 7888
Nov 28 18:50:48 lat1 kernel: [  512.061427] [drm:intel_panel_get_backlight], get backlight PWM = 3944
Nov 28 18:50:48 lat1 kernel: [  512.278220] [drm:intel_panel_set_backlight], set backlight PWM = 3944
Nov 28 18:50:54 lat1 kernel: [  518.938610] [drm:intel_panel_get_backlight], get backlight PWM = 1972
Nov 28 18:50:55 lat1 kernel: [  519.156232] [drm:intel_panel_set_backlight], set backlight PWM = 1972
Nov 28 18:50:58 lat1 kernel: [  522.665295] [drm:intel_panel_get_backlight], get backlight PWM = 986
Nov 28 18:50:58 lat1 kernel: [  522.883222] [drm:intel_panel_set_backlight], set backlight PWM = 986
Nov 28 18:51:04 lat1 kernel: [  528.338612] [drm:intel_panel_get_backlight], get backlight PWM = 493
Nov 28 18:51:04 lat1 kernel: [  528.557235] [drm:intel_panel_set_backlight], set backlight PWM = 493
Nov 28 18:51:07 lat1 kernel: [  531.697225] [drm:intel_panel_get_backlight], get backlight PWM = 246
Nov 28 18:51:07 lat1 kernel: [  531.915244] [drm:intel_panel_set_backlight], set backlight PWM = 246
Nov 28 18:51:20 lat1 kernel: [  544.747370] [drm:intel_panel_get_backlight], get backlight PWM = 123
Nov 28 18:51:20 lat1 kernel: [  544.965241] [drm:intel_panel_set_backlight], set backlight PWM = 123
Nov 28 18:51:24 lat1 kernel: [  548.220386] [drm:intel_panel_get_backlight], get backlight PWM = 61
Nov 28 18:51:24 lat1 kernel: [  548.437215] [drm:intel_panel_set_backlight], set backlight PWM = 61
Nov 28 18:51:31 lat1 kernel: [  555.916888] [drm:intel_panel_get_backlight], get backlight PWM = 30
Nov 28 18:51:32 lat1 kernel: [  556.134239] [drm:intel_panel_set_backlight], set backlight PWM = 30
Nov 28 18:51:35 lat1 kernel: [  559.138346] [drm:intel_panel_get_backlight], get backlight PWM = 15
Nov 28 18:51:35 lat1 kernel: [  559.355242] [drm:intel_panel_set_backlight], set backlight PWM = 15
Nov 28 18:51:40 lat1 kernel: [  564.929606] [drm:intel_panel_get_backlight], get backlight PWM = 7
Nov 28 18:51:41 lat1 kernel: [  565.148225] [drm:intel_panel_set_backlight], set backlight PWM = 7
Nov 28 18:51:45 lat1 kernel: [  569.509391] [drm:intel_panel_get_backlight], get backlight PWM = 3
Nov 28 18:51:45 lat1 kernel: [  569.726226] [drm:intel_panel_set_backlight], set backlight PWM = 3
Nov 28 18:51:52 lat1 kernel: [  576.103569] [drm:intel_panel_get_backlight], get backlight PWM = 1
Nov 28 18:51:52 lat1 kernel: [  576.322226] [drm:intel_panel_set_backlight], set backlight PWM = 1
Nov 28 18:51:56 lat1 kernel: [  579.760386] [drm:intel_panel_get_backlight], get backlight PWM = 0
Nov 28 18:51:56 lat1 kernel: [  579.977224] [drm:intel_panel_set_backlight], set backlight PWM = 255255
Nov 28 18:52:12 lat1 kernel: [  596.022674] [drm:intel_panel_get_backlight], get backlight PWM = 127500
Nov 28 18:52:12 lat1 kernel: [  596.241232] [drm:intel_panel_set_backlight], set backlight PWM = 127500
Nov 28 18:52:15 lat1 kernel: [  599.502386] [drm:intel_panel_get_backlight], get backlight PWM = 63627
Nov 28 18:52:15 lat1 kernel: [  599.719217] [drm:intel_panel_set_backlight], set backlight PWM = 63627

--=-JvNTVBnMz1fwlhXmIrRp--

