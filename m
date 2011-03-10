Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751346Ab1CJPw5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 10:52:57 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50098 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957Ab1CJPw4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 10:52:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=F4UBmpuo6dSCF9NGn3ngUsPCs/H+mZ4NMZjXdmcAsKw7gV8euoIY9Pw9b1pvzE1Vve
         VFz+zCUILs3AYastnIbR1sFgTobG7KtwbPItkAD+llCKbIzEHXvqpO/ZemX92v2jKugc
         uOEkwunStAiT8v8JPxGJyLPH+6Z39B7szt4Hs=
MIME-Version: 1.0
In-Reply-To: <BF5CB373A5A948A2976AE727EA3F6B70@hacdom.okisemi.com>
References: <F5323EE7947C4C1CB0868F843FB4F917@hacdom.okisemi.com>
 <AANLkTim4z7vfyNceLYZhGzpYaECeSfLOYjzEhT9JFvJH@mail.gmail.com> <BF5CB373A5A948A2976AE727EA3F6B70@hacdom.okisemi.com>
From: Rabin Vincent <rabin@rab.in>
Date: Thu, 10 Mar 2011 21:22:15 +0530
X-Google-Sender-Auth: UuAT5AkQg9yTqRhYVkIHZH3oNf0
Message-ID: <AANLkTimAQoUw1okbB7hSz7bxF7XwjwERLzh8QFTS01m0@mail.gmail.com>
Subject: Re: About GPIO interrupt function with sysfs
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        "Ewe, Kok Howg" <kok.howg.ewe@intel.com>,
        "Lai, Mee Sim" <mee.sim.lai@intel.com>,
        Toshiharu Okada <toshiharu-linux@dsn.okisemi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 2, 2011 at 12:08, Tomoya MORINAGA
<tomoya-linux@dsn.okisemi.com> wrote:
> Seeing gpio_to_irq@arch/x86/include/asm/gpio.h, like below.
>
> static inline int gpio_to_irq(unsigned int gpio)
> {
>        return -ENOSYS;
> }

That's not what is in latest mainline:

commit 718c45bd1aa80c4e23a0ee204c973e3014e94708
Author: Alek Du <alek.du@intel.com>
Date:   Tue Jan 11 10:55:32 2011 +0000

    x86/gpio: Implement x86 gpio_to_irq convert function

    We need this for x86 MID platforms where GPIO interrupts are
    used. No special magic is needed so the default 1:1 behaviour
    will do nicely.

    Signed-off-by: Alek Du <alek.du@intel.com>
    Signed-off-by: Jacob Pan <jacob.jun.pan@intel.com>
    Signed-off-by: Alan Cox <alan@linux.intel.com>
    LKML-Reference: <20110111105439.24448.69863.stgit@bob.linux.org.uk>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/arch/x86/include/asm/gpio.h b/arch/x86/include/asm/gpio.h
index 49dbfdf..91d915a 100644
--- a/arch/x86/include/asm/gpio.h
+++ b/arch/x86/include/asm/gpio.h
@@ -38,12 +38,9 @@ static inline int gpio_cansleep(unsigned int gpio)
 	return __gpio_cansleep(gpio);
 }

-/*
- * Not implemented, yet.
- */
 static inline int gpio_to_irq(unsigned int gpio)
 {
-	return -ENOSYS;
+	return __gpio_to_irq(gpio);
 }

 static inline int irq_to_gpio(unsigned int irq)
