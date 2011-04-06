Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756701Ab1DFTYv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 15:24:51 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:63954 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756616Ab1DFTYu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 15:24:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=D7YEKlHHyEtmeGBNR+BReIbNJ/tzmBvN5E4LFcQkz9hIEW1KBXKpd3RQBW3Feg2GJv
         sGurhm6As7SrECuq4dBfCu/zaJ+FgEI4XlSaOtWd0ErElsK632/D5TPVErAl8eVEFOIG
         +8f68riaPdRaO9mQR8oV4xcJ1gN0QelcWj4ec=
MIME-Version: 1.0
In-Reply-To: <1302117274-9986-1-git-send-email-nijs.michael@gmail.com>
References: <1302117274-9986-1-git-send-email-nijs.michael@gmail.com>
Date: Wed, 6 Apr 2011 21:24:50 +0200
Message-ID: <BANLkTin=N2gOcvbgngwZcLEGVK2qoyeLLw@mail.gmail.com>
Subject: Re: [PATCH 4/4] Staging: iio: accel : sca3000_ring: Fixing code
 styling issues
From: Belisko Marek <marek.belisko@gmail.com>
To: nijs.michael@gmail.com
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 6, 2011 at 9:14 PM,  <nijs.michael@gmail.com> wrote:
> From: Michael Nijs <nijs.michael@gmail.com>
>
> Fixed code styling issue.
>
> Signed-off-by: Michael Nijs <nijs.michael@gmail.com>
> ---
>  drivers/staging/iio/accel/sca3000_ring.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/staging/iio/accel/sca3000_ring.c b/drivers/staging/iio/accel/sca3000_ring.c
> index fd1c844..c872fdd 100644
> --- a/drivers/staging/iio/accel/sca3000_ring.c
> +++ b/drivers/staging/iio/accel/sca3000_ring.c
> @@ -91,7 +91,7 @@ static int sca3000_rip_hw_rb(struct iio_ring_buffer *r,
>
>        /* Convert byte order and shift to default resolution */
>        if (st->bpse == 11) {
> -               samples = (s16 *)(*data+1);
> +               samples = (s16*)(*data+1);
Strange. My output(latest 2.6.39-rc2):
./scripts/checkpatch.pl -f drivers/staging/iio/accel/sca3000_ring.c
ERROR: "(foo*)" should be "(foo *)"
#94: FILE: staging/iio/accel/sca3000_ring.c:94:
+		samples = (s16*)(*data+1);

So for me it seems it was correct and you post patch with change where
checkpatch will bark. Or am I missing something?
>                for (i = 0; i < (num_read/2); i++) {
>                        samples[i] = be16_to_cpup(
>                                        (__be16 *)&(samples[i]));
> --
> 1.7.2.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

thanks,

marek

-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
icq: 290551086
web: http://open-nandra.com
