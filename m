Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161259Ab2KNQre (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 11:47:34 -0500
Received: from zmail.sgconsulting.it ([174.143.207.116]:51578 "EHLO
	zmail.sgconsulting.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964820Ab2KNQrd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 11:47:33 -0500
Date: Wed, 14 Nov 2012 16:48:47 +0000 (UTC)
From: Forconi <forconi@wavecomm.it>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Message-ID: <624976355.1341772.1352911727159.JavaMail.root@zmail.sgconsulting.it>
In-Reply-To: <20121114115255.2dfaefc9@pyramind.ukuu.org.uk>
Subject: Re: KMS Framebuffer on Intel N2600 (GMA3600)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [213.243.236.19]
X-Mailer: Zimbra 7.1.4_GA_2555 (ZimbraWebClient - GC23 (Win)/7.1.4_GA_2555)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,
first of all, thanks for your support.

> So the panel backlight register is set to indicate that the
> brightness
> will be handled by the firmware in some other way and not by the
> graphics.
> Do you have ACPI backlight support in your kernel ? Do you have the
> LVDS
> panel enabled in the BIOS ?

This backlight problem appears only when I run linux with KMS framebuffer,
when I run linux without KMS framebuffer, the backlight is always on.

Yes, I have ACPI enabled and ACPI backlight enabled, but running:
echo 100 > /sys/class/backlight/psb-bl/brightness
won't change anything.
In the BIOS there isn't any section relative to Video or LVDS settings.

But, in the end, this means that the driver si correctly loaded and the 
framebuffer is running but the panel backlight is off?
In other words, I can't see anything only because the backlight is off?

> It could be the value hasn't been initialised when it should have
> been,
> it could be your hardware has some other interface for this.
> 
> If you look at cdv_device.c you'll see cdv_get_max_backlight() checks
> for
> this case. If you can find out what the value should be then you can
> substitute
> 
>         if (max == 0) {
>                 DRM_DEBUG_KMS("LVDS Panel PWM value is 0!\n");
>                 /* i915 does this, I believe which means that we
>                 should
>                  * smash PWM control as firmware will take control of
>                  it.
>         	return 1;
>         }
> 
> 
> with
> 	if (max == 0)
> 		max = max_value << 16;
> 
> and test that case. If that doesn't work then probably the backlight
> is
> wired some other way. If ACPI handles it you may be able to handle it
> that way. If it's a custom driver interface in Windows you may have a
> problem.
> 
> Alan
> 

I don't know which could be the maximum value, there are any standard values
for backlight settings? I could try setting some values and see what happens...



Thanks again for your help.

Regards,
Samuele.


-- 
Ing. Samuele Forconi
Responsabile Sviluppo SW
WaveComm S.r.l.
Sede legale: Via Donizetti 25, 53011 Castellina in Chianti (SI)
Sede operativa: Loc. Belvedere - Ingresso 2, 53034 Colle Val d'Elsa (SI)
Phone: (39) 0577 043101
Fax: (39) 0577 043101
Mobile: (39) 347 5899717
Skype: samueleforconi
E-mail: forconi@wavecomm.it
URL: www.wavecomm.it

_____________________________________________________________________________________________

Ai sensi del D. Lgs. n.196 del 30/06/2003, questo messaggio ed ogni suo allegato sono confidenziali e ad uso esclusivo del destinatario, il quale è l'unico autorizzato ad usarlo, copiarlo e, sotto la propria responsabilità, diffonderlo. Se il ricevente non è il destinatario diretto del presente messaggio, è pregato di contattare l'originario mittente e di cancellare questo messaggio ed ogni suo allegato dal sistema di posta. Se il ricevente non è il destinatario diretto del presente messaggio, sono vietati l'uso, la riproduzione, e la stampa di questo messaggio e di ogni suo allegato, nonché la diffusione del loro contenuto a qualsiasi altro soggetto.

For the D. Lgs. n.196 of 30/06/2003, this message and any attachment are confidential and privileged for the the recipient identified above, who only may use, copy and, under his/her responsibility, further disseminate it. If you are not the intended recipient, please contact the sender and delete this message and any attachment from your system. If you are not the intended recipient you must not use, copy or print this message or attachment or disclose the contents to any other person.
