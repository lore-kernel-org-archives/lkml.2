Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757888Ab0ENWcg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 18:32:36 -0400
Received: from mail-gx0-f217.google.com ([209.85.217.217]:64975 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757408Ab0ENWcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 18:32:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:message-id:from:to:in-reply-to:content-type
         :content-transfer-encoding:x-mailer:mime-version:subject:date:cc;
        b=hGeZbhTDtFCFpbjHxJgZVwDGGlmneR0X+Lq8R8SUOJtVMgK+J4rV2SFUuKZ7Q0lQEC
         t/J60HAizUsRCKiZi/j4Bn9r3yTXEe07l0m3Oijs/tbfw+k52yR9t7D6dBpUzw0uHRxk
         ujKj3RezFIqrFCvsevEEjc5AmPFW7cKMDKEHU=
References: <201005141520.30802.br1@einfach.org> <4BECEE3E.6090303@gmail.com> <201005141538.43416.br1@einfach.org> <4BED6F19.3040608@gmail.com> <20100514165325.GA28198@tux> <4BED8765.8040307@gmail.com> <AANLkTiky103uOz38yZPlLypEQ8DnkdCk1X3zPl9014Yi@mail.gmail.com> <67773379-350A-42D4-BEB5-DAC7D8277615@gmail.com> <20100514201339.GB28198@tux> <4638F7CF-1E00-411F-A086-BA30809E00BD@gmail.com> <20100514205253.GC28198@tux>
Message-Id: <B796B1C7-D7CC-457A-9C86-7C70EA9451CF@gmail.com>
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
In-Reply-To: <20100514205253.GC28198@tux>
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit
X-Mailer: iPhone Mail (7D11)
Mime-Version: 1.0 (iPhone Mail 7D11)
Subject: Re: ath9k: BUG kmalloc-8192: Poison overwritten
Date: Fri, 14 May 2010 15:32:48 -0700
Cc: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
       Bruno Randolf <br1@einfach.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org





On May 14, 2010, at 1:52 PM, "Luis R. Rodriguez"  
<lrodriguez@atheros.com> wrote:

> On Fri, May 14, 2010 at 01:21:34PM -0700, Justin P. Mattock wrote:
>> Eveything is on except ath5k
>> For debugging.
>
> Bleh, try this.
>
> diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/ 
> wireless/ath/ath9k/recv.c
> index 1ca42e5..3404198 100644
> --- a/drivers/net/wireless/ath/ath9k/recv.c
> +++ b/drivers/net/wireless/ath/ath9k/recv.c
> @@ -129,7 +129,7 @@ int ath_rx_init(struct ath_softc *sc, int nbufs)
>    common->rx_bufsize = roundup(IEEE80211_MAX_MPDU_LEN,
>                     min(common->cachelsz, (u16)64));
>
> -    ath_print(common, ATH_DBG_CONFIG, "cachelsz %u rxbufsize %u\n",
> +    printk("ATH9K: cachelsz %u rxbufsize %u\n",
>          common->cachelsz, common->rx_bufsize);
>
>    /* Initialize rx descriptors */
>
> Not sure why this is not printing, the common debug_mask should
> already be set here prior to this. Anyway this would force the
> print I want.
>
>  Luis

O.k appologize for the delay
(had to play limo driver),
Anyways here is the grep info:
ATH9K: cachelsz 256 rxbufsize 3904
(messg is the same before and after
Rrmod/modprobing with debug options)

Justin P. Mattock
