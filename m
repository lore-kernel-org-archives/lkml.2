Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758813Ab1EMK7X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 06:59:23 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36225 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030Ab1EMK7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 06:59:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=Y+PVyVGMvxKCVV5Ss29tJQ0JCRWotfG4x5vH6GqyMq73OOyK89/IPSifc21hmxL9Zx
         +Ax/+SzqWdhj8mKPdFsWWtBgCKbPe+oX5TV986+jsgmtyMPNc0wJVNssNmuMoyXk9p2D
         3UOZGRUtDr6NahCkArHMFy7vVOjmJ3xzKHDFE=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1105131138460.2831@ionos>
References: <1290060899-9786-1-git-send-email-ccross@android.com>
	<AANLkTimCuV5N0jr8c949uONEvieQ5MDZ9KHDXtneG5AT@mail.gmail.com>
	<4D70BE9D.4000507@stericsson.com>
	<AANLkTin7ZXYALOy_jk1uR3SbZA51nSnU-ncSjG+n_RPn@mail.gmail.com>
	<4D714C17.7080102@gmail.com>
	<AANLkTims4e7o0sPxVnN0D1mNWDH7uC9q=pBQrBoad2os@mail.gmail.com>
	<eea425c066cc69c30f118fb102fff43e@mail.gmail.com>
	<AANLkTi=KcmqmghVxhwGvv79heRU3C+TC-v2VnWSWt7bU@mail.gmail.com>
	<7e9fafa016bfe536ccc373fc2cc7ba61@mail.gmail.com>
	<AANLkTinRNG4nTjh15a2tuJt_iDboHUtomxemSjY+6DcD@mail.gmail.com>
	<AANLkTikkcYw66MiJO9Bpm+De=XD2-1MFxm-CUPp6sMqL@mail.gmail.com>
	<BANLkTi=-T6P0KrsQ8+Ot_inq1JabY62LvA@mail.gmail.com>
	<alpine.LFD.2.02.1105131138460.2831@ionos>
Date: Fri, 13 May 2011 12:59:20 +0200
X-Google-Sender-Auth: N6_knX7dE1MPezXlIzmmn8EYj7I
Message-ID: <BANLkTikY9VBXuT78k3GFkeG+q=ppMsz3iQ@mail.gmail.com>
Subject: Re: [PATCH] ARM: twd: Adjust localtimer frequency withcpufreqnotifiers
From: Linus Walleij <linus.walleij@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>, Colin Cross <ccross@android.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        Harald Gustafsson <harald.gustafsson@ericsson.com>,
        linux-kernel@vger.kernel.org,
        Rickard ANDERSSON <rickard.andersson@stericsson.com>,
        martin persson <martin.persson@stericsson.com>,
        Varun Swara <Varun.Swara@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        =?ISO-8859-1?Q?Jonas_=C5berg?= <jonas.aberg@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/13 Thomas Gleixner <tglx@linutronix.de>:

> Does the following work for you ?

This patch is interesting because it uses calc_mult_shift() and the current
localtimer driver for TWD (arch/arm/kernel/smp_twd.c) still uses hardcoded
mult+shift.

So this patch in combination with TGLX add-on in the CPUfreq path would
eliminate the need of using the prescaler at all, which is a more appealing
solution to me for one, since it results in less code.

Colin, do you think it will work? Or was there some specific reason to use
a dynamic prescaler instead of doing things like this?

Yours,
Linus Walleij
