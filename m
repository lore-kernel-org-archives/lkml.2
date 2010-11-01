Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560Ab0KATE0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 15:04:26 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:35947 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075Ab0KATEW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 15:04:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=FTybA6rQJFHHJerQvjOWeryGq6wPbf4HhNxFSZTzDrfVvWI/5Uz3jK7Vw4yezOaWpj
         NQqVRPtpTPqg4nLdM5sHxGUS34HgnitG7TDB2VcztBxbioFSTfGqSdTVhCtFR+Bu9jdx
         XGvsJ6ZWQcV2PdMd2eryHop0HMYxLtBiRqyqA=
MIME-Version: 1.0
In-Reply-To: <1288636877-7964-9-git-send-email-tdent48227@gmail.com>
References: <1288636877-7964-1-git-send-email-tdent48227@gmail.com>
	<1288636877-7964-9-git-send-email-tdent48227@gmail.com>
Date: Mon, 1 Nov 2010 21:04:21 +0200
X-Google-Sender-Auth: z5jarYm6ggWq53vfdgkUODF7LA4
Message-ID: <AANLkTimHpKYMt=UD-rnPk+yZyYUUw2SHs5g1uNr7H-1d@mail.gmail.com>
Subject: Re: [PATCH 08/29] Staging: yaffs2: yaffs_ecc: Add files
From: Pekka Enberg <penberg@kernel.org>
To: Tracey Dent <tdent48227@gmail.com>
Cc: greg@kroah.com, manningc2@actrix.gen.nz, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 1, 2010 at 8:40 PM, Tracey Dent <tdent48227@gmail.com> wrote:
> Adding files to yaffs2 directory.
>
> Signed-off-by: Tracey Dent <tdent48227@gmail.com>
> ---
>  drivers/staging/yaffs2/yaffs_ecc.c |  323 ++++++++++++++++++++++++++++++++++++
>  drivers/staging/yaffs2/yaffs_ecc.h |   44 +++++
>  2 files changed, 367 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/staging/yaffs2/yaffs_ecc.c
>  create mode 100644 drivers/staging/yaffs2/yaffs_ecc.h
>
> +
> +/* Count the bits in an unsigned char or a U32 */
> +
> +static int yaffs_count_bits(unsigned char x)
> +{
> +       int r = 0;
> +       while (x) {
> +               if (x & 1)
> +                       r++;
> +               x >>= 1;
> +       }
> +       return r;
> +}
> +
> +static int yaffs_count_bits32(unsigned x)
> +{
> +       int r = 0;
> +       while (x) {
> +               if (x & 1)
> +                       r++;
> +               x >>= 1;
> +       }
> +       return r;
> +}

Looks like bitmap_weight() to me.
