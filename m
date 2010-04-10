Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726Ab0DJASp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 20:18:45 -0400
Received: from mail-qy0-f179.google.com ([209.85.221.179]:51642 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755633Ab0DJASl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 20:18:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=xG+CPEtYZ5ugmmR/krH6lK8FeYpnRg5cTHvOLKoyUmRusW9mJZkVFXYyHXcVCfHFTP
         Kk1AV6u1ZWTDE97pTDdbxuznX9POSi1rPVnKisYdVpKsgjorZG5PZADtzH3jmnrp73jR
         r09mN/PzWdhoVaLesi16UtW540Gs1xKzqe4OE=
MIME-Version: 1.0
In-Reply-To: <4BBFB925.7080606@redhat.com>
References: <9e4733910912060952h4aad49dake8e8486acb6566bc@mail.gmail.com>
	 <9e4733910912151338n62b30af5i35f8d0963e6591c@mail.gmail.com>
	 <4BAB7659.1040408@redhat.com> <201004090821.10435.james@albanarts.com>
	 <1270810226.3764.34.camel@palomino.walls.org>
	 <4BBF253A.8030406@redhat.com>
	 <g2k829197381004091455m20368cc6r63df4a4f00d36b45@mail.gmail.com>
	 <1270851240.3038.51.camel@palomino.walls.org>
	 <4BBFB925.7080606@redhat.com>
Date: Fri, 9 Apr 2010 20:18:40 -0400
Message-ID: <l2y9e4733911004091718s4404d983o3894f78a75d996f3@mail.gmail.com>
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel IR 
	system?
From: Jon Smirl <jonsmirl@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Andy Walls <awalls@radix.net>,
       Devin Heitmueller <dheitmueller@kernellabs.com>,
       James Hogan <james@albanarts.com>, Pavel Machek <pavel@ucw.cz>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Krzysztof Halasa <khc@pm.waw.pl>,
       hermann pitton <hermann-pitton@arcor.de>,
       Christoph Bartelmus <lirc@bartelmus.de>, j@jannau.net, jarod@redhat.com,
       jarod@wilsonet.com, kraxel@redhat.com, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
       superm1@ubuntu.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 9, 2010 at 7:32 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:

> [1] Yet, none of the in-hardware decoders allow resume, AFAIK. With a software
> decoder, the IR IRQ might be used to wake, but this means that everything,
> even a glitch, would wake the hardware, so this won't work neither.

On my embedded hardware there is 100KB of static RAM on the CPU die.
It is preserved even in deep sleep. An IR pulse can wake the CPU and
run code in this 100KB RAM. Then the CPU can decide whether it wants
to power on main RAM and restore the OS. But implementing this is
outside the scope of the Linux kernel.

In someways this is how an MSMCE behaves in suspend. There is code
running on the MCU inside the MSMCE receiver. Too bad we can't tell it
a pattern to watch for and then trigger USB wake up. It is easy to
build a MSMCE clone, maybe someone will clone it and add the wakeup
pattern match. An enterprising hacker can probably change the firmware
in the existing devices.

-- 
Jon Smirl
jonsmirl@gmail.com
