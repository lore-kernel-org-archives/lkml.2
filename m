Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755259Ab1K0BQf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 20:16:35 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:43069 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755208Ab1K0BQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 20:16:33 -0500
MIME-Version: 1.0
In-Reply-To: <201111262337.43771.rjw@sisk.pl>
References: <CA+55aFyNUC+k1gp3MQkxQzernEzRZwYOH4EBnOq=6UiaJ2oh4A@mail.gmail.com>
	<201111250203.29786.rjw@sisk.pl>
	<201111262232.46195.rjw@sisk.pl>
	<201111262337.43771.rjw@sisk.pl>
Date: Sun, 27 Nov 2011 09:16:32 +0800
X-Google-Sender-Auth: iCTRnkOuPJVQNuSlCU_3VlrI4vA
Message-ID: <CAJ-Vmo=yh_maZtccaBkqZwip-ubjR4U471ALPwYwTurMaQrZ9Q@mail.gmail.com>
Subject: Re: [PATCH] ath9k: Revert change that broke AR928X on Acer Ferrari One
From: Adrian Chadd <adrian@freebsd.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
        "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hm, considering the origina patch did this:

        /* Clear Bit 14 of AR_WA after putting chip into Full Sleep mode. */
-       if (AR_SREV_9300_20_OR_LATER(ah))
-               REG_WRITE(ah, AR_WA,
-                         ah->WARegVal & ~AR_WA_D3_L1_DISABLE);
+       if (!AR_SREV_9480(ah))
+               REG_WRITE(ah, AR_WA, ah->WARegVal & ~AR_WA_D3_L1_DISABLE);

.. something tells me that perhaps the correct statement is:

if (AR_SREV_9300_20_OR_LATER(ah) && !AR_SREV_9480(ah))
    REG_WRITE() ...

?


Adrian
