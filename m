Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151Ab1EQH4M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 03:56:12 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:53809 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565Ab1EQH4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 03:56:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=p+C83twPw+JPrDV66TFNgqhMsdo3/AzbqJdGWNOJi6BQAEbj155qv/y5kKuGhNo6fL
         wSuFnpejrg+R2FvNge3NYajzt3TqkdehZ5oO6tvRY7lCdmQBnp+BZSneG0ScHpYoRF85
         aNNVa/eY9n628n9/yIszoVKuzRKbAiok5oWLk=
MIME-Version: 1.0
In-Reply-To: <201105161421.52451@rk-nord.at>
References: <BANLkTimXkXCAKQGK2ysTRNN-xa4ZChxcHA@mail.gmail.com>
	<201105101308.24662@rk-nord.at>
	<s5h7h9s46of.wl%tiwai@suse.de>
	<201105161421.52451@rk-nord.at>
Date: Tue, 17 May 2011 15:56:06 +0800
X-Google-Sender-Auth: pu3ichxgEFvv5Nxed5KSp0fyFQM
Message-ID: <BANLkTikuBj0uCuyPRiDLD_iWypFN2MoTHQ@mail.gmail.com>
Subject: Re: i915/kms/backlight-combo mode problem
From: Michael Chang <mchang@novell.com>
To: Melchior FRANZ <melchior.franz@gmail.com>
Cc: Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org,
        Joey Lee <jlee@novell.com>, chris@chris-wilson.co.uk,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/16 Melchior FRANZ <melchior.franz@gmail.com>:

> I don't even know what an LBPC is, other than a variable named like that.
> So I'd need a hint for how to test that.

It resides at your vga adapter's pci configuration space, offset 0xf4.

You can know your LPBC value by:
  $ lspci -xxx -s 00:02.0 | awk '/^f0:/ {print $6}'

And alter it's value via setpci (assuming set it to max)
  $ setpci -s 00:02.0 F4.B=ff

I assume you've tried this .. as you report setpci works for you. :)

>From your new attached log, In booting phase your LPBC is set to 255
and actual brightness is maximum (255*2890=736950). I see no other
change after it until manual brightness change. This is a totally
reversed to your problem.

Could you help to get the LPBC value in the initial dark condition? If
it's not corresponds to 255, maybe something sneaks and changes it but
not logged.

[    3.125522] [drm:is_backlight_combination_mode],
BLM_COMBINATION_MODE = 1073741824
[    3.125525] [drm:intel_panel_get_max_backlight], max backlight PWM = 736950
[    3.125527] [drm:intel_panel_set_backlight], set backlight PWM = 736950
[    3.125529] [drm:is_backlight_combination_mode],
BLM_COMBINATION_MODE = 1073741824
[    3.125531] [drm:is_backlight_combination_mode],
BLM_COMBINATION_MODE = 1073741824
[    3.125533] [drm:intel_panel_get_max_backlight], max backlight PWM = 736950
[    3.125535] [drm:intel_panel_set_backlight], set backlight max = 736950
[    3.125537] [drm:intel_panel_set_backlight], set backlight lbpc = 255
[    3.125544] [drm:intel_panel_set_backlight], set backlight level = 2890

> Yes, that's the case. (Except that after closing the lid it's off again.)

Maybe this is another clue for root cause. Would it be convenient for
you to gather the log?

 1. $ dmesg -c
 2. Close the lid
 3. Open the lid
 4. $ dmesg > dmesg.lid

Thanks a lot,
Michael Chang
