Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757887Ab0JLQyW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 12:54:22 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:41398 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441Ab0JLQyU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 12:54:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=OD8NLdQ4DzXrPUEIQfzpB8mXLxo0GJmsXuBi3R22N3SylVvCuxeBmp5/IiRSVzkqxZ
         iHRvJk2JBSo2o/xsuawYtjH0T4ndAJXn81jECODOeIPdKeUJaxgepTINvzWOutuD5vu1
         kQ5fq3ks+05G+2hDdUpIzQPrFShMLyfOyKjxk=
MIME-Version: 1.0
In-Reply-To: <1286895206-3030-1-git-send-email-linville@tuxdriver.com>
References: <20101012163519.a88f2040.sfr@canb.auug.org.au>
	<1286895206-3030-1-git-send-email-linville@tuxdriver.com>
Date: Tue, 12 Oct 2010 12:54:17 -0400
X-Google-Sender-Auth: 7t_EeWDYht8ZWF02mNFpJoNdYtg
Message-ID: <AANLkTikjp=dpOOfjnvg=ivkb40_dE+oRLSEkzrycwirV@mail.gmail.com>
Subject: Re: [PATCH] ath5k: fix build break from "ath5k: Print out opmode in debugfs"
From: Bob Copeland <me@bobcopeland.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Ben Greear <greearb@candelatech.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 12, 2010 at 10:53 AM, John W. Linville
<linville@tuxdriver.com> wrote:
> Without this and with CONFIG_ATH_DEBUG not set...
>
> ERROR: ".ath_opmode_to_string" [drivers/net/wireless/ath/ath5k/ath5k.ko] undefined!
>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
> Please don't make me commit such an ugly patch...
>
>  drivers/net/wireless/ath/ath5k/base.c  |    4 ++++
>  drivers/net/wireless/ath/ath5k/debug.c |    6 +++++-
>  2 files changed, 9 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
> index c9732a6..b839a6b 100644
> --- a/drivers/net/wireless/ath/ath5k/base.c
> +++ b/drivers/net/wireless/ath/ath5k/base.c
> @@ -562,10 +562,14 @@ static void ath_do_set_opmode(struct ath5k_softc *sc)
>  {
>        struct ath5k_hw *ah = sc->ah;
>        ath5k_hw_set_opmode(ah, sc->opmode);
> +#ifdef CONFIG_ATH_DEBUG
>        ATH5K_DBG(sc, ATH5K_DEBUG_MODE, "mode setup opmode %d (%s)\n",
>                  sc->opmode,
>                  ath_opmode_to_string(sc->opmode) ?
>                  ath_opmode_to_string(sc->opmode) : "UKNOWN");

>From the original patch: UKNOWN?

I guess making ath_opmode_to_string always around (no-op in non-debug case)
would also suffice.  (reads on...) ah, yes, Joe's patch does this.

-- 
Bob Copeland %% www.bobcopeland.com
