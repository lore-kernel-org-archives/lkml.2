Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220Ab1KVA46 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 19:56:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39896 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112Ab1KVA45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 19:56:57 -0500
Date: Mon, 21 Nov 2011 16:56:55 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: wangyanqing <udknight@gmail.com>
Cc: warns@pre-sense.de, linux-kernel@vger.kernel.org, tj@kernel.org,
        jaxboe@fusionio.com, Matt Domsch <Matt_Domsch@dell.com>
Subject: Re: [PATCH] fs:partitions:efi.c: correct misuse force_gpt
Message-Id: <20111121165655.18224b14.akpm@linux-foundation.org>
In-Reply-To: <20111122004434.GA6584@udknight.homenetwork>
References: <20111122004434.GA6584@udknight.homenetwork>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Nov 2011 08:44:34 +0800
wangyanqing <udknight@gmail.com> wrote:

> The primary gpt header maybe broken, so we should
> check the alternate gpt header no matter whether
> there is a gpt boot parameter.(The alternate gpt header
> is for this way).
> 
> Signed-off-by: Wang YanQing <udknight@gmail.com>
> ---
>  fs/partitions/efi.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/partitions/efi.c b/fs/partitions/efi.c
> index 6296b40..53fd92f 100644
> --- a/fs/partitions/efi.c
> +++ b/fs/partitions/efi.c
> @@ -553,7 +553,7 @@ static int find_valid_gpt(struct parsed_partitions *state, gpt_header **gpt,
>  		good_agpt = is_gpt_valid(state,
>  					 le64_to_cpu(pgpt->alternate_lba),
>  					 &agpt, &aptes);
> -        if (!good_agpt && force_gpt)
> +        if (!good_agpt)
>                  good_agpt = is_gpt_valid(state, lastlba, &agpt, &aptes);
>  
>          /* The obviously unsuccessful case */

Please Cc Matt on patches to efi.c.

Neither scripts/get_maintainer.pl nor ./MAINTAINERS know that Matt
knows about efi.c, which is unfortunate.  But his name and email address are
right there at the top of the file.

