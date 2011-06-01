Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758777Ab1FAKVS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 06:21:18 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:61222 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758739Ab1FAKVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 06:21:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=YiR5uBVGm4kTUQ/qfvrGx6oJoMstKzieCZoMMI4+vgpxxlubA0L4HDiTQKy6SR+tKI
         YhbiAoXeYVb8NwUHxNgavL8EZBS025kMADNJH1xnbTZEigLU6pxHXpcdE+FAfRH0gzGZ
         S+fAVGqNVH8vCIpfo+M+wQLCBnQvKoM23cwFw=
Subject: Re: [PATCH 3/3] UBIFS: fix-up free space earlier
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Ben Gardiner <bengardiner@nanometrics.ca>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        "Matthew L. Creech" <mlcreech@gmail.com>
In-Reply-To: <546eb16b8aedc7708774ae66bffd6c1175331b49.1306780983.git.bengardiner@nanometrics.ca>
References: <cover.1306780983.git.bengardiner@nanometrics.ca>
	 <546eb16b8aedc7708774ae66bffd6c1175331b49.1306780983.git.bengardiner@nanometrics.ca>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Jun 2011 13:16:47 +0300
Message-ID: <1306923407.4405.94.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-30 at 14:56 -0400, Ben Gardiner wrote:
> The free space fixup is currently initiated during mount after the call to
> ubifs_write_master() which results in a write to PEBs; this has been observed
> with the patch 'assert no fixup when writing a node' applied:
> 
> Move the free space fixup on mount to before the calls to
> ubifs_recover_inl_heads() and ubifs_write_master(). This results in no
> assertions with the previously mentioned patch applied.
> 
> Signed-off-by: Ben Gardiner <bengardiner@nanometrics>
> CC: Matthew L. Creech <mlcreech@gmail.com>
> 
> ---
>  fs/ubifs/super.c |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
> index 89c8d33..531b9b7 100644
> --- a/fs/ubifs/super.c
> +++ b/fs/ubifs/super.c
> @@ -1285,6 +1285,12 @@ static int mount_ubifs(struct ubifs_info *c)
>  	if (err)
>  		goto out_lpt;
>  
> +	if (!c->ro_mount && c->space_fixup) {
> +		err = ubifs_fixup_free_space(c);
> +		if (err)
> +			goto out_infos;
> +	}

Tweaked the patch a bit to make sure 'init_constants_master()' is called
before we start fixing-up - this does not matter now but it is less
error prone. And pushed to the UBIFS git tree, thank you.

But please, do review my tweaks and test them. When you confirm it
works, I'll send a pull request to Linus.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

