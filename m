Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755669Ab0LOXJ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 18:09:29 -0500
Received: from mail-iw0-f180.google.com ([209.85.214.180]:39405 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071Ab0LOXJ2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 18:09:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=dZCJ95g7YJimY1GsR/TlLVPGK0Sw2bnk9Vf5zw+jI5L+PDWEk2GeO7aRunay/ihS2y
         HdNYlWO8BAB1/DMFV+9D/tggHllvDa6ugPwbfrh1BNYZPRkr8cRhQeFK9DcaFbFaleUA
         YYfelcEo3ZSflhLr573dnegonT+ns/VEtiBeM=
MIME-Version: 1.0
In-Reply-To: <20101209070938.GA3949@amd>
References: <20101209070938.GA3949@amd>
Date: Wed, 15 Dec 2010 15:09:26 -0800
X-Google-Sender-Auth: zLOJT-3VuzDMPXRshiEPRXTbT1g
Message-ID: <AANLkTim=Hd_xhk4egrTq96rk0eCQRWOxEjcfxM53HwXq@mail.gmail.com>
Subject: Re: Big git diff speedup by avoiding x86 "fast string" memcmp
From: Tony Luck <tony.luck@intel.com>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 8, 2010 at 11:09 PM, Nick Piggin <npiggin@kernel.dk> wrote:
> +static inline int dentry_memcmp(const unsigned char *cs,
> +                               const unsigned char *ct, size_t count)
> +{
> +       while (count) {
> +               int ret = (*cs != *ct);
> +               if (ret)
> +                       return ret;
> +               cs++;
> +               ct++;
> +               count--;
> +       }
> +       return 0;
> +}

Since you are proposing a routine that only compares file
names - I wonder whether it would be faster to start at the
end and work backwards? If the filenames are the same,
it makes no difference - you have to look at all the bytes.
But if they are different you might bail out earlier. There
are many applications that stick a common prefix onto
the start of filenames (just look in "/lib" !), but I think it is
less common to add a suffix (longer than "." single letter).

-Tony
