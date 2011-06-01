Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758761Ab1FAKH4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 06:07:56 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52964 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758732Ab1FAKHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 06:07:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=H03yHIgap2aELNAYntQUM1EwB5jsxb497sVRJyjvtnYY89tApUzA/MjDPT5Iy6VnaQ
         gDwaqlu6Yvl0eCIZHJv1QKWi+lDWOkXBvIttITEFXb5byh8Ur65AQX9o53246mzIWJHc
         YoZkaxRRo2gc8mOyCBMsOhkq6becQ5TiBFA/I=
Subject: Re: [PATCH 1/3] UBIFS: assert no fixup when writing a node
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Ben Gardiner <bengardiner@nanometrics.ca>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        "Matthew L. Creech" <mlcreech@gmail.com>
In-Reply-To: <4a63933a3365daf8d1ec38d22c9029a949f3eccd.1306780983.git.bengardiner@nanometrics.ca>
References: <cover.1306780983.git.bengardiner@nanometrics.ca>
	 <4a63933a3365daf8d1ec38d22c9029a949f3eccd.1306780983.git.bengardiner@nanometrics.ca>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Jun 2011 13:03:29 +0300
Message-ID: <1306922609.4405.88.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-30 at 14:56 -0400, Ben Gardiner wrote:
> The current free space fixup can result in some writing to the UBI volume
> when the space_fixup flag is set.
> 
> To catch instances where UBIFS is writing to the NAND while the space_fixup
> flag is set, add an assert to ubifs_write_node().
> 
> Signed-off-by: Ben Gardiner <bengardiner@nanometrics.ca>
> 
> ---
>  fs/ubifs/io.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ubifs/io.c b/fs/ubifs/io.c
> index 166951e..db298de 100644
> --- a/fs/ubifs/io.c
> +++ b/fs/ubifs/io.c
> @@ -763,6 +763,8 @@ int ubifs_write_node(struct ubifs_info *c, void *buf, int len, int lnum,
>  	if (c->ro_error)
>  		return -EROFS;
>  
> +	ubifs_assert(!c->space_fixup);
> +

I've moved this assert upper to where all other assertions are placed.

I've also added this assertion to 'ubifs_wbuf_write_nolock()' because it
is the other often used write path.

And pushed to the UBIFS tree, thanks.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

