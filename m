Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753097Ab1EQI6o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 04:58:44 -0400
Received: from smtpout06.highway.telekom.at ([195.3.96.89]:43573 "EHLO
	email.aon.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752068Ab1EQI6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 04:58:43 -0400
From: Melchior FRANZ <melchior.franz@gmail.com>
To: Michael Chang <mchang@novell.com>
Subject: Re: i915/kms/backlight-combo mode problem
Date: Tue, 17 May 2011 10:58:18 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.38.6; KDE/4.6.3; x86_64; ; )
Cc: Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org,
        Joey Lee <jlee@novell.com>, chris@chris-wilson.co.uk,
        dri-devel@lists.freedesktop.org
References: <BANLkTimXkXCAKQGK2ysTRNN-xa4ZChxcHA@mail.gmail.com> <201105161421.52451@rk-nord.at> <BANLkTikuBj0uCuyPRiDLD_iWypFN2MoTHQ@mail.gmail.com>
In-Reply-To: <BANLkTikuBj0uCuyPRiDLD_iWypFN2MoTHQ@mail.gmail.com>
X-Fingerprint: 9FFB C079 5B78 4F27 099C C6C6 7399 02D1 919B D903
X-PGP: http://members.aon.at/mfranz/melchior.franz
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201105171058.21652@rk-nord.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Michael Chang -- Tuesday 17 May 2011:
[LBPC]
> You can know your LPBC value by:
>   $ lspci -xxx -s 00:02.0 | awk '/^f0:/ {print $6}'
> 
> And alter it's value via setpci (assuming set it to max)
>   $ setpci -s 00:02.0 F4.B=ff
> 
> I assume you've tried this .. as you report setpci works for you. :)

Ahh, yes, indeed. This lspci line (almost) always shows a value that
corresponds with the actual backlight brightness, and both lines work
with and without acpi_osi=Linux. (Whereas adjustment via keys only works
*with* acpi_osi=Linux.)  (Tested with 2.6.39-rc7/bd1a643e10)



> Could you help to get the LPBC value in the initial dark condition? If
> it's not corresponds to 255, maybe something sneaks and changes it but
> not logged.

Initially (with acpi_osi=Linux) LPBC=0xff. After "brightness down"
it's 0x19, and after then pressing "brightness up" it's 0x01. The lowest
value I can achieve after pressing "brightness down" a few times is 0xe5,
the highest is 0x01. Neither 0xff nor 0x00 can be reached via keys, but
can (most of the time -- see below!) be set with the setpci line and give
the expected results, backlight off and fully on. ("display toggle" has
no effect on LBPC, btw.) 

Setting 0xFF doesn't always turn the backlight off, though! If LBPC is
at the (key) maximum 0x01, then setting 0xFF via setpci changes only the
LBPC value as shown by lspci, but the backlight isn't actually turned off!
If I then press "backlight darker" once (LBPC=0x19), then setting 0xFF
via setpci works again.



>  1. $ dmesg -c
>  2. Close the lid
>  3. Open the lid
>  4. $ dmesg > dmesg.lid

The results are:

[  188.571040] [drm:intel_panel_set_backlight], set backlight PWM = 736950
[  188.571048] [drm:is_backlight_combination_mode], BLM_COMBINATION_MODE = 1073741824
[  188.571054] [drm:is_backlight_combination_mode], BLM_COMBINATION_MODE = 1073741824
[  188.571059] [drm:intel_panel_get_max_backlight], max backlight PWM = 736950
[  188.571064] [drm:intel_panel_set_backlight], set backlight max = 736950
[  188.571069] [drm:intel_panel_set_backlight], set backlight lbpc = 255
[  188.571075] [drm:intel_panel_set_backlight], set backlight tmp(1) = 189399040
[  188.571080] [drm:intel_panel_set_backlight], set backlight tmp(2) = 189399040
[  188.571084] [drm:intel_panel_set_backlight], 
[  188.571088] [drm:intel_opregion_asle_intr], non asle set request??
[  188.571093] set backlight level = 2890

The backlight is off now, as always after closing/reopening the lid,
and LPBC=0xff.

m.



PS: I'd be willing to join an irc.freenode.net channel in case you or
    anyone else wants quicker ("live") responses to such queries.
