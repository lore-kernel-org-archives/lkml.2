Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976Ab1K0GZW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 01:25:22 -0500
Received: from nbd.name ([46.4.11.11]:38221 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753050Ab1K0GZU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 01:25:20 -0500
Message-ID: <4ED1D7BE.7040401@openwrt.org>
Date: Sun, 27 Nov 2011 13:25:02 +0700
From: Felix Fietkau <nbd@openwrt.org>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Adrian Chadd <adrian@freebsd.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
        "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath9k: Revert change that broke AR928X on Acer Ferrari
 One
References: <CA+55aFyNUC+k1gp3MQkxQzernEzRZwYOH4EBnOq=6UiaJ2oh4A@mail.gmail.com> <201111250203.29786.rjw@sisk.pl> <201111262232.46195.rjw@sisk.pl> <201111262337.43771.rjw@sisk.pl> <CAJ-Vmo=yh_maZtccaBkqZwip-ubjR4U471ALPwYwTurMaQrZ9Q@mail.gmail.com>
In-Reply-To: <CAJ-Vmo=yh_maZtccaBkqZwip-ubjR4U471ALPwYwTurMaQrZ9Q@mail.gmail.com>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-11-27 8:16 AM, Adrian Chadd wrote:
> Hm, considering the origina patch did this:
> 
>         /* Clear Bit 14 of AR_WA after putting chip into Full Sleep mode. */
> -       if (AR_SREV_9300_20_OR_LATER(ah))
> -               REG_WRITE(ah, AR_WA,
> -                         ah->WARegVal & ~AR_WA_D3_L1_DISABLE);
> +       if (!AR_SREV_9480(ah))
> +               REG_WRITE(ah, AR_WA, ah->WARegVal & ~AR_WA_D3_L1_DISABLE);
> 
> .. something tells me that perhaps the correct statement is:
> 
> if (AR_SREV_9300_20_OR_LATER(ah) && !AR_SREV_9480(ah))
>     REG_WRITE() ...
> 
I checked again, the !AR_SREV_9480(ah) was intentionally removed in a
later change, so using AR_SREV_9300_20_OR_LATER(ah) is correct.

- Felix
